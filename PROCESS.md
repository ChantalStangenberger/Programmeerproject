# Process book

### Dag 1: 19 februari
* Vorige week heb ik de navigation flow al gemaakt voor de prototype versie.
* Begonnen met het maken van de login/signup schermen.

### Dag 2: 20 februari
* Ik wil graag gebruik maken van een facebook login en een google login. Hier heb ik vandaag vooral naar gekeken. Dit is wat lastiger te implementeren dan eerst gedacht.
* De email login werkt goed met firebase.

### Dag 3: 21 februari
* Verder gewerkt aan het loginscherm (met de facebook login).
* Daarnaast vandaag ook al gekeken naar de google maps API. Het is gelukt om de google maps kaart te tonen in de app.

### Dag 4: 22 februari
<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/loginscreen.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/forgotpassword.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/facebookpermission.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/facebookpermission2.PNG width="200">
* Facebooklogin goed werkend gekregen en daarnaast ook een 'forgot password?' optie toegevoegd, waarbij een mail met resetlink wordt gestuurd naar de gebruiker.

### Dag 5: 23 februari
* Vandaag gezorgd dat facebook grantedpermissions goed werkt. Wanneer de gebruiker geen toestemming geeft voor het gebruik van de op facebook bekende email, verschijnt er een error.
* Facebook email en naam opgeslagen in firebase. 
* Gezorgd dat de google zoekbalk goed werkt met behulp van google places.
<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/googleplaces%20zoekbalk.PNG width="200">

### Dag 6: 26 februari
* De indeling van het inloggen heb ik veranderd en daarnaast ook de layout aangepast.
* Ook heb ik alvast een app icoon gemaakt.
* Aparte error meldingen gemaakt bij het inloggen en gezorgd dat de toetsenbalk verwijnt wanneer er op return wordt gedrukt of elders op het scherm wordt geklikt.
* Gewerkt aan newfoodEvent: gezorgd dat alle velden werken en dat de gebruiker een afbeelding kan invoegen (ook data opgeslagen in firebase).
* Gekeken naar current locatie van de gebruiker en hoe dit op te slaan. Dit is nog niet helemaal gelukt.
<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/fototoevoegen.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/newfoodevent.PNG width="200">

### Dag 7: 27 februari
* De current locatie verschijnt op de kaart en er kan ook een marker worden toegevoegd voor de plaats van het event.
* Wanneer er op de save button wordt gedrukt, worden de coordinaten opgeslagen.
* Het zou beter zijn om adres gegevens op te slaan, maar dit is wat ingewikkelder. Hier kijk ik later nog naar.
<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/currentlocation.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/markerofeventplace.PNG width="200"><img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/eventplacesaved.PNG width="200">

### Dag 8: 2 maart
* Wat foutjes gehaald met betrekking tot select event location. Gezorgd dat er maar één marker te zien is op de kaart en dat wanneer de marker wordt gesaved de marker te zien blijft op dezelfde positie wanneer er geswitcht wordt tussen de schermen.
* Gezorgd dat overview events worden weergeven.
* Ik moet nog uitzoeken hoe firebase storage precies werkt. Nu worden de foto's overschreden en ik moet natuurlijk verschillende afbeeldingen kunnen laden.
* Ook gewerkt aan book event.

### Dag 9: 12 maart
* Gezorg dat nu ook het adres te zien is van de geselecteerde locatie bij event location. 
* Daarnaast gewerkt aan de eventdetails pagina, deze laat nu ook de locatie van het evenement zien met een grote cirkel, zodat de gebruikers van de app niet ieders adres kunnen achterhalen. 
* Ook aan de bookingconfirmation pagina gewerkt. Hierbij wil ik de naam van de organisator van het event weergeven in een label. Dit lukte nog niet zo goed.

### Dag 10: 14 maart
* Vandaag vooral veel aan de layout gedaan, overal constraints toegevoegd. 
* Ik kwam erachter dat ik een UItextview moet gebruiken ipv een UItextfield om de gebruiker meerdere regels te laten typen. Dit heb ik veranderd en hier ook wat informatie bij gezocht (maximum aantaal regels).


