import 'package:flutter/material.dart';
import '../models/prediction_data.dart';

class FormProvider extends ChangeNotifier {
  final PredictionData data = PredictionData();
  int _currentPage = 0;
  bool _isLoading = false;
  String? _error;
  double? _prediction;

  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double? get prediction => _prediction;

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void nextPage() {
    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void setPrediction(double prediction) {
    _prediction = prediction;
    notifyListeners();
  }

  void reset() {
    _currentPage = 0;
    _isLoading = false;
    _error = null;
    _prediction = null;
    notifyListeners();
  }
}
