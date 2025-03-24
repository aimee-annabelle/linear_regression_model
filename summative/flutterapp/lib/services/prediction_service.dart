import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_data.dart';

class PredictionService {
  static const String apiUrl = 'https://linear-regression-model-k1rp.onrender.com/predict';

  static Future<double> getPrediction(PredictionData data) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        return result['predicted_exam_score'];
      } else {
        throw Exception('Failed to get prediction: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
