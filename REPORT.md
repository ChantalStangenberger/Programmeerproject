# Programmeerproject: Dine by me!

Student: Chantal Stangenberger

Programmeerproject - start 29-01-2018

## Problem statement
Heb jij na een lange dag werken/college geen zin meer om te koken of alleen te eten? Dan biedt DinebyMe! de uitkomst.Met behulp van 
DinebyMe! kunnen mensen aangeven wat zij van plan zijn om die avond te gaan koken (met de bijbehorende kosten en specificaties). 
Hierop kunnen andere DinebyMe! gebruikers reageren en bij de aanbieder op bezoek gaan. 

<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/Homefeed.PNG width="200">

## Technical design
Vergelijkend met het design document heb ik verschillende aanpassingen gemaakt. Zo heb ik besloten om een algemeen beginscherm te maken. 
Vanuit hier kan er geklikt worden op een button om naar het loginscherm te gaan. Hier kan worden ingelogd met facebook of met email, maar
er ik ook een button waar de gebruiker op kan klikken om naar het signupscherm te gaan. Daarnaast is er nog een button met: forgot password?
Om eventueel een nieuw wachtwoord aan te vragen. 

Vanuit het inlogscherm of signupscherm komt de gebruiker terecht op de homefeedscherm. Hierop worden alle actieve events van andere gebruikers
weergeven. Daarnaast zijn er twee navigationbar items: een info button en een '+' button. De gebruiker kan informatie krijgen over de werking
van de app of een nieuw event toevoegen. Wanneer de gebruiker op de '+' button drukt, krijgt hij het newfoodeventscherm te zien waarop een 
nieuw event kan worden toegevoegd. Hier kan de gebruiker op een van de buttons klikken om een foto toe te voegen of een locatie. De 
'add location' button brengt de gebruiker naar het addlocationscherm, waar op een kaart de event locatie geselecteerd en opgeslagen kan worden.
Deze locatie wordt doorgestuurd naar het newfoodeventscherm. Wanneer alle velden zijn ingevuld kan de gebruiker het event toevoegen, door op 
'add new food event to feed' te klikken. Terug op het homefeedscherm kan de gebruiker een van de actieve events selecteren. De gebruiker komt 
dan op het eventdetailscherm, waarbij meer informatie over het event te vinden is. De 'request to book' button brengt de gebruiker op het 
bookconfirmationscherm. Hier is een kort overzicht als bevestiging te zien. Het event kan definitief geboekt worden door op 'confirm booking' 
te klikken.

In de app wordt gebruik gemaakt van een tabbar en alle schermen in het bovengenoemde stuk (vanaf het homefeedscherm) zijn terug te vinden 
onder de tab 'feed'. Daarnaast zijn er ook nog twee tabs: 'my bookings' en 'my events'. Bij beide tabs is gebruik gemaakt van een android-like
buttonbar. Dit zorgt ervoor dat er eenvoudig tussen twee verschillende tableviews kan worden geswitched. Bij 'my bookings' zijn dit de 'requested'
en de 'validated' schermen. Bij 'requested' worden de door de gebruiker aangevraagde en nog niet goedgekeurde events weergeven en bij 'validated'
worden de aangevraagde en goedgekeurde events weergeven. Bij het 'validated' scherm kan er worden geklikt op een event en een kaart met de
exacte event locatie wordt weergeven. Daarnaast bevatten zowel de 'my bookings' als de 'my events' schermen allebei een navigationbar item: de info
button. 

Het 'my events' scherm bevat naast de info button ook een sign out navigationbar item. De tableviews gebruikt onder de 'my events' tab zijn de 
'overview' en 'requests' schermen. Het 'overview' scherm geeft een overzicht van alle actieve events georganiseerd door de gebruiker. Wanneer
er op een van deze events wordt geklikt, wordt de guestlist weergeven. Onder het 'requests' scherm worden alle aanvragen van andere gebruikers,
die jouw event willen bezoeken weergeven. Dit verzoek kan worden geaccepteerd of verwijderd. Bij acceptatie, verschijnt bij deze gebruiker jouw
event onder zijn 'validated' scherm.

<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/Final%20classes%20.png width="1000">

In Firebase heb ik gebruikt gemaakt van de volgende structuur:
* acceptedRequests
  - recipename and hostid and eventtime and eventdate and userid
    - Control
    - Cuisine
    - Eventdate
    - Eventdatetime
    - Eventtime
    - Hostid
    - Image
    - Price
    - Recipename
    - Userid
    - latitude
    - longitude

