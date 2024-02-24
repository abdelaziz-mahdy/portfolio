import 'package:flutter/material.dart';

Widget buildCardWithTitleAndChildren(String title, List<Widget> children) {
  return Card(
    margin: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        ...children,
      ],
    ),
  );
}
