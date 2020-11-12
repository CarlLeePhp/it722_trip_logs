import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';
import 'dart:async';
import 'dart:io';

class MapRoute extends StatefulWidget {
  MapRoute({Key key}) : super(key: key);
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  TextEditingController _controller = TextEditingController();

  Location _currentLocation = Location(0, 0);
  final CameraPosition position = CameraPosition(target: LatLng(-46.413115, 168.355103), zoom: 14);

  List<Marker> markers = [];

  Future _getCurrentLocation() async{
    bool isGeolocationAvailable = await isLocationServiceEnabled();
    Position _position = Position(latitude: this.position.target.latitude, longitude: this.position.target.longitude);
    if(isGeolocationAvailable){
      try {
        _position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      }
      catch (error) {
        return _position;
      }
      return _position;
    }
  }

  void addMarker(Position pos, String markerId, String markerTitle){
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(title: markerTitle),
    );
    markers.add(marker);
    setState(() {
      markers = markers;
      _currentLocation.latitude = pos.latitude;
      _currentLocation.longitude = pos.longitude;
    });
  }

  void _onItemTapped(int index) async {
    setState(() {
      _controller.text = '';
    });
    switch (index){
      case 0: {
      }
      break;
      case 1: {
        await _showSettingDialog();
      }
      break;
      case 2: {
        if(_currentLocation.userId == 'Unknown'){
          await _showAlertDialog();
        } else {
          await _showDesriptionDialog();
        }
      }
      break;
      default:
        break;
    }

  }

  Future<void> _showSettingDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Setting'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('User ID:'),
                TextFormField(
                  controller: _controller,
                )
              ],
            ),
          ),
          actions: [
            RaisedButton(
              color: Colors.grey,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(_currentLocation.userId);
              }
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
            ),
          ],
        );
      }
    ).then((val) {
      try {
        int.parse(val);
        setState(() {
          _currentLocation.userId = val;
        });
      } catch(e){
        setState(() {
          _currentLocation.userId = 'Unknown';
        });
      }
    });
  }

  Future<void> _showDesriptionDialog() async {
    return showDialog<String>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Current Location'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Latitude: ' + _currentLocation.latitude.toString()),
                  Text('Longitude: ' + _currentLocation.longitude.toString()),
                  Text('Description:'),
                  TextFormField(
                    controller: _controller,
                  )
                ],
              ),
            ),
            actions: [
              RaisedButton(
                color: Colors.grey,
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context).pop('');
                }
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text('Submit'),
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            ],
          );
        }
    ).then((val) async {
      if(val != ''){
        // post the data
        setState(() {
          _currentLocation.description = val;
        });
        await submitToWeb();
      }
    });
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Message'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Please set your user id from setting page.')
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  Future submitToWeb() async {
    String uriString = 'http://developer.kensnz.com/api/addlocdata?userid=' + this._currentLocation.userId
        + '&latitude=' + this._currentLocation.latitude.toString()
        + '&longitude=' + this._currentLocation.longitude.toString()
        + '&description=' + this._currentLocation.description;
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(uriString));
    await request.close();
  }
  @override
  void initState() {
    super.initState();
    _currentLocation.userId = 'Unknown';
    Timer.periodic(Duration(seconds: 3), (timer) {
      _getCurrentLocation().then((pos) => addMarker(pos, 'currpos', 'You are here!'))
          .catchError((err) => print(err.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Current User: ' + _currentLocation.userId),
      ),
      body: GoogleMap(
        initialCameraPosition: position,
        markers: Set<Marker>.of(markers),

      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_location),
              label: 'New'
          ),
        ],
      ),
    );
  }
}


