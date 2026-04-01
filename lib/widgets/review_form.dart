import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/restaurant_detail_provider.dart';
import '../providers/review_provider.dart';

class ReviewForm extends StatefulWidget {
  final String restaurantId;

  const ReviewForm({
    super.key,
    required this.restaurantId,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final reviewProvider = context.read<ReviewProvider>();
    final detailProvider = context.read<RestaurantDetailProvider>();

    final result = await reviewProvider.submitReview(
      id: widget.restaurantId,
      name: _nameController.text.trim(),
      review: _reviewController.text.trim(),
    );

    if (!mounted) return;

    if (result != null) {
      detailProvider.updateReviews(result.customerReviews);

      _nameController.clear();
      _reviewController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review berhasil dikirim.'),
        ),
      );

      reviewProvider.clearMessage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            reviewProvider.errorMessage.isNotEmpty
                ? reviewProvider.errorMessage
                : 'Ulasan belum berhasil dikirim.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = context.watch<ReviewProvider>();

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah Review',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reviewController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Ulasan',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.reviews),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ulasan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: reviewProvider.isLoading ? null : _submit,
                  child: reviewProvider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kirim Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
