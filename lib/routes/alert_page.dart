import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';
import 'dart:io';
import 'dart:convert';

class AlertRoute extends StatefulWidget {

  @override
  _AlertRouteState createState() => _AlertRouteState();
}

class _AlertRouteState extends State<AlertRoute> {
  String _internetResult;

  @override
  void initState() {
    CheckInternet();

    super.initState();
  }

  Future<void> CheckInternet() async {
    try{
      final result = await InternetAddress.lookup("google.com");
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        setState(() {
          _internetResult = "Connected";
        });
      }
    } on SocketException catch (e){
      setState(() {
        _internetResult = "Not Connected";
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Alert Page'),),
      body: Column(
        children: [
          Text("Internet Status: " + _internetResult)
        ],
      )
      );
  }
}
