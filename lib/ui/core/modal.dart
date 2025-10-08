import 'package:flutter/material.dart';

class Modal {
  Modal({required BuildContext context, required Widget form}) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(child: form);
      },
    );
  }
}
