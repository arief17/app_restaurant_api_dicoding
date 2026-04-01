import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_list_provider.dart';
import '../screens/restaurant_detail_page.dart';
import '../screens/restaurant_search_page.dart';
import '../services/api_service.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantListProvider>();
    final apiService = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Restoran'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RestaurantSearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const LoadingWidget();
          }

          if (provider.errorMessage.isNotEmpty) {
            return AppErrorWidget(
              message: provider.errorMessage,
              onRetry: provider.fetchRestaurants,
            );
          }

          if (provider.restaurants.isEmpty) {
            return const Center(
              child: Text('Belum ada data restoran.'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchRestaurants,
            child: ListView.builder(
              itemCount: provider.restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = provider.restaurants[index];

                return RestaurantCard(
                  restaurant: restaurant,
                  apiService: apiService,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RestaurantDetailPage(
                          restaurantId: restaurant.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
