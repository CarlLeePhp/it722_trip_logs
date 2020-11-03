import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';

class MapRoute extends StatefulWidget {
  String userId;
  MapRoute(String userId){
    this.userId = userId;
  }
  @override
  _MapRouteState createState() => _MapRouteState(this.userId);
}

class _MapRouteState extends State<MapRoute> {
  String _userId;
  Location _currentLocation;
  final CameraPosition position = CameraPosition(target: LatLng(-46.413115, 168.355103), zoom: 10);
  final AlertDialog dialog = AlertDialog(
    title: Text("Enter your description:"),
    actions: [
      FlatButton(onPressed: () => Navigator.of(context).pop(), child: Text('CANCEL')),
      FlatButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL'))
    ],
  );

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
    Location location = new Location(pos.latitude, pos.longitude);
    location.userId = _userId;
    setState(() {
      markers = markers;
      _currentLocation = location;
    });
  }

  _MapRouteState(String userId){
    this._userId = userId;
  }

  @override
  void initState() {
    _getCurrentLocation().then((pos) => addMarker(pos, 'curropos', 'You are here!'))
        .catchError((err) => print(err.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User ID: $_userId'),
        actions: [
          IconButton(icon: Icon(Icons.autorenew),onPressed: () => _getCurrentLocation().then((pos) => addMarker(pos, 'curropos', 'You are here!'))
              .catchError((err) => print(err.toString())),),
          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => Navigator.of(context).pushNamed("form_page", arguments: this._currentLocation))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: position,
        markers: Set<Marker>.of(markers),

      ),
    );
  }
}

