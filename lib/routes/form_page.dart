import 'package:flutter/material.dart';
import '../models/location.dart';
import 'dart:io';
import 'dart:convert';

class FormRoute extends StatefulWidget {
  Location _currentLocation;
  FormRoute(Location currentLocation){
    this._currentLocation = currentLocation;
  }
  @override
  _FormRouteState createState() => _FormRouteState(this._currentLocation);
}

class _FormRouteState extends State<FormRoute> {
  Location _currentLocation;

  _FormRouteState(Location currentLocation){
    this._currentLocation = currentLocation;
  }
  @override
  void initState() {
    super.initState();
  }
  void submitResult(){
    submitToWeb();
    Navigator.popUntil(context, ModalRoute.withName("/"));
  }
  Future submitToWeb() async {
    String uriString = 'http://developer.kensnz.com/api/addlocdata?userid=' + this._currentLocation.userId
      + '&latitude=' + this._currentLocation.latitude.toString()
      + '&longitude=' + this._currentLocation.longitude.toString()
      + '&description=' + this._currentLocation.description;
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(uriString));
    HttpClientResponse response = await request.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User ID: ${_currentLocation.userId}'),),
      body: Column(
        children: [
          Spacer(flex: 2,),
          Text("Lat: ${_currentLocation.latitude}, Long: ${_currentLocation.longitude}"),
          Spacer(flex: 1,),
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
          Spacer(flex: 1,),
          RaisedButton(
            onPressed: submitResult,
            child: Text('Submit'),
          ),
          Spacer(flex: 8,)
        ],
      )
      );
  }
}
