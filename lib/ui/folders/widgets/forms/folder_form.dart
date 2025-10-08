import 'package:dynamix/data/models/folder.dart';
import 'package:dynamix/ui/folders/view_model/folders_viewmodel.dart';
import 'package:dynamix/utils/id.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderForm extends StatefulWidget {
  const FolderForm({super.key, this.folder});

  final Folder? folder;

  String? validator(String? value, String errorText) {
    if (value == null || value.isEmpty) {
      return errorText;
    }
    return null;
  }

  @override
  State<FolderForm> createState() => _FolderFormState();
}

class _FolderFormState extends State<FolderForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<FoldersViewModel>(
      builder: (context, viewModel, child) {
        final theme = Theme.of(context);
        final titleStyle = theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        );

        final nameController = TextEditingController(text: widget.folder?.name);

        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Добавление папки", style: titleStyle),

                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    labelText: "Название",
                    hintText: "Введите название папки",
                  ),
                  validator: (value) =>
                      widget.validator(value, "Введите название"),
                ),

                ElevatedButton.icon(
                  label: const Text("Сохранить"),
                  icon: const Icon(Icons.save),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (widget.folder != null) {
                        viewModel.editFolder.execute(
                          Folder(
                            id: widget.folder!.id,
                            name: nameController.text,
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

                      viewModel.addFolder.execute(
                        Folder(id: Id.generate(), name: nameController.text),
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
