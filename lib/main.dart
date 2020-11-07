import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './routes/form_page.dart';
import './routes/position_list_page.dart';
import './routes/map_page.dart';
import './routes/alert_page.dart';
import 'package:trip_logs/user_page.dart';

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
        "alert_page": (context) => AlertRoute(),
        "/": (context) => PositionListRoute(),
        "map_page": (context) => MapRoute(ModalRoute.of(context).settings.arguments),
        "form_page": (context) => FormRoute(ModalRoute.of(context).settings.arguments),
        "user_page": (context) => UserRoute()
      },
    );
  }
}
