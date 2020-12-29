import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:metro_trams/constants.dart';
import 'package:metro_trams/screens/home.dart';
import 'package:metro_trams/screens/search.dart';

Future main() async {
  await DotEnv().load('.env');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manchester Metro Trams',
      theme: ThemeData(
        primaryColor: Color(kPrimaryColour),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(title: 'Manchester Trams'),
        '/search': (context) => SearchScreen(title: 'Search'),
      },
    );
  }
}
