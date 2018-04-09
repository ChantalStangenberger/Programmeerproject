//
//  NewFoodEventViewController.swift
//  DinebyMe!
//
//  Created by Chantal Stangenberger on 15-02-18.
//  Copyright © 2018 Chantal Stangenberger. All rights reserved.
//
//  https://blog.apoorvmote.com/change-textfield-input-to-datepicker/
//

import UIKit
import Firebase
import FirebaseStorage
import GoogleMaps
import Photos

class NewFoodEventViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var recipenameTextField: UITextField!
    @IBOutlet weak var recipecuisineTextField: UITextField!
    @IBOutlet weak var recipepriceTextField: UITextField!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var uploadimageButton: UIButton!
    @IBOutlet weak var addlocationButton: UIButton!
    @IBOutlet weak var addneweventButton: UIButton!
    @IBOutlet weak var eventdateTextField: UITextField!
    @IBOutlet weak var eventtimeTextField: UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    
    let databaseReference = Database.database().reference()
    let image = UIImage(named: "imagebackground")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipenameTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipecuisineTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        recipepriceTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventtimeTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        eventdateTextField.addBottomBorderWithColor(color: UIColor.darkGray, width: 1)
        
        recipepriceTextField.delegate = self

        addneweventButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if globalStruct.latitude != 0.0 || globalStruct.longitude != 0.0 {
            let savedLocation = CLLocationCoordinate2D(latitude: globalStruct.latitude, longitude: globalStruct.longitude)
            self.reverseGeocodeCoordinate(coordinate: savedLocation)
            addlocationButton.setTitle("change location", for: .normal)
        } else {
            locationLabel.text = "No location added yet"
            locationLabel.textColor = UIColor(red: 191/255, green: 191/255, blue: 198/255, alpha: 1)
            addlocationButton.setTitle("add location", for: .normal)
        }
    }
    
    @IBAction func addlocationButtonTapped(_ sender: AnyObject) {
        return
    }
    
    @IBAction func uploadimageButtonTapped(_ sender: AnyObject) {
        checkPermission {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }


    func checkPermission(hanler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // Access is already granted by user
            hanler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access is granted by user
                    hanler()
                }
            }
        default:
            print("Error: no access to photo album.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addImage.image = selectedImage
            addImage.contentMode = UIViewContentMode.scaleAspectFill
            dismiss(animated: true, completion: nil)
            uploadimageButton.setTitle("change image", for: .normal)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToFirebase(completion: @escaping (_ url: String?) -> Void) {
        let storageReference = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
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
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let dateResult = dateformatter.string(from: date)
        
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let timeResult = timeformatter.string(from: date)
        
        if recipenameTextField.text! == "" || recipecuisineTextField.text! == "" || recipepriceTextField.text! == "" || eventdateTextField.text! == "" || eventtimeTextField.text! == "" ||  locationLabel.text == "No location added yet" {
            let alert = UIAlertController(title: "Something went wrong", message: "Not all fields are completed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } else if (eventdateTextField.text?.compare(dateResult) == .orderedDescending) || (eventdateTextField.text?.compare(dateResult) == .orderedSame) && (eventtimeTextField.text?.compare(timeResult) == .orderedDescending) {
            
            let userId = Auth.auth().currentUser?.uid
            let key = databaseReference.childByAutoId().key
            
            saveImageToFirebase() { url in
                if url != nil {
                    let values = ["Recipename": self.recipenameTextField.text! as String, "Recipecuisine": self.recipecuisineTextField.text! as String, "Recipeprice": self.recipepriceTextField.text! as String, "Eventtime": self.eventtimeTextField.text! as String, "Eventdate": self.eventdateTextField.text! as String,"Eventdatetime": self.eventdateTextField.text! + "_" + self.eventtimeTextField.text!, "Latitudelocation": globalStruct.latitude, "Longitudelocation": globalStruct.longitude, "addImage": url! as String, "id": userId! as String ] as [String : Any]
                    
                    self.databaseReference.child("newEvent").child(key).setValue(values)
                        
                    let alert = UIAlertController(title: "Succeed", message: "Food event was succesfully added to the feed!", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    self.recipenameTextField.text = ""
                    self.recipecuisineTextField.text = ""
                    self.recipepriceTextField.text = ""
                    self.eventtimeTextField.text = ""
                    self.eventdateTextField.text = ""
                    
                    self.addImage.image = self.image
                    self.addImage.contentMode = UIViewContentMode.scaleToFill
                    self.locationLabel.text = "No location added yet"
                    self.locationLabel.textColor = UIColor(red: 191/255, green: 191/255, blue: 198/255, alpha: 1)
                    self.addlocationButton.setTitle("add location", for: .normal)
                    self.uploadimageButton.setTitle("upload image", for: .normal)
                    globalStruct.latitude = 0.0
                    globalStruct.longitude = 0.0
                }
            }
        } else {
            let alert = UIAlertController(title: "Something went wrong", message: "The date/time combination you chose is in the past", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
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
            self.locationLabel.contentMode = .scaleAspectFit
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func eventdateTextFieldStyle(_ sender: UITextField) {
        let date = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        let dateResult = dateformatter.string(from: date)
        eventdateTextField.text = dateResult
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewFoodEventViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func eventtimeTextFieldStyle(_ sender: UITextField) {
        let date = Date()
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let timeResult = timeformatter.string(from: date)
        eventtimeTextField.text = timeResult
        
        let timePickerView:UIDatePicker = UIDatePicker()
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        
        sender.inputView = timePickerView
        
        timePickerView.addTarget(self, action: #selector(NewFoodEventViewController.timePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        eventdateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func timePickerValueChanged(sender:UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        eventtimeTextField.text = timeFormatter.string(from: sender.date)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersIn:"0123456789.,").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
}
