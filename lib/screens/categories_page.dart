import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample categories; replace these with your actual categories
    final List<String> categories = [
      'Education',
      'Sports',
      'Arts',
      'Technology',
      'Health',
      'Business',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            onTap: () {
              // Handle category selection
              // You could navigate to a category detail page here if needed
            },
          );
        },
      ),
    );
  }
}
