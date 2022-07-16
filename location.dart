import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String CurrentLocation = "My Address";
  Position? CurrentPosition;
  var currentAddress='';
  var speed=0.0;
  var altitude=0.0;
  var administrativeArea=0.0;
  var subadministrativeArea=0.0;
  var postatCode='';
  var subthoroughfare='';
  var throughfare='';
  Future<Position> determinePositon() async {
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Please enable location");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(msg: "Location permission denied");
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Permission is denied forever");
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    /////////////////////
    speed=await position.speed;
    altitude=await position.altitude;
    if(speed !=speed)
    {
      setState(()
      {
        speed=speed;
      }
      );
    }

    ////?????
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemark[0];
      setState(() {
        altitude=altitude;
        CurrentPosition = position;
        currentAddress="(${place.locality},${place.country},"
            "${place.street},${place.name},${place.administrativeArea},"
            "${place.subAdministrativeArea},${place.postalCode},${place
            .postalCode},${place.subThoroughfare},${place.thoroughfare})";

      }
      );
    }
    catch(e)
    {
      print(e);
    }
    return position;
  }
/////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location App"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Address",style: TextStyle(fontSize: 30,fontWeight:
            FontWeight.bold,),
            ),


            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(currentAddress,style: TextStyle(fontSize: 20),),
            ),


            //Text(CurrentLocation,style: TextStyle(color: Colors.red),),


            CurrentPosition!=null ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('LATITUDE =   ' + CurrentPosition!.latitude.toString
                ()),
            )
                : Container(),


            CurrentPosition!=null ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('LONGITUDE =   ' + CurrentPosition!.longitude.toString
                ()),
            )
                : Container(),


            // CurrentPosition!=null ?
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text('ADMINISTRATIVE AREA =   ' + CurrentPosition!
            //       .administrativeArea
            //       .toString
            //     ()),
            // )
            //     : Container(),
            //




            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("SPEED =   "+speed.toString()),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("ALTITUDE =   "+altitude.toString()),
            ),




            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(onPressed: determinePositon, child:
              Text("Get My Location")),
            )

          ],
        ),
      ),
    );
  }
}
