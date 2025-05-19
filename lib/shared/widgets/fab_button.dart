import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class FABButton extends StatelessWidget {
  final void Function(BuildContext context)? onTap;

  const FABButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6, // Same as default FAB elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap != null ? () => onTap!(context) : () => developer.log("FAB pressed"),

          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              Icons.add,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}