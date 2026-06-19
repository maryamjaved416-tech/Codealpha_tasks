import 'package:flutter/material.dart';
import '../data/quotes_data.dart';

class CategoriesScreen extends StatelessWidget {
  final Function(String) onCategorySelected;

  const CategoriesScreen({
    super.key,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = QuotesData.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final count = QuotesData.getQuotesByCategory(category).length;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.format_quote, color: Color(0xFFFF6B35)),
              ),
              title: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text('$count quotes available'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                onCategorySelected(category); // Home tab pe bhej dega + category set karega
              },
            ),
          );
        },
      ),
    );
  }
}