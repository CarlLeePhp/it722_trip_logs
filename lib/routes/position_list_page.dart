import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/location.dart';

class PositionListRoute extends StatefulWidget {
  @override
  _PositionListRouteState createState() => _PositionListRouteState();
}

class _PositionListRouteState extends State<PositionListRoute> {
  var _list = [];
  var _listAll = [];
  String _userId;
  String _tempUserId;

  void toSettings() {
    setState(() {
      _userId = null;
    });
    //await Navigator.pushNamed(context, "user_page");
  }
  void setUserId(){
    setState(() {
      _userId = _tempUserId;
    });
  }
  void createLocation() async {
    Location location;
    await Navigator.pushNamed(context, 'map_page', arguments: this._userId).then((value) => {
      location = value as Location
    });

    print(location.description);
    // var list = this._list;
    // list.add(location);
    // setState(() {
    //   _list = list;
    // });
  }
  Future getDataFromWeb() async {
    HttpClient httpClient = new HttpClient();
    //Uri uri = Uri(scheme: "http", host: "developer.kensnz.com/getlocdata");
    HttpClientRequest request = await httpClient.getUrl(Uri.parse("http://developer.kensnz.com/getlocdata"));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    print(responseBody);
    List items = json.decode(responseBody);
    List<Location> locations = new List<Location>();
    Location location;
    for(int i=0; i<items.length; i++){

      location = new Location(double.parse(items[i]["latitude"]) , double.parse(items[i]["longitude"]));
      location.description = items[i]["description"];
      location.userId = items[i]["userid"];
      locations.add(location);

    }
    httpClient.close();
    setState(() {
      _listAll = locations;
    });

    var tmpList = [];
    for(int i=0; i<this._listAll.length; i++){
      if(_listAll[i].userId == _userId){
        tmpList.add(_listAll[i]);
      }
    }
    setState(() {
      _list = tmpList;
    });

  }
  void filterData(){
    var tmpList = [];
    for(int i=0; i<this._listAll.length; i++){
      if(_listAll[i].userId == _userId){
        tmpList.add(_listAll[i]);
      }
    }
    setState(() {
      _list = tmpList;
    });
  }


  @override
  void initState() {
    getDataFromWeb();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(this._userId == null){
      return Scaffold(
        appBar: AppBar(title: Text('User ID: $_userId')),
        body: Column(
          children: [
            Spacer(flex: 2,),
            TextField(
              decoration: InputDecoration(
                  labelText: "User ID",
                  hintText: "Enter Your ID",
                  prefixIcon: Icon(Icons.person)
              ),
              onChanged: (value) async {
                setState(() {
                  _tempUserId = value;
                });
              },
            ),
            Spacer(flex: 1,),
            RaisedButton(
              onPressed: setUserId,
              child: Text('SAVE'),
            ),
            Spacer(flex: 8,)
          ],
        ),
      );
    } else {
      return FutureBuilder(
        future: getDataFromWeb(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Text("Error: ${snapshot.error}");
            } else {
              return Text("Good");
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      );
    }

  }
}