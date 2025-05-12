# hytteportalen-app

## spkhytta-iOS
spkhytta-iOS is an app managaing company cabin bookings. The application provides a user-friendly interface for reserving a cabin, viewing booking details, and receving digital recepits. The application also integrates with the Nager.Date API for holiday awareness, and Firebase is used for authentication and data managment. 


1. Requiments:
- Xcode Version 16.2
- Simul
- Swift 5.9+
- Internet Connection (API calls)
- GoogleService-info.plist (to activate firebase services)


2. Set-up Intructions:
- Clone repository
- Open project i Xcode


3. Add info.plist:
- open project in finder
- find your info.list 
- drag an insert into the main project
- select your device or simulator in Xcode 
- press Cmd + R to build and run project.

NOTE: 
Troubleshooting -->
- Holiday data not loading? 
Make sure the API endpoint and ensure you have a valid internet connection.

- Missing Configuration? 
Ensure the GoogleService-Info.plist is correctly confirgured and included in the project.

- UI issuse? 
Try cleaning the build folder(Shift + Cmd +K) and rebuilding the app.


4. Dependencies
- Firebase for authetication and backend services
- Nager.Date API for holiday data.

