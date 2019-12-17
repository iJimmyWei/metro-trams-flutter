import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
    Future<dynamic> lookupStationNames(String searchInput) async {
        // Empty search strings to reset search UI
        if (searchInput == "") {
            return null;
        }

        List stations = [];

        // Picadilly and picadilly gardens search not specific enough
        // If a search is done, it falls through to piccadilly on their api
        var url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=contains(stationLocation, \'$searchInput\')';
        var response = await http.get(url, headers: {
        'Ocp-Apim-Subscription-Key': 'e70f3d5bd74c4019818af8e76ef4f9ff'
        });

        if (response.statusCode == 200) {
            Map data = jsonDecode(response.body);

            for (var station in data["value"]) {
                String stationName = station["StationLocation"];

                if (!stations.contains(stationName)) {
                stations.add(stationName);
                }

                stations.sort((a, b) => a.compareTo(b));
            }

            return stations;
        } else {
            return "error";
        }
    }

    Future<dynamic> getStationData(String searchInput) async {
        // Empty search strings to reset search UI
        if (searchInput == "" || searchInput == null) {
            return null;
        }

        List stations = [];

        // Handle apostraphe
        var url;
        if (searchInput.contains("'")) {
            String searchQuery = searchInput.split("'")[0];
            url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=contains(stationLocation, \'$searchQuery\')';

        } else {
            url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=(stationLocation eq \'$searchInput\')';
        }

        print(url);

        var response = await http.get(url, headers: {
        'Ocp-Apim-Subscription-Key': 'e70f3d5bd74c4019818af8e76ef4f9ff'
        });

        if (response.statusCode == 200) {
            Map data = jsonDecode(response.body);

            for (var station in data["value"]) {
                stations.add(station);
            }

            return stations;
        } else {
            return "error";
        }
    }
}
