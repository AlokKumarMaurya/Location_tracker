import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:background_location/background_location.dart'
//     as nextlocationpackage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:workmanager/workmanager.dart';



const fetchBackground="fetchBackground";
Location location = Location();
CollectionReference LiveLocationOfUser =
FirebaseFirestore.instance.collection("1111111111111");
var data;


void callbackDispatcher()
{
  Workmanager().executeTask((task, inputData)async
  {
    switch (task)
    {
      case fetchBackground:
        aa();


    }
    return true;

  });
}

void aa() {
  if(location.onLocationChanged==true)
  {
    LiveLocationOfUser.doc("workmanger is working").set({
      "most_recent_location": GeoPoint(
          data.latitude!.toDouble(), data.longitude!.toDouble())
    });
  }
}



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  await Workmanager().registerPeriodicTask("1",fetchBackground,frequency: Duration(seconds: 10),constraints: Constraints(networkType: NetworkType.connected));

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LocationPage(),
    );
  }
}






class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  // late Timer timer;

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(Duration(seconds: 15), (Timer t) => trackingLocation());
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     super.dispose();
//   }

  // CollectionReference LiveLocationOfUser =
  // FirebaseFirestore.instance.collection("1111111111111");

  // ///variable for use of nextlocatiopackage
  // String nextlatitude = "......waiting";
  // String nextlongitude = ".....waiting";
  //
  // ///here ends the variable for the nextlocationpackages

  // var data;

  bool forFn = true;


  late Location current;
  var a;
  var b;
  var c = null;
  var d = null;
  var speed;

  // Location location = Location();
  late bool _isServiceEnabled;
  late PermissionStatus _permissionGrnated;
  late LocationData _locationData;
  bool _isListenLocation = false, _isGetLocation = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //otherfunction(),

            ElevatedButton(
                onPressed: () {
                  nextlocation();
                  setState(() {
                    if (forFn == true) {
                      forFn = false;
                    } else
                      forFn = true;
                  });
                },
                child: Text("New Button")),

            forFn ? waitfn() : otherfunction(),

            ElevatedButton(
                onPressed: () async {
                  _isServiceEnabled = await location.serviceEnabled();
                  if (!_isServiceEnabled) {
                    _isServiceEnabled = await location.requestService();
                    if (_isServiceEnabled) return;
                  }
//////////////////////////////////
                  _permissionGrnated = await location.hasPermission();

                  if (_permissionGrnated == PermissionStatus.denied) {
                    _permissionGrnated = await location.requestPermission();

                    if (_permissionGrnated != PermissionStatus.granted) return;
                  }

                  _locationData = await location.getLocation();
                  setState(() {
                    _isGetLocation = true;
                  });
                },
                child: Text("Get Location")),

            _isGetLocation
                ? Text(
                "Location : ${_locationData.latitude} / ${_locationData.longitude}")
                : Container(),

            ElevatedButton(
                onPressed: () async {
                  _isServiceEnabled = await location.serviceEnabled();
                  if (!_isServiceEnabled) {
                    _isServiceEnabled = await location.requestService();
                    if (_isServiceEnabled) return;
                  }
                  _permissionGrnated = await location.hasPermission();
                  if (_permissionGrnated == PermissionStatus.denied) {
                    _permissionGrnated = await location.requestPermission();
                    if (_permissionGrnated != PermissionStatus.granted) return;
                  }

                  setState(() {
                    _isListenLocation = true;
                    c = _locationData.latitude;
                    d = _locationData.longitude;
                  });
                },
                child: Text("Location Listner")),

            StreamBuilder(
                stream: location.onLocationChanged,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    data = snapshot.data as LocationData;

                    LiveLocationOfUser.doc("recentlocation").set({
                      "most_recent_location": GeoPoint(
                          data.latitude!.toDouble(), data.longitude!.toDouble())
                    });

                    return Column(
                      children: [
                        Text(
                            "Changed Location :  \n ${data.longitude} / ${data.latitude}"),

                        // Text("Value of a is $a"),
                        // Text("Value of b is $b"),
                        // Text("Value of c is $c"),
                        // Text("value of d is $d")
                      ],
                    );
                    setState(() {
                      if (a != null) {
                        setState(() {
                          c = a;
                          d = b;
                        });
                      }
                      a = data.latitude;
                      b = data.longitude;
                    });
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                })
          ],
        ),
      ),
    );
  }


  void aa()
  {
    // if(location.onLocationChanged==true)
    //   {
    //     LiveLocationOfUser.doc("workmanger is working").set({
    //       "most_recent_location": GeoPoint(
    //           data.latitude!.toDouble(), data.longitude!.toDouble())
    //     });
    //   }



  }


  trackingLocation() async {
    _isServiceEnabled = await location.serviceEnabled();
    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
      if (_isServiceEnabled) return;
    }

    _permissionGrnated = await location.hasPermission();
    if (_permissionGrnated == PermissionStatus.denied) {
      _permissionGrnated = await location.requestPermission();
      if (_permissionGrnated != PermissionStatus.granted) return;
    }

    _locationData = await location.getLocation();
    setState(() {
      _isGetLocation = true;
      _isListenLocation = true;
    });

        (onLocationChanged) {
      LiveLocationOfUser.doc("TRACKING_LOCATION").set(
          {"most_recent_location": GeoPoint(data.latitude, data.longitude)});

      LiveLocationOfUser.add(
          {"most_recent_location": GeoPoint(data.latitude, data.longitude)});


    };
  }

  otherfunction() {
    return StreamBuilder(
        stream: location.onLocationChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            data = snapshot.data as LocationData;
            // LiveLocationOfUser.doc("OTHERFUNCTION_LOCATION").set({
            //   "most_recent_location": GeoPoint(
            //       data.latitude!.toDouble(), data.longitude!.toDouble())
            // });

            return Center();
            //   Column(
            //   children: [
            //     Text("Changed Location :  \n ${data.longitude} / ${data.latitude}"),
            //
            //
            //   ],
            // );

          } else
            return Center();
        });
  }

  waitfn() {
    return Center();
  }

  nextlocation() async {
    // await nextlocationpackage.BackgroundLocation.setAndroidNotification(
    //     title: "Location is running in background",
    //     message: "Background location in running",
    //     icon: "@mipmap/ic_launcher");

    // await nextlocationpackage.BackgroundLocation.startLo
    //
    // cationService(
    //     distanceFilter: 20);
  }
}


//