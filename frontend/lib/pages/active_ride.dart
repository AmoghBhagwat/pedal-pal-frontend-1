import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/profile.dart';
import 'package:frontend/pages/qr_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: load start_time from shared preferences and display current time etc.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Service UI',
      theme: ThemeData(
        // Set background color as desired
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: RideScreen(),
    );
  }
}

class RideScreen extends StatefulWidget {
  @override
  _RideScreenState createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  var user = User("loading", "loading", "loading", "loading", false);
  var startTime = DateTime.now();
  var startHub = "Loading";

  @override
  void initState() {
    super.initState();
    // Retrieve the user information from shared_preferences
    _getUserInfo();
  }

  void _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('user');
    var startTimeData = prefs.getString('ride_start_time');
    var startHubData = prefs.getString('ride_start_hub');
    print(userData);
    print(startTimeData);
    print(startHubData);
    if (userData != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
    if (startTimeData != null) {
      setState(() {
        startTime = DateTime.parse(startTimeData);
      });
    }
    if (startHubData != null) {
      setState(() {
        startHub = startHubData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Service'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // User Profile
            Column(
              children: [
                CircleAvatar(
                  radius: 50,

                  // backgroundImage: AssetImage(
                  //     'assets/profile_picture.jpg'), // Put your image path here
                ),
                SizedBox(height: 10),
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Ride Status Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Functionality for Ride Status goes here
                },
                child: Text(
                  'Ride Status',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 248, 246, 246)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40), // Increased vertical space
            // Start Hub
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Start Hub',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  startHub,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 40), // Increased vertical space
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Ride Start Time',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  startTime.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 40), // Increased vertical space
            // Payment Mode
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Payment Mode',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  // onTap: _toggleSubscription,
                  child: Text(
                    user.isSubscribed ? 'Wallet' : 'UPI',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            // Ride Status Button
            SizedBox(height: 20),
            // End Ride Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QRViewExample(mode: 'end'),
                    ),
                  );
                },
                child: Text(
                  'End Ride',
                  style: TextStyle(
                      color: const Color.fromARGB(255, 248, 246, 246)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