* Users
  - userId
    - email
    - userId
    - name

* newEvent
  - random id
    - Eventdate
    - Eventdatetime
    - Eventtime
    - Latitudelocation
    - Longitudelocation
    - Recipecuisine
    - Recipename
    - Recipeprice
    - addImage
    - id
    
* declinedRequests
  - recipename and hostid and eventtime and eventdate and userid
    - Control
    - Cuisine
    - Eventdate
    - Eventtime
    - Hostid
    - Image
    - Price
    - Recipename
    - Userid
    - latitude
    - longitude
    
* booking
  - recipename and hostid and eventtime and eventdate and userid
    - Control
    - Deletecheck
    - Eventdate
    - Eventdatetime
    - Eventlatitude
    - Eventlongitude
    - Eventprice
    - Eventtime
    - Hostid
    - Image
    - Recipecuisine
    - Recipename
    - Userid

## Challenges

Het implementeren van de facebooklogin was lastiger dan gedacht. De documentatie die online beschikbaar was, was niet altijd even duidelijk en vaak ik er ook verouderde informatie te vinden. Uiteindelijk is het goed gelukt, maar heb ik wel besloten om de googlelogin te schrappen. Dit zou anders ook veel tijd kosten en is natuurlijk niet het belangrijkste van de app. Het weergeven van de googlemaps API ging daarentegen weer eenvoudiger. In eerste instatie heb ik een googlezoekbalk verwerkt in de app en deze kreeg ik ook snel werkend (goede online documentatie), echter heb ik later besloten om de homesearchcollectionviewcontroller te schrappen (waar de googlezoekbalk onderdeel van zou zijn). Dit zou in zijn geheel teveel tijd in beslag nemen om het allemaal goed aan elkaar te linken. Het formulier om een nieuw event toe te voegen heeft vrij veel tijd ingenomen. Deze tijd zat vooral in de kleine details. Zo wilde ik een datum en tijd picker gebruiken en dat bij 'recipe price' alleen getallen, komma's en punten konden worden ingevoerd. Dit was redelijk lastig en heb hier goed voor moeten zoeken op internet. Het toevoegen van de locatie met een marker (en het opslaan van deze coordinaten) ging wel redelijk vlot. Echter wilde ik ook een adres krijgen (het zou raar zijn als een gebruiker zelf de coordinaten moet opzoeken). Uiteindelijk vond ik hier een oplossing voor: reverseGeocodecooridnates. Het opslaan van de geselecteerde afbeelding uit de photo library in firebase storage was ook best lastig. In eerste instantie overschreed een nieuwe toegevoegde afbeelding de oude afbeelding in firebase storage. Het opzetten van de eventdetails en bookingconfirmation schermen ging redelijk vlot. Wel was het een uitdaging om de data goed op te slaan in firebase. Dit heb ik nog een aantal keer moeten aanpassen (extra parameters toevoegen). Bijvoorbeeld de eventdatetime parameter, waardoor alle tableviews kunnen worden geupdate aan de hand van de huidige datum en tijd. Als een event een tijd/datum combinatie heeft die al is geweest, dan wordt dit event verwijderd uit firebase. De grootste uitdaging was uiteindelijk om de android-like buttonbar te gebruiken. Van te voren had ik al in mijn design document bedacht dat ik een soort scrollbar wilde. Ik had er echter van te voren niet goed over nagedacht hoe ik dit kon aanpakken. Ik heb veel verschillende opties geprobeerd, maar kwam er achter dat het niet haalbaar is met de standaard swift opties in storyboard. Na wat zoeken op internet kwam ik uit bij: Android PagerTabStrip for iOS. Dit was precies wat ik zocht. Het implementeren hiervan bleek ook nog een hele klus. Gelukkig vond ik een goed filmpje op youtube met duidelijke uitleg en is het gelukt om het op de juiste manier te implementeren.

Qua technisch design heb ik wel het een en ander aangepast ten opzichte van het desing document. Vooral de firebase structuur heb ik veel uitgebreider gemaakt en ik heb meer viewcontrollers gebruikt. Ik heb alleen de homesearchcollectionviewcontroller geschrapt, maar daarentegen gezorgd dat de 'my bookings' en 'my events' tabs uitgebreider zijn geworden (met een guestlist en een exact event location). Ik denk dat dit een goede keuze is geweest, omdat dit belangrijkere informatie is voor de app gebruiker. Wanneer er meer tijd beschikbaar is, zou ik wel de homefeed aanpakken. Ik zou dan events sorteren op datum en ook op locatie.
