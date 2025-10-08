import 'package:dynamix/ui/chart/chart_widget.dart';
import 'package:dynamix/ui/chart/view_model/chart_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text(viewModel.group!.name)),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 36,
                left: 8,
                top: 8,
                bottom: 8,
              ),
              child: const Center(child: ChartWidget()),
            ),
          ),
        );
      },
    );
  }
}
