import 'package:flutter/material.dart';

class BottomTaskSheet extends StatelessWidget {
  final VoidCallback onTaskEdit;
  final VoidCallback onTaskRemove;
  final VoidCallback onRecurrencyRemove;

  const BottomTaskSheet({
    super.key,
    required this.onTaskEdit,
    required this.onTaskRemove,
    required this.onRecurrencyRemove,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit'),
            onTap: () {
              Navigator.pop(context);
              onTaskEdit();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Remove Task'),
            onTap: () {
              Navigator.pop(context);
              onTaskRemove();
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('Remove Recurrency'),
            onTap: () {
              Navigator.pop(context);
              onRecurrencyRemove();
            },
          ),
        ],
      ),
    );
  }
}
