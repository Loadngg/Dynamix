import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/ui/chart/widget/screen/chart_screen.dart';
import 'package:dynamix/ui/chart/view_model/chart_viewmodel.dart';
import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:dynamix/ui/reports/widgets/forms/report_form.dart';
import 'package:dynamix/ui/reports/widgets/screen/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCardWidget extends StatelessWidget {
  const GroupCardWidget({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        return Consumer<ReportsViewModel>(
          builder: (context, reportsViewModel, child) {
            return Consumer<ChartViewModel>(
              builder: (context, chartViewModel, child) {
                final theme = Theme.of(context);
                final titleStyle = theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                );

                return Card(
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {
                      reportsViewModel.setGroup.execute(group);
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => const ReportScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Row(
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  softWrap: true,
                                  group.name,
                                  style: titleStyle,
                                ),
                                GroupRecords(group: group),
                              ],
                            ),
                          ),
                          Row(
                            spacing: 16,
                            children: [
                              viewModel.groupReports[group.id]?.isEmpty ?? true
                                  ? const SizedBox.shrink()
                                  : IconButton.filledTonal(
                                      iconSize: 32,
                                      padding: const EdgeInsets.all(16),
                                      icon: const Icon(Icons.auto_graph),
                                      onPressed: () {
                                        chartViewModel.setGroup.execute(group);
                                        chartViewModel.setData.execute(
                                          viewModel.groupReports[group.id]!,
                                        );
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (context) =>
                                                const ChartScreen(),
                                          ),
                                        );
                                      },
                                    ),
                              IconButton.filled(
                                iconSize: 32,
                                padding: const EdgeInsets.all(16),
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  reportsViewModel.setGroup.execute(group);
                                  Modal(
                                    context: context,
                                    form: const ReportForm(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class GroupRecords extends StatelessWidget {
  const GroupRecords({super.key, required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        final theme = Theme.of(context);
        final records = viewModel.groupReports[group.id] ?? [];

        if (records.isEmpty) {
          return const SizedBox.shrink();
        }

        final firstValueStyle = theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        );

        if (records.length == 1) {
          return Text(
            "${records[0].value.toString()} ${group.unit}",
            style: firstValueStyle,
          );
        }

        final secondValueStyle = theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        );

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              softWrap: true,
              "${records[0].value.toString()} ${group.unit}",
              style: firstValueStyle,
            ),
            Text(
              softWrap: true,
              "${records[1].value.toString()} ${group.unit}",
              style: secondValueStyle,
            ),
          ],
        );
      },
    );
  }
}
