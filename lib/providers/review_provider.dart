import 'package:flutter/material.dart';
import '../models/review_response.dart';
import '../services/api_service.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  bool isLoading = false;
  String errorMessage = '';
  String successMessage = '';

  Future<ReviewResponse?> submitReview({
    required String id,
    required String name,
    required String review,
  }) async {
    isLoading = true;
    errorMessage = '';
    successMessage = '';
    notifyListeners();

    try {
      final result = await apiService.addReview(
        id: id,
        name: name,
        review: review,
      );

      successMessage = 'Review berhasil dikirim.';
      return result;
    } catch (e) {
      errorMessage = e is String ? e : 'Ulasan belum berhasil dikirim.';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearMessage() {
    errorMessage = '';
    successMessage = '';
    notifyListeners();
  }
}
