Redmine Contact Management plugin
=================================

Overview
--------
This plugin add functionality to manage contracts
 - In main meny shows link to contract management project
 - In main menu hides link to "Help" section


Installation Steps
-------------------
 - Clone this repo to redmine /plugins folder for the user that runs redmine
 - Restart Redmine


Redmine settings
----------------
 - Go to "Administration -> Plugins" and setup plugin global settings. Make sure the contract management project exists. Changes in main menu require restarting redmine.
 - For project that choosen in previous step, create a new trackers - "Umowa" and "Zlecenie"
 - For that project create also custom fields for handle "Umowa" and "Zlecenie".
 - To enable the API-style authentication, you have to check Enable REST API in Administration -> Settings -> Authentication
 - You can find your API key on your account page ( /my/account ) when logged in, on the right-hand pane of the default layout

  
Test API in development environment
-----------------------------------

```
 curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"Nazwa Partnera":"Marketing sQuad Andrew Rogat","Adres Partnera":"Johnson Street 2423, London, UK","NIP Partnera":"UK41234123","Podaj nazw\u0119 Drugiego Partnera":"Espeo Software","Podaj adres drugiego Partnera":"Wroniecka 18\/5 Pozna\u0144 Poland","Podaj NIP drugiego Partnera":"7811821065","Typ umowy":"Ramowa","Pocz\u0105tek umowy":1446418800000,"Koniec umowy":null,"Typ rozliczenia":"Time Material","Fakturowanie":"w okre\u015blonych datach","Status umowy":"szkic","Data krytyczna na przygotowanie umowy":1445814000000,"Link do dokumentu":"https:\/\/docs.google.com\/document\/d\/1Kw1C0J3qVC8BeRoS4uh1KBGuKxwjxDaDv-heop1AOtQ\/edit","Osoba akceptuj\u0105ca - Partner Prawnik":"Sylwia Rogowicz","Osoba akceptuj\u0105ca - Partner Zarz\u0105d":null,"Osoba akceptuj\u0105ca - Partner Drugi Zarz\u0105d":"Andrew Rogat","Osoba Akceptuj\u0105ca prawnik PArtner Drugi":"Andrew Rogat","Akceptacja prawna Partner Prawnik":"Akceptuj\u0119 tre\u015b\u0107","Uwagi od Prawnika Partnera":"brak","Negocjacje Zawieszone":"Negocjacje trwaj\u0105","Uwagi Partner Zarz\u0105d":null,"Partner akceptuje umow\u0119":true,"Partner Drugi akceptacja":true,"Numer Umowy":"B2B67"}' http://localhost:3000/cm/new_issue?key=89949c8bb09152b17468a13be686537cf72d407d
 # the key it is your key for rest api
 ```

