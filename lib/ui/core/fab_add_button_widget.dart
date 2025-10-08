import 'package:flutter/material.dart';

class FabAddButtonWidget extends StatelessWidget {
  const FabAddButtonWidget({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text("Добавить"),
    );
  }
}
