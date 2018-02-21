# Programmeerproject: Dine by me!

Student: Chantal Stangenberger

Programmeerproject - start 29-01-2018

[![BCH compliance](https://bettercodehub.com/edge/badge/ChantalStangenberger/Programmeerproject?branch=master)](https://bettercodehub.com/)

## Problem statement
We kennen allemaal wel het probleem dat we na een lange dag werken geen zin hebben om te koken of het probleem dat we geen zin hebben om in ons eentje te moeten eten. Voor deze twee doelgroepen biedt Dine by me de uitkomst! Met behulp van de app kunnen mensen aangeven wat zij van plan zijn om die avond te gaan koken (met de bijbehorende kosten en specificaties). Hierop kunnen andere mensen (bijvoorbeeld mensen die lange werkdagen maken) reageren en bij de aanbieder op bezoek gaan. 

## Solution
Met behulp van Dine by me kunnen gebruikers zoeken naar de dichtsbijzijnde maaltijd aanbieders. Ze kunnen zien wat de aanbieder op het menu heeft staan (met specificaties) en wat de ranking van de aanbieder is op het gebied van gerecht kwaliteit en gastvrijheid. Wanneer de gebruiker bij een bepaalde aanbieder wilt gaan eten, kan de gebruiker dit aangeven in de app. De aanbieder krijgt hierop een melding: hij kan het verzoek accepteren of weigeren op basis van het profiel van de gebruiker. 

### Main features
* Registratie en login schermen
* Scherm met nearby eetopties en zoekfunctie voor specifieke plaatsen
* Detailscherm waarbij gebruiker ook de precieze eetlocatie kan zien en een verzoek kan sturen naar de aanbieder
* Mogelijkheid om een eetoptie te publiseren 
* Persoonlijke afspraken pagina: met verzoeken in behandeling en definitieve afspraken
* Persoonlijke pagina voor de aanbieders: met eetverzoeken en definitieve afspraken

### Minimum viable product
* Bovengenoemde main features
* Eventueel login met facebook of met een google account.
* Eventueel de tijd weergeven wanneer je gasten bij je zijn.

### Visual sketch

<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/visual%20sketch.png width="800">

## Prerequisites

### - Data sources
* Google Maps: https://developers.google.com/maps/
* Google Places: https://developers.google.com/places/

### - External components
* Firebase

### - Similar mobile apps
* Eat with: Wereldwijde app waarbij gebruikers naar foodparty's kunnen gaan georganiseerd door een aanbieder. Het is vooral bedoeld om een leuk avondje uit te gaan en nieuwe mensen te leren kennen onder het mom van een etentje.
* Bubba: De app is verouderd en werkt niet echt goed meer. Het idee is dat je bij andere mensen kan eten of eten kunt afhalen. Je kunt ook in een map specifieke ingrediënten selecteren, en de app weergeeft dan op de kaart gebruikers die hieraan voldoen.

### - Hardest parts of implementing the application
* Het duidelijk weergeven van de locatie van een aanbieder met behulp van de API.
