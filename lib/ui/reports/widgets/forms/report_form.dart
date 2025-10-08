import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/reports/view_model/reports_viewmodel.dart';
import 'package:dynamix/utils/id.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({super.key, this.report});

  final Report? report;

  String? validatorNum(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    final num = double.tryParse(value.replaceAll(',', '.'));
    if (num == null) {
      return errorText;
    }
    if (num < 0 || !num.isFinite) {
      return errorText;
    }
    return null;
  }

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, viewModel, child) {
        return Consumer<GroupsViewModel>(
          builder: (context, groupsViewModel, child) {
            final valueController = TextEditingController(
              text: widget.report?.value.toString(),
            );

            final now = DateTime.now();

            DateTime dateField = DateTime(
              viewModel.lastSelectedDate.year,
              viewModel.lastSelectedDate.month,
              viewModel.lastSelectedDate.day,
              now.hour,
              now.minute,
              now.second,
            );

            Future<void> selectDate() async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: dateField,
                firstDate: DateTime(2000),
                lastDate: now,
                locale: Locale('ru', 'RU'),
                keyboardType: TextInputType.datetime,
              );
              if (pickedDate == null) return;

              final newDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                now.hour,
                now.minute,
                now.second,
              );

              viewModel.setLastSelectedDate.execute(newDate);
              setState(() {
                dateField = newDate;
              });
            }

            final theme = Theme.of(context);
            final titleStyle = theme.textTheme.titleLarge!.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            );
            final dateTimeStyle = theme.textTheme.headlineSmall;

            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 48,
                ),
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Добавление записи", style: titleStyle),

                    TextButton(
                      onPressed: selectDate,
                      child: Text(
                        DateFormat.yMMMd('ru').format(dateField),
                        style: dateTimeStyle,
                      ),
                    ),

                    TextFormField(
                      controller: valueController,
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.onetwothree),
                        labelText: "Значение",
                        hintText: "Введите значение",
                      ),
                      validator: (value) =>
                          widget.validatorNum(value, "Введите значение"),
                    ),

                    ElevatedButton.icon(
                      label: const Text("Сохранить"),
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (widget.report != null) {
                            viewModel.editReport.execute(
                              Report(
                                id: widget.report!.id,
                                groupId: widget.report!.groupId,
                                date: dateField,
                                value: double.parse(
                                  valueController.text.replaceAll(',', '.'),
                                ),
                              ),
                            );
                            groupsViewModel.load.execute();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Запись обновлена"),
                                showCloseIcon: true,
                              ),
                            );
                            Navigator.of(context).pop();
                            return;
                          }

                          viewModel.addReport.execute(
                            Report(
                              id: Id.generate(),
                              groupId: viewModel.group!.id,
                              date: dateField,
                              value: double.parse(
                                valueController.text.replaceAll(',', '.'),
                              ),
                            ),
                          );
                          groupsViewModel.load.execute();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Запись добавлена"),
                              showCloseIcon: true,
                            ),
                          );

                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
