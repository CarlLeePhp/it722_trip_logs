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

  void setUserId() {
    setState(() {
      _userId = _tempUserId;
    });
  }

  void createLocation() async {
    Location location;
    await Navigator.pushNamed(context, 'map_page', arguments: this._userId)
        .then((value) => {location = value as Location});

    print(location.description);
    // var list = this._list;
    // list.add(location);
    // setState(() {
    //   _list = list;
    // });
  }

  void filterData() {
    var tmpList = [];
    for (int i = 0; i < this._listAll.length; i++) {
      if (_listAll[i].userId == _userId) {
        tmpList.add(_listAll[i]);
      }
    }
    setState(() {
      _list = tmpList;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this._userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('User ID: $_userId')),
        body: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            TextField(
              decoration: InputDecoration(
                  labelText: "User ID",
                  hintText: "Enter Your ID",
                  prefixIcon: Icon(Icons.person)),
              onChanged: (value) async {
                setState(() {
                  _tempUserId = value;
                });
              },
            ),
            Spacer(
              flex: 1,
            ),
            RaisedButton(
              onPressed: setUserId,
              child: Text('SAVE'),
            ),
            Spacer(
              flex: 8,
            )
          ],
        ),
      );
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('User ID: $_userId'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: toSettings,
              ),
              IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: createLocation)
            ],
          ),
          body: SetData(this._listAll, this._list, this._userId));
    }
  }
}

class SetData extends StatefulWidget {
  var _listAll;
  var _list;
  var _userId;

  SetData(var listAll, var list, var userId) {
    this._listAll = listAll;
    this._list = list;
    this._userId = userId;
  }

  @override
  RequestData createState() => RequestData();
}

class RequestData extends State<SetData> {
  Future getDataFromWeb() async {
    HttpClient httpClient = new HttpClient();
    //Uri uri = Uri(scheme: "http", host: "developer.kensnz.com/getlocdata");
    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("http://developer.kensnz.com/getlocdata"));
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    List items = json.decode(responseBody);
    List<Location> locations = new List<Location>();
    Location location;
    for (int i = 0; i < items.length; i++) {
      location = new Location(double.parse(items[i]["latitude"]),
          double.parse(items[i]["longitude"]));
      location.description = items[i]["description"];
      location.userId = items[i]["userid"];
      locations.add(location);
    }
    httpClient.close();
    for (int i = 0; i < locations.length; i++) {
      if (locations[i].userId == widget._userId) {
        widget._list.add(locations[i]);
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: getDataFromWeb(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.connectionState == ConnectionState.done) {}
        return ListView.builder(
            itemCount: widget._list.length,
            itemExtent: 50,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget._list[index].description),
                subtitle: Text("Latitude: " +
                    widget._list[index].latitude.toString() +
                    " Longitude: " +
                    widget._list[index].longitude.toString()),
              );
            });
      },
    );
  }
}
