import 'package:flutter/material.dart';
import 'package:better_io/core/theme/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              children: [
                Text(
                  'Welcome to Better.io!',
                  textAlign: TextAlign.center,
                  style: AppConstants.headerTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
