import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:dynamix/ui/reports/widgets/forms/report_form.dart';
import 'package:dynamix/ui/reports/widgets/report_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ReportListWidget extends StatelessWidget {
  const ReportListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        return Consumer<GroupsViewModel>(
          builder: (context, groupsViewModel, child) {
            final reports = viewModel.reports;

            if (reports.isEmpty) {
              return const Text('Записи ещё не добавлены');
            }

            final theme = Theme.of(context);
            final slidableBgColor = theme.colorScheme.surface;
            final slidableFgColor = theme.colorScheme.onSurface;

            return ListView.separated(
              padding: const EdgeInsets.only(bottom: 90),
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemCount: reports.length,
              itemBuilder: (_, index) => Slidable(
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        viewModel.deleteReport.execute(reports[index].id);
                        groupsViewModel.load.execute();
                      },
                      backgroundColor: slidableBgColor,
                      foregroundColor: slidableFgColor,
                      icon: Icons.delete,
                      label: 'Удалить',
                    ),
                    SlidableAction(
                      onPressed: (_) {
                        Modal(
                          context: context,
                          form: ReportForm(report: reports[index]),
                        );
                      },
                      backgroundColor: slidableBgColor,
                      foregroundColor: slidableFgColor,
                      icon: Icons.edit,
                      label: 'Редактировать',
                    ),
                  ],
                ),
                child: ReportCardWidget(report: reports[index]),
              ),
            );
          },
        );
      },
    );
  }
}
