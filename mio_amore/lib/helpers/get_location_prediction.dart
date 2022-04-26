import 'dart:convert';
import 'package:mio_amore/config/config.dart';
import 'package:mio_amore/models/prediction_model.dart';
import 'package:http/http.dart' as http;

Future<List<Prediction>?> getLocationPrediction(String input) async {
  var _url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$input&language=en&key=${AppConfig.locationApiKey}');
  var response = await http.get(_url, headers: {"Accept": "application/json"});

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    var predictions = data['predictions'];

    List<Prediction> predictionList = [];
    for (var prediction in predictions) {
      Map<String, dynamic> predictionMap = prediction;
      predictionList.add(Prediction.fromMap(predictionMap));
    }
    return predictionList;
  } else {
    return null;
  }
}
