//
//  NewFoodEventViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleMaps

class NewFoodEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var recipenameTextField: UITextField! = nil
    @IBOutlet weak var recipecuisineTextField: UITextField! = nil
    @IBOutlet weak var recipepriceTextField: UITextField! = nil
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var uploadimageButton: UIButton!
    @IBOutlet weak var addlocationButton: UIButton!
    @IBOutlet weak var addneweventButton: UIButton!
    @IBOutlet weak var eventdateTextField: UITextField! = nil
    @IBOutlet weak var eventtimeTextField: UITextField! = nil
    @IBOutlet weak var locationLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    let databaseReference = Database.database().reference()
    let image = UIImage(named: "imagebackground")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipenameTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipenameTextField.delegate = self
        recipecuisineTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipecuisineTextField.delegate = self
        recipepriceTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipepriceTextField.delegate = self
        eventtimeTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventtimeTextField.delegate = self
        eventdateTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        locationLabel.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventdateTextField.delegate = self
        
        addneweventButton.layer.cornerRadius = 4
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if globalStruct.latitude == 0.0 || globalStruct.longitude == 0.0 {
            locationLabel.text = "No location added yet"
        } else {
            let savedLocation = CLLocationCoordinate2D(latitude: globalStruct.latitude, longitude: globalStruct.longitude)
            self.reverseGeocodeCoordinate(coordinate: savedLocation)
        }
    }

    @IBAction func addlocationButtonTapped(_ sender: AnyObject) {
        return
    }
    
    @IBAction func uploadimageButtonTapped(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage.contentMode = .scaleAspectFit
            addImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    func saveImageToFirebase(completion: @escaping (_ url: String?) -> Void) {
        let storageReference = Storage.storage().reference().child("addImage.png")
        if let uploadData = UIImagePNGRepresentation(self.addImage.image!) {
            storageReference.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                }
            }
        }
    }
    
    @IBAction func addneweventButtonTapped(_ sender: AnyObject) {
        if recipenameTextField.text! == "" || recipecuisineTextField.text! == "" || recipepriceTextField.text! == "" || eventdateTextField.text! == "" || eventtimeTextField.text! == "" || addImage.image == image || locationLabel.text == "No location added yet" {
            let alert = UIAlertController(title: "Something went wrong", message: "Not all fields are completed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let userId = Auth.auth().currentUser?.uid
            let key = databaseReference.childByAutoId().key
            
            saveImageToFirebase() { url in
                if url != nil {
                    let values = ["Recipename": self.recipenameTextField.text! as String, "Recipecuisine": self.recipecuisineTextField.text! as String, "Recipeprice": self.recipepriceTextField.text! as String, "Eventtime": self.eventtimeTextField.text! as String, "Eventdate": self.eventdateTextField.text! as String, "Latitudelocation": globalStruct.latitude, "Longitudelocation": globalStruct.longitude, "addImage": url! as String, "id": userId! as String ] as [String : Any]
                    
                    self.databaseReference.child("newEvent").child(key).setValue(values)
                        
                    let alert = UIAlertController(title: "Succeed", message: "Food event was succesfully added to the feed!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.recipenameTextField.text = nil
                    self.recipecuisineTextField.text = nil
                    self.recipepriceTextField.text = nil
                    self.eventtimeTextField.text = nil
                    self.eventdateTextField.text = nil
                    self.addImage.image = self.image
                    self.locationLabel.text = "No location added yet"
                    self.locationLabel.textColor = UIColor(red: 191/255, green: 191/255, blue: 198/255, alpha: 1)
                    globalStruct.latitude = 0.0
                    globalStruct.longitude = 0.0
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    private func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            self.locationLabel.text = lines.joined(separator: "\n")
            self.locationLabel.textColor = UIColor.black
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
