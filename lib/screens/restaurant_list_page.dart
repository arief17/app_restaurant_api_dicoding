import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_list_provider.dart';
import '../providers/theme_provider.dart';
import '../screens/restaurant_detail_page.dart';
import '../screens/restaurant_search_page.dart';
import '../services/api_service.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantListPage extends StatelessWidget {
  const RestaurantListPage({super.key});

  void _showThemeBottomSheet(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const ListTile(
                  title: Text(
                    'Pilih Tema',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: const Text('Ikuti Sistem'),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.light_mode),
                  title: const Text('Light Mode'),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.light);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Dark Mode'),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeMode.dark);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantListProvider>();
    final apiService = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Restoran'),
        actions: [
          IconButton(
            onPressed: () => _showThemeBottomSheet(context),
            icon: const Icon(Icons.palette_outlined),
          ),
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
