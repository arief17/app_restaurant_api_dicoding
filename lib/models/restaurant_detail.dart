class CustomerReview {
  final String name;
  final String review;
  final String date;

  CustomerReview({
    required this.name,
    required this.review,
    required this.date,
  });

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String city;
  final String address;
  final String pictureId;
  final double rating;
  final List<String> foods;
  final List<String> drinks;
  final List<CustomerReview> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.foods,
    required this.drinks,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    final menus = json['menus'] ?? {};
    final foodsJson = menus['foods'] as List? ?? [];
    final drinksJson = menus['drinks'] as List? ?? [];
    final reviewsJson = json['customerReviews'] as List? ?? [];

    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      pictureId: json['pictureId'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      foods: foodsJson.map((e) => e['name'].toString()).toList(),
      drinks: drinksJson.map((e) => e['name'].toString()).toList(),
      customerReviews:
          reviewsJson.map((e) => CustomerReview.fromJson(e)).toList(),
    );
  }
}
