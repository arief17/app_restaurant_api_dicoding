import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_search_provider.dart';
import '../screens/restaurant_detail_page.dart';
import '../services/api_service.dart';
import '../widgets/app_error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/restaurant_card.dart';

class RestaurantSearchPage extends StatefulWidget {
  const RestaurantSearchPage({super.key});

  @override
  State<RestaurantSearchPage> createState() => _RestaurantSearchPageState();
}

class _RestaurantSearchPageState extends State<RestaurantSearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RestaurantSearchProvider>();
    final apiService = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Restoran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                context.read<RestaurantSearchProvider>().search(value);
              },
              decoration: InputDecoration(
                hintText: 'Cari restoran, misalnya cafe',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    context.read<RestaurantSearchProvider>().clear();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (provider.isLoading) {
                    return const LoadingWidget();
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    return AppErrorWidget(message: provider.errorMessage);
                  }

                  if (_searchController.text.isEmpty) {
                    return const Center(
                      child:
                          Text('Masukkan kata kunci untuk mencari restoran.'),
                    );
                  }

                  if (provider.results.isEmpty) {
                    return const Center(
                      child: Text('Restoran tidak ditemukan.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.results.length,
                    itemBuilder: (context, index) {
                      final restaurant = provider.results[index];
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
