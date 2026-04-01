import 'package:flutter/material.dart';
import '../models/restaurant_detail.dart';
import '../services/api_service.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantDetailProvider({required this.apiService});

  bool isLoading = false;
  String errorMessage = '';
  RestaurantDetail? restaurant;

  Future<void> fetchRestaurantDetail(String id) async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      restaurant = await apiService.getRestaurantDetail(id);
    } catch (e) {
      errorMessage =
          e is String ? e : 'Terjadi kesalahan saat memuat detail restoran.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateReviews(List<CustomerReview> reviews) {
    if (restaurant == null) return;

    restaurant = RestaurantDetail(
      id: restaurant!.id,
      name: restaurant!.name,
      description: restaurant!.description,
      city: restaurant!.city,
      address: restaurant!.address,
      pictureId: restaurant!.pictureId,
      rating: restaurant!.rating,
      foods: restaurant!.foods,
      drinks: restaurant!.drinks,
      customerReviews: reviews,
    );
    notifyListeners();
  }
}
