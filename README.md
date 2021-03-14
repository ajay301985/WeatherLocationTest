### Weather Location Test

### A: Assigment:
## A:1 - Add weather location

1: Click on "+ Add" button (top right corner) on the home screen to Add new locations. <br />
2: Fill the details for location name, temprature (Only Celcius) supported. and choose the status on clicking "Weather status" button. <br />
3: On choosing weather status it will also change the backgroud color of status label based on the choosen status. <br />
4: On clicking Save button it will save the location and if failed the it will show the error mesasge. <br />
5: To Cancel user need to swap down the screen. <br />

## A:2 Delete weather location
1: On swipe left weather location table cell, user get option to delete the location. On clicking it will delete the selected location and if fail then It will show error message to the user.<br />


## B: Improvements
1: As server is unstable so added a "Refresh" button on Top left corner of Home screen to fetch the location data from server, (in case if fail to load first time, so user don't need quit the app to load location) <br />
2: Show a default progress bar for all the network request, so user knows that something is processing. <br />

### C: Technical specification:

WeatherLocationService: This class manage all the network communication with backend server. <br />
WeatherViewModel: This class is acting like a viewmodel for WeatherViewController and AddWeatherViewController classes and responsible to process all the data which is requied by views. <br />
AddWeatherViewController: This class is responsible for adding new weather location and also managing all its controls. This class is interacting with WeatherViewModel for add operation <br />
ViewControllerExtension: This class having extension for UIViewController and UITextField. <br />
WeatherLocationTests: This is a Unit Test class and test cases is validating WeatherLocation status <br />

## D: Others
1: Code refactor and improvement is considered <br />
2: Added Unit test cases. <br />
3: No custom animation added because lack of time. <br />
4: App is tested on iPhone simulator iOS version 14.0 or greater <br />
5: I found the API-Keys are saved in UserDefaults, which does not seems a good practice to save secure keys, I would prefer to save that in Keychain. (sorry could not get time to fix that)




