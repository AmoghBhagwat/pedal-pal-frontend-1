import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:frontend/wallet_home_page.dart';
import 'package:frontend/reg_login_forgot.dart';
import 'package:frontend/pages/history_page.dart';
import 'package:frontend/pages/booking_page.dart';
import 'package:frontend/main.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  DateTime? selectedDate = DateTime.now();
  TimeOfDay? selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  late String _PlaceOfMarker;
  bool _showInfoContainer = false;
  late LatLng _markerPosition;
  late int _CycleNum;

  @override
  void initState() {
    super.initState();
    _PlaceOfMarker = '';
  }

  void InfoForMarker(String markerId, LatLng markerPosition, int cycles) {
    setState(() {
      _PlaceOfMarker = markerId;
      _CycleNum = cycles;
      _markerPosition = markerPosition;
      _showInfoContainer = true;
    });
  }
  List<String> HUBS = [
    'RM',
    'Hall 6',
    'Library',
    'LH 20',
    'Hall 5'
  ];
  List<int> CycleNum = [1,2,3,4,5,6];

  Set<Marker> _generateMarkers(int n) {
    Set<Marker> markers = {};
    for (int i = 1; i <= n; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(HUBS[i-1]),
          position: LatLng(26.5113 + (i * 0.01), 80.2329 + (i * 0.01)), // Adjust coordinates as needed
          onTap: () {
            InfoForMarker(HUBS[i-1], LatLng(26.5113 + (i * 0.01), 80.2329 + (i * 0.01)), CycleNum[i-1]);
          },
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, Raghav!',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              margin: EdgeInsets.only(top: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 600,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(26.5113, 80.2329),
                        zoom: 13,
                      ),
                      markers: _generateMarkers(5), // If there are 5 hubs
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showInfoContainer)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showInfoContainer = false;
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), // Adjust corner radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(1),
                              // spreadRadius: 5.0, // Adjust shadow spread
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 30, // Height adjusted to be a tenth of the container's height
                                    child: Center(child: Text('SELECTED HUB')),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 30, // Height adjusted to be a tenth of the container's height
                                    child: Center(child: Text('CYCLES AVAILABLE')),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: Center(child: Text(_PlaceOfMarker)),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: Center(child: Text('$_CycleNum')),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    child: Center(child: Text('Advanced Booking', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () => _selectDate(context),
                                          child: Text('Select Date'),
                                        ),
                                        Text(
                                          '${selectedDate?.year}-${selectedDate?.month}-${selectedDate?.day}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () => _selectTime(context),
                                          child: Text('Select Time'),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          '${selectedTime?.hour}:${selectedTime?.minute}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Functionality to execute when the button is pressed
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Change the background color as per your requirement
                                    ),
                                    child: Text(
                                      'Ride Now',
                                      style: TextStyle(
                                        color: Colors.white, // Change the text color as per your requirement
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Functionality to execute when the button is pressed
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue, // Change the background color as per your requirement
                                    ),
                                    child: Text(
                                      'Book Now',
                                      style: TextStyle(
                                        color: Colors.white, // Change the text color as per your requirement
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),

      // Navigation bar
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/your_image.png'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Raghav',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'View Profile',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Wallet'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletHomePage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => (HistoryPage())),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('My Bookings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => (BookingPage())),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Log Out'),
                    onTap: () {
                      // Log out action
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

