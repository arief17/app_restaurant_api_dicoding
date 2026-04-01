import 'restaurant_detail.dart';

class ReviewResponse {
  final bool error;
  final String message;
  final List<CustomerReview> customerReviews;

  ReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    final reviews = json['customerReviews'] as List? ?? [];

    return ReviewResponse(
      error: json['error'] ?? true,
      message: json['message'] ?? '',
      customerReviews: reviews.map((e) => CustomerReview.fromJson(e)).toList(),
    );
  }
}
