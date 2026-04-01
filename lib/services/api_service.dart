import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/restaurant.dart';
import '../models/restaurant_detail.dart';
import '../models/review_response.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<List<Restaurant>> getRestaurantList() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/list'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final restaurants = body['restaurants'] as List<dynamic>;
        return restaurants.map((e) => Restaurant.fromJson(e)).toList();
      }

      throw 'Daftar restoran gagal dimuat.';
    } catch (_) {
      throw 'Tidak dapat memuat daftar restoran. Periksa koneksi internet Anda lalu coba lagi.';
    }
  }

  Future<RestaurantDetail> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return RestaurantDetail.fromJson(body['restaurant']);
      }

      throw 'Detail restoran gagal dimuat.';
    } catch (_) {
      throw 'Tidak dapat memuat detail restoran saat ini. Silakan coba lagi.';
    }
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final restaurants = body['restaurants'] as List<dynamic>;
        return restaurants.map((e) => Restaurant.fromJson(e)).toList();
      }

      throw 'Pencarian gagal.';
    } catch (_) {
      throw 'Pencarian restoran gagal. Coba kata kunci lain atau periksa koneksi Anda.';
    }
  }

  Future<ReviewResponse> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/review'),
        headers: const {
          'Content-Type': 'application/json',
          'X-Auth-Token': '12345',
        },
        body: jsonEncode({
          'id': id,
          'name': name,
          'review': review,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return ReviewResponse.fromJson(body);
      }

      throw 'Review gagal dikirim.';
    } catch (_) {
      throw 'Ulasan belum berhasil dikirim. Silakan coba beberapa saat lagi.';
    }
  }

  String smallImage(String pictureId) => '$_baseUrl/images/small/$pictureId';
  String mediumImage(String pictureId) => '$_baseUrl/images/medium/$pictureId';
  String largeImage(String pictureId) => '$_baseUrl/images/large/$pictureId';
}
