import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantSearchProvider({required this.apiService});

  bool isLoading = false;
  String errorMessage = '';
  List<Restaurant> results = [];

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      results = [];
      errorMessage = '';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      results = await apiService.searchRestaurants(query);
    } catch (e) {
      errorMessage =
          e is String ? e : 'Terjadi kesalahan saat mencari restoran.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    results = [];
    errorMessage = '';
    notifyListeners();
  }
}
