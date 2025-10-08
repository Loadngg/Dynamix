import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/utils/id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupForm extends StatefulWidget {
  const GroupForm({super.key, this.group});

  final Group? group;

  String? validator(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

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
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        final theme = Theme.of(context);
        final titleStyle = theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        );

        final nameController = TextEditingController(text: widget.group?.name);
        final unitController = TextEditingController(text: widget.group?.unit);
        final minValueController = TextEditingController(
          text: widget.group?.minValue.toString(),
        );
        final maxValueController = TextEditingController(
          text: widget.group?.maxValue.toString(),
        );

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Добавление группы", style: titleStyle),

                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 16,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            labelText: "Название",
                            hintText: "Введите название группы",
                          ),
                          validator: (value) =>
                              widget.validator(value, "Введите название"),
                        ),

                        TextFormField(
                          controller: unitController,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.linear_scale),
                            labelText: "Единицы измерения",
                            hintText: "Введите единицы измерения",
                          ),
                          validator: (value) => widget.validator(
                            value,
                            "Введите единицы измерения",
                          ),
                        ),

                        TextFormField(
                          controller: maxValueController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.arrow_upward),
                            labelText: "Макс. значение",
                            hintText: "Введите максимальное значение",
                          ),
                          validator: (value) => widget.validatorNum(
                            value,
                            "Введите корректное максимальное значение",
                          ),
                        ),

                        TextFormField(
                          controller: minValueController,
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.arrow_downward),
                            labelText: "Мин. значение",
                            hintText: "Введите минимальное значение",
                          ),
                          validator: (value) => widget.validatorNum(
                            value,
                            "Введите корректное минимальное значение",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ElevatedButton.icon(
                  label: const Text("Сохранить"),
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.group != null) {
                        viewModel.editGroup.execute(
                          Group(
                            id: widget.group!.id,
                            folderId: widget.group!.folderId,
                            name: nameController.text,
                            unit: unitController.text,
                            minValue: double.parse(
                              minValueController.text.replaceAll(',', '.'),
                            ),
                            maxValue: double.parse(
                              maxValueController.text.replaceAll(',', '.'),
                            ),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Папка обновлена"),
                            showCloseIcon: true,
                          ),
                        );
                        Navigator.of(context).pop();
                        return;
                      }

                      viewModel.addGroup.execute(
                        Group(
                          id: Id.generate(),
                          folderId: viewModel.folder!.id,
                          name: nameController.text,
                          unit: unitController.text,
                          minValue: double.parse(
                            minValueController.text.replaceAll(',', '.'),
                          ),
                          maxValue: double.parse(
                            maxValueController.text.replaceAll(',', '.'),
                          ),
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Папка добавлена"),
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
  }
}
