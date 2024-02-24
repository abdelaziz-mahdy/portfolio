import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final List<String> items;

  const CustomCard({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => Text(item)).toList(),
          ),
        ),
      ),
    );
  }
}
