import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'location.dart';

class FormRoute extends StatefulWidget {
  String userId;
  FormRoute(String userId){
    this.userId = userId;
  }
  @override
  _FormRouteState createState() => _FormRouteState(this.userId);
}

class _FormRouteState extends State<FormRoute> {
  String _userId;
  String _description;
  Location _currentLocation;
  final CameraPosition position = CameraPosition(target: LatLng(-46, 170), zoom: 10);
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
      _currentLocation = new Location(pos.latitude, pos.longitude);
    });
  }

  _FormRouteState(String userId){
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
      appBar: AppBar(title: Text('User ID: $_userId'),),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: GoogleMap(
              initialCameraPosition: position,
              markers: Set<Marker>.of(markers),

            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Something about this place...",
                  ),
                  onChanged: (value) async {
                    Location location = this._currentLocation;
                    location.description = value;
                    setState(() {
                      _currentLocation = location;
                    });
                  },
                ),
                RaisedButton(
                  onPressed: () => Navigator.pop(context, this._currentLocation),
                  child: Text('Submit'),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
