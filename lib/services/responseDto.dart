import 'package:meta/meta.dart';
import 'dart:convert';

class ResponseDto {
  final String odataContext;
  final List<Station> station;

  ResponseDto({
    @required this.odataContext,
    @required this.station,
  });

  factory ResponseDto.fromJson(String str) =>
      ResponseDto.fromMap(json.decode(str));
  factory ResponseDto.fromMap(Map<String, dynamic> json) => ResponseDto(
        odataContext: json["@odata.context"],
        station:
            List<Station>.from(json["value"].map((x) => Station.fromMap(x))),
      );
}

class Tram {
  final String dest;
  final String waitTime;
  final String carriages;
  final String status;

  Tram(
      {@required this.dest,
      @required this.waitTime,
      @required this.carriages,
      @required this.status});
}

class Station {
  final int id;
  final String line;
  final String tlaref;
  final String pidref;
  final String stationLocation;
  final String atcoCode;
  final String direction;
  final List<Tram> trams;
  final String messageBoard;
  final DateTime lastUpdated;

  Station({
    @required this.id,
    @required this.line,
    @required this.tlaref,
    @required this.pidref,
    @required this.stationLocation,
    @required this.atcoCode,
    @required this.direction,
    @required this.trams,
    @required this.messageBoard,
    @required this.lastUpdated,
  });

  factory Station.fromJson(String str) => Station.fromMap(json.decode(str));

  factory Station.fromMap(Map<String, dynamic> json) => Station(
        id: json["Id"],
        line: json["Line"],
        tlaref: json["TLAREF"],
        pidref: json["PIDREF"],
        stationLocation: json["StationLocation"],
        atcoCode: json["AtcoCode"],
        direction: json["Direction"],
        trams: [
          Tram(
            dest: json["Dest0"],
            carriages: json["Carriages0"],
            status: json["Status0"],
            waitTime: json["Wait0"],
          ),
          Tram(
            dest: json["Dest1"],
            carriages: json["Carriages1"],
            status: json["Status1"],
            waitTime: json["Wait1"],
          ),
          Tram(
            dest: json["Dest2"],
            carriages: json["Carriages2"],
            status: json["Status2"],
            waitTime: json["Wait2"],
          ),
          Tram(
            dest: json["Dest3"],
            carriages: json["Carriages3"],
            status: json["Status3"],
            waitTime: json["Wait3"],
          ),
        ],
        messageBoard: json["MessageBoard"],
        lastUpdated: DateTime.parse(json["LastUpdated"]),
      );
}
