import 'package:flutter/material.dart';
import 'package:trip_logs/Global.dart';

class UserRoute extends StatefulWidget {
  @override
  _UserRouteState createState() => _UserRouteState();
}

class _UserRouteState extends State<UserRoute> {
  String _userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trip Logs'),),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                    _userId = value;
                  });
                },
            ),
            Spacer(flex: 1,),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, "position_page", arguments: this._userId),
              child: Text('SAVE'),
            ),
            Spacer(flex: 8,)
          ],
        )
    );
  }
}
