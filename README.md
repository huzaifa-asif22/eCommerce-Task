This is an assignment task to build a product listing page via fakeApis and also integrate the authentication process (login and sign up).

To run this app:
First of all, run this command in terminal 'flutter pub get'.

For android this command 'flutter run' and select the android emulator.

For iOS, run this command in terminal 'cd ios' -> 'pod install' -> 'cd..' -> then 'flutter run' and select the appropriate simulator.

Breakdown:
I have used CLEAN architecture for this application because I have followed the modular approach, where we divide the code into three separate layers (presentation, domain, data layer).
This approach gives us the flexibility and freedom to work on any module, fake the data, and also test a feature, either the UI or the data source, without affecting any other module.
Also we can fake the data or even update/change the data whenever we want.
