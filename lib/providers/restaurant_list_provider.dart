import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../services/api_service.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantListProvider({required this.apiService});

  bool isLoading = false;
  String errorMessage = '';
  List<Restaurant> restaurants = [];

  Future<void> fetchRestaurants() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      restaurants = await apiService.getRestaurantList();
    } catch (e) {
      errorMessage =
          e is String ? e : 'Terjadi kesalahan saat memuat daftar restoran.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
