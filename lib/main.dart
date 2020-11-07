import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import './routes/form_page.dart';
import './routes/position_list_page.dart';
import './routes/map_page.dart';
import 'package:trip_logs/user_page.dart';
import './routes/alert_page.dart';
import 'package:trip_logs/Global.dart';

// Sets a platform override for desktop to avoid exceptions. See
// https://flutter.dev/desktop#target-platform-override for more info.
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  // Global.init().then((e) => runApp(MyApp()));
  _enablePlatformOverrideForDesktop();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => AlertRoute(),
        "position_page": (context) => PositionListRoute(),
        "map_page": (context) => MapRoute(ModalRoute.of(context).settings.arguments),
        "form_page": (context) => FormRoute(ModalRoute.of(context).settings.arguments),
        "user_page": (context) => UserRoute()
      },
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainMap extends StatefulWidget {
  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
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
    });
  }

  @override
  void initState(){
    _getCurrentLocation().then((pos) => addMarker(pos, 'curropos', 'You are here!'))
        .catchError((err) => print(err.toString()));
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Trip Logs'),),
      body: Container(child: GoogleMap(
        initialCameraPosition: position,
        markers: Set<Marker>.of(markers),
      ),),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CameraPosition position = CameraPosition(target: LatLng(-46, 170), zoom: 10);
  int _counter = 0;
  String _message = '';
  Position _position = Position(latitude: -46, longitude: 168);


  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  void _updateMessage(){
    String newMessage = 'Clicked Me';
    setState(() {
      _message = newMessage;
    });
  }

  void _getCurrentPosition() async {
    // Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Position position = await getLastKnownPosition();
    setState(() {
      _position = position;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Latitude: $_position'
            ),
            Text(
              '$_message'
            ),
            RaisedButton(onPressed: _getCurrentPosition,
              child: Text('Press Me'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
