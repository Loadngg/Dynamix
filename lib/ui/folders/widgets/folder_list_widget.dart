import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/folders/view_model/folders_viewmodel.dart';
import 'package:dynamix/ui/folders/widgets/folder_card_widget.dart';
import 'package:dynamix/ui/folders/widgets/forms/folder_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class FolderListWidget extends StatelessWidget {
  const FolderListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoldersViewModel>(
      builder: (context, viewModel, child) {
        final folders = viewModel.folders;

        if (folders.isEmpty) {
          return const Text('Нет папок');
        }

        final theme = Theme.of(context);
        final slidableBgColor = theme.colorScheme.surface;
        final slidableFgColor = theme.colorScheme.onSurface;

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: folders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (_, index) => Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    viewModel.deleteFolder.execute(folders[index].id);
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
                      form: FolderForm(folder: folders[index]),
                    );
                  },
                  backgroundColor: slidableBgColor,
                  foregroundColor: slidableFgColor,
                  icon: Icons.edit,
                  label: 'Редактировать',
                ),
              ],
            ),
            child: FolderCardWidget(folder: folders[index]),
          ),
        );
      },
    );
  }
}
