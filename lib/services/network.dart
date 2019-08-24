import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
    Future<dynamic> lookupStationNames(String searchInput) async {
        var url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=contains(stationLocation, \'$searchInput\')';
        var response = await http.get(url, headers: {'Ocp-Apim-Subscription-Key': 'e70f3d5bd74c4019818af8e76ef4f9ff'});
        if (response.statusCode == 200) {
            Map data = jsonDecode(response.body);
            List stations = [];

            for (var station in data["value"]) {
                String stationName = station["StationLocation"];
                
                if (!stations.contains(stationName)) {
                    stations.add(stationName);
                }
            }

            return stations;
        } else {
            return "error";
        }
    }
}