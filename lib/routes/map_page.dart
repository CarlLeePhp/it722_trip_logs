import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';

class MapRoute extends StatefulWidget {
  Location _location;
  String userId;
  MapRoute(Location location){
    this._location = location;
  }
  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {

  Location _currentLocation;
  final CameraPosition position = CameraPosition(target: LatLng(-46.413115, 168.355103), zoom: 10);

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
    widget._location.longitude = pos.longitude;
    widget._location.latitude = pos.latitude;
    setState(() {
      markers = markers;
    });
  }

  @override
  void initState() {
    _getCurrentLocation().then((pos) => addMarker(pos, 'currpos', 'You are here!'))
        .catchError((err) => print(err.toString()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User ID: ${widget._location.userId}'),
        actions: [
          IconButton(icon: Icon(Icons.autorenew),onPressed: () => _getCurrentLocation().then((pos) => addMarker(pos, 'curropos', 'You are here!'))
              .catchError((err) => print(err.toString())),),
          IconButton(icon: Icon(Icons.add_circle_outline), onPressed: () => Navigator.of(context).pushNamed("form_page", arguments: widget._location))
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: position,
        markers: Set<Marker>.of(markers),

      ),
    );
  }
}

