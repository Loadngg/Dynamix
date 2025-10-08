import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportCardWidget extends StatelessWidget {
  const ReportCardWidget({super.key, required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        final theme = Theme.of(context);
        final dateStyle = theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
        );
        final titleStyle = theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.secondary,
        );

        return Card(
          clipBehavior: Clip.hardEdge,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Text(
                      "${DateFormat.yMd('ru').format(report.date)}:",
                      style: dateStyle,
                    ),
                    Flexible(
                      child: Text(
                        softWrap: true,
                        "${report.value.toString()} ${viewModel.group!.unit}",
                        style: titleStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
