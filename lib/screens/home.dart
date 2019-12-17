import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metro_trams/components/textFieldButton.dart';
import 'package:metro_trams/constants.dart';

import '../services/network.dart';

class HomeScreen extends StatefulWidget {
    HomeScreen({Key key, this.title}) : super(key: key);

    final String title;

    @override
    _HomeScreenState createState() => _HomeScreenState();
}

class Tram {
    Tram({this.dest, this.line, this.waitTime, this.carriages, this.status});

    final String dest;
    final String line;
    final String waitTime;
    final String carriages;
    final String status;

    Card render() {
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
                    subtitle: Text("${carriages} Carriage"),
                )
          ),
        );
    }
}

class _HomeScreenState extends State<HomeScreen> {
    NetworkHelper networkHelper = NetworkHelper();
    String stationLocation = "Manchester Airport";
    List trams;
    Timer timer;

    @override
    void initState() {
        super.initState();
        timer = Timer.periodic(Duration(seconds: 10), (Timer t) => getLatestStationData());
    }

    void getLatestStationData() async {
        List data = await networkHelper.getStationData(this.stationLocation);
        
        this.setState(() => trams = data);
    }

    void getStationName() async {
        var name = await Navigator.pushNamed(context, '/search');

        if (name != null) {
            this.setState(() => stationLocation = name);

            print(name);

            // Force update
            getLatestStationData();
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Color(kBackgroundColour),
            appBar: AppBar(
                title: Text(widget.title),
            ),
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
                        itemCount: trams.map((t) => t['Dest0'] != "").length,
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
                                        children: <Widget>[
                                          trams[index]['Dest0'] != "" ? Tram(
                                              dest: trams[index]['Dest0'],
                                              line: trams[index]['Line'],
                                              waitTime: trams[index]['Wait0'],
                                              carriages: trams[index]['Carriages0'],
                                              status: trams[index]['Status0']
                                          ).render() : SizedBox.shrink(),
                                          trams[index]['Dest1'] != "" ? Tram(
                                              dest: trams[index]['Dest1'],
                                              line: trams[index]['Line'],
                                              waitTime: trams[index]['Wait1'],
                                              carriages: trams[index]['Carriages1'],
                                              status: trams[index]['Status1']
                                          ).render() : SizedBox.shrink(),
                                          trams[index]['Dest2'] != "" ? Tram(
                                              dest: trams[index]['Dest2'],
                                              line: trams[index]['Line'],
                                              waitTime: trams[index]['Wait2'],
                                              carriages: trams[index]['Carriages2'],
                                              status: trams[index]['Status2']
                                          ).render() : SizedBox.shrink(),
                                          trams[index]['Dest3'] != "" ? Tram(
                                              dest: trams[index]['Dest3'],
                                              line: trams[index]['Line'],
                                              waitTime: trams[index]['Wait3'],
                                              carriages: trams[index]['Carriages3'],
                                              status: trams[index]['Status3']
                                          ).render() : SizedBox.shrink(),
                                        ],
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
