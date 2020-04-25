import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_trams/components/textFieldButton.dart';
import 'package:metro_trams/constants.dart';
import 'package:badges/badges.dart';

import '../services/network.dart';
import '../services/responseDto.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class TramCard extends StatelessWidget {
    TramCard({this.dest, this.line, this.waitTime, this.carriages, this.status});

    final String dest;
    final String line;
    final String waitTime;
    final String carriages;
    final String status;

    Widget build(BuildContext context) {
        return Card(
            child: (
                ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    trailing: 
                        RichText(
                            text: TextSpan(
                                children: status == "Arriving" || status == "Departing"
                                    ? <TextSpan>[
                                            TextSpan(
                                                text: status,
                                                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                                            )
                                    ]
                                    : <TextSpan>[
                                        TextSpan(text: "$waitTime ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                                        TextSpan(
                                            text: int.parse(waitTime) > 1
                                                    ? "mins"
                                                    : "min",
                                            style: TextStyle(color: Colors.black),
                                        )
                                    ]
                            )
                        ),
                    title: Text('$dest',
                            style: TextStyle(color: Colors.black)
                        ),
                    subtitle: Text("$carriages Carriage"),
                )
          ),
        );
    }
}

class _HomeScreenState extends State<HomeScreen> {
    NetworkHelper networkHelper = NetworkHelper();
    String stationLocation = "Manchester Airport";
    List<Station> stationPlatforms;
    Timer timer;
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    @override
    void initState() {
        super.initState();

        getLatestStationData();

        timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getLatestStationData());
    }

    void getLatestStationData() async {
        var data = await networkHelper.getStationData(this.stationLocation);

        this.setState(() => stationPlatforms = data);
    }

    void getStationName() async {
        var name = await Navigator.pushNamed(context, '/search');

        if (name != null) {
            this.setState(() => stationLocation = name);

            // Force update
            getLatestStationData();
        }
    }

    void showInSnackBar(String value) {
        _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value), duration: Duration(seconds: 10),));
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Color(kBackgroundColour),
            appBar: AppBar(
                title: Text(widget.title),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: stationPlatforms[0].messageBoard.length > 0 ? 4.0 : 0.0),
                    child: Badge(
                      showBadge: stationPlatforms[0].messageBoard.length > 0,
                      badgeContent: Text(stationPlatforms[0].messageBoard.length > 0 ? "1" : "0"),
                      badgeColor: Colors.orangeAccent,
                      position: BadgePosition.topRight(right: 0, top: 0),
                      child: IconButton(
                        icon: Icon(Icons.warning),
                        onPressed: () => showInSnackBar(
                          stationPlatforms[0].messageBoard.length > 0
                            ? stationPlatforms[0].messageBoard
                            : "No new travel updates"
                        ))
                    ),
                  )
                ],
            ),
            key: _scaffoldKey,
            body: Center(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                children: <Widget>[
                    TextFieldButton(
                        text: stationLocation,
                        icon: Icon(Icons.search, color: Colors.pink),
                        onPress: getStationName,
                    ),
                    Expanded(
                        child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: stationPlatforms != null ? stationPlatforms.length : 0,
                        itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                Flex(
                                    direction: Axis.horizontal,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                            child: Text("Platform ${index + 1}", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                                        )],
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 32.0),
                                      child: Column(
                                        children:
                                        <Widget>[
                                          for (var t in stationPlatforms[index].trams.where((t) => t.dest != ""))
                                            TramCard(
                                              dest: t.dest,
                                              line: stationPlatforms[index].line,
                                              waitTime: t.waitTime,
                                              carriages: t.carriages,
                                              status: t.status
                                            )
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                        },
                    )),
                ],
                ),
            ),
        );
    }
}
