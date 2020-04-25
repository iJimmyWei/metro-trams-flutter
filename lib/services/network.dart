import 'package:http/http.dart' as http;
import 'responseDto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NetworkHelper {
    Future<List<String>> lookupStationNames(String searchInput) async {
        // Empty search strings to reset search UI
        if (searchInput == "") {
            return null;
        }

        List<String> stationNames = [];

        // Picadilly and picadilly gardens search not specific enough
        // If a search is done, it falls through to piccadilly on their api
        var url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=contains(stationLocation, \'$searchInput\')';
        var response = await http.get(url, headers: {
          'Ocp-Apim-Subscription-Key': DotEnv().env['API_KEY']
        });

        if (response.statusCode == 200) {
            ResponseDto res = ResponseDto.fromJson(response.body);

            for (var station in res.station) {
                String stationName = station.stationLocation;

                if (!stationNames.contains(stationName)) {
                  stationNames.add(station.stationLocation);
                }
            }
        
            stationNames.sort((a, b) => a.compareTo(b));

            return stationNames;
        } else {
            return [];
        }
    }

    Future<List<Station>> getStationData(String searchInput) async {
        // Empty search strings to reset search UI
        if (searchInput == "" || searchInput == null) {
            return null;
        }

        var url;
        if (searchInput.contains("'")) {
            String searchQuery = searchInput.split("'")[0];
            url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=contains(stationLocation, \'$searchQuery\')';

        } else {
            url = 'https://api.tfgm.com/odata/Metrolinks?\$filter=(stationLocation eq \'$searchInput\')';
        }

        var response = await http.get(url, headers: {
          'Ocp-Apim-Subscription-Key': DotEnv().env['API_KEY']
        });

        if (response.statusCode == 200) {
            ResponseDto res = ResponseDto.fromJson(response.body);

            return res.station;
        } else {
          return null;
        }
    }
}
