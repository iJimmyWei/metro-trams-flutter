import 'package:flutter/material.dart';
import 'package:metro_trams/constants.dart';
import 'package:metro_trams/screens/home.dart';
import 'package:metro_trams/screens/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metro Trams',
      theme: ThemeData(
        primaryColor: Color(kPrimaryColour),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(title: 'Metro Trams'),
        '/search': (context) => SearchScreen(title: 'Search')
      },
    );
  }
}
