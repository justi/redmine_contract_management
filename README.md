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
 curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d ' {"user":{"first_name":"firstname","last_name":"lastname,"email":"email@email.com","password":"app123","password_confirmation":"app123"}, "key":"89949c8bb09152b17468a13be686537cf72d407d"}' http://localhost:3000/cm/new_issue
 # key it is your key for rest api
 ```

