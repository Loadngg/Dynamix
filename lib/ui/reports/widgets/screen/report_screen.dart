import 'package:dynamix/ui/chart/widget/screen/chart_screen.dart';
import 'package:dynamix/ui/chart/view_model/chart_viewmodel.dart';
import 'package:dynamix/ui/core/fab_add_button_widget.dart';
import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:dynamix/ui/reports/widgets/forms/report_form.dart';
import 'package:dynamix/ui/reports/widgets/report_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        return Consumer<ChartViewModel>(
          builder: (context, chartViewModel, child) {
            return Scaffold(
              floatingActionButton: FabAddButtonWidget(
                onPressed: () {
                  Modal(context: context, form: const ReportForm());
                },
              ),
              appBar: AppBar(
                title: Text(viewModel.group!.name),
                actionsPadding: const EdgeInsets.only(right: 8),
                actions: viewModel.reports.isNotEmpty
                    ? [
                        IconButton(
                          onPressed: () {
                            chartViewModel.setGroup.execute(viewModel.group!);
                            chartViewModel.setData.execute(viewModel.reports);
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (context) => const ChartScreen(),
                              ),
                            );
                          },
                          iconSize: 32,
                          icon: const Icon(Icons.auto_graph),
                        ),
                      ]
                    : [],
              ),
              body: SafeArea(
                child: ListenableBuilder(
                  listenable: viewModel.load,
                  builder: (_, _) {
                    if (viewModel.load.running) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.load.error) {
                      return ErrorWidget(viewModel.load.error);
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: const Center(child: ReportListWidget()),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
