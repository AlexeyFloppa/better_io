// ignore_for_file: file_names

import 'package:flutter/material.dart';

class Example1Screen extends StatelessWidget {
  const Example1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Example 1',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
