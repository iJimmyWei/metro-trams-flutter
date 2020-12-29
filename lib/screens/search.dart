import 'package:flutter/material.dart';
import 'package:metro_trams/components/search_field_input.dart';
import 'package:metro_trams/constants.dart';
import 'package:metro_trams/services/network.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key, this.title, this.stationLocation}) : super(key: key);

  final String title;
  final String stationLocation;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  NetworkHelper networkHelper = NetworkHelper();
  List stationNames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(kBackgroundColour),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SearchFieldInput(
              icon: Icon(Icons.search, color: Colors.pink),
              inputField: TextField(
                  autofocus: true,
                  onChanged: (value) async {
                    List stationName =
                        await networkHelper.lookupStationNames(value);
                    setState(() {
                      stationNames = stationName;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: widget.stationLocation,
                    hintStyle: TextStyle(color: Colors.white),
                  )),
            ),
            stationNames == null
                ? Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 40.0),
                          child: Icon(Icons.youtube_searched_for,
                              color: Colors.pinkAccent, size: 100)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.0),
                        child: Text(
                            'Enter a few words to search a station on Metro Trams',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0)),
                      ),
                    ],
                  )
                : Expanded(
                    child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: stationNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 32.0),
                          onTap: () =>
                              Navigator.pop(context, stationNames[index]),
                          trailing: Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                          ),
                          title: Text('${stationNames[index]}',
                              style: TextStyle(color: Colors.white)));
                    },
                  )),
          ],
        ),
      ),
    );
  }
}
