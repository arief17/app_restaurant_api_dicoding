import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_detail_provider.dart';
import '../services/api_service.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/review_form.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<RestaurantDetailPage> createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantDetailProvider>().fetchRestaurantDetail(
            widget.restaurantId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantDetailProvider>();
    final apiService = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Restoran'),
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.errorMessage.isNotEmpty) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () {
                provider.fetchRestaurantDetail(widget.restaurantId);
              },
            );
          }

          final restaurant = provider.restaurant;
          if (restaurant == null) {
            return const Center(
              child: Text('Detail restoran tidak ditemukan.'),
            );
          }

          final heroTag = 'restaurant-image-${restaurant.id}';
          final titleHeroTag = 'restaurant-title-${restaurant.id}';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: Image.network(
                    apiService.largeImage(restaurant.pictureId),
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        height: 240,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 240,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: titleHeroTag,
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            restaurant.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_city),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                                '${restaurant.city}, ${restaurant.address}'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(restaurant.rating.toString()),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Deskripsi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(restaurant.description),
                      const SizedBox(height: 20),
                      const Text(
                        'Makanan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: restaurant.foods
                            .map((food) => Chip(label: Text(food)))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Minuman',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: restaurant.drinks
                            .map((drink) => Chip(label: Text(drink)))
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      ReviewForm(restaurantId: restaurant.id),
                      const SizedBox(height: 24),
                      const Text(
                        'Review Pelanggan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (restaurant.customerReviews.isEmpty)
                        const Text('Belum ada review.')
                      else
                        Column(
                          children: restaurant.customerReviews.map((review) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                                title: Text(review.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(review.review),
                                    const SizedBox(height: 4),
                                    Text(
                                      review.date,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
