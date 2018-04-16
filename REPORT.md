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

<img src=https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/https://github.com/ChantalStangenberger/Programmeerproject/blob/master/doc/Final%20classes%20.png width="1000">

## Challenges
