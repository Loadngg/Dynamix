import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/groups/widgets/forms/group_form.dart';
import 'package:dynamix/ui/groups/widgets/group_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class GroupListWidget extends StatelessWidget {
  const GroupListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        final groups = viewModel.groups;

        if (groups.isEmpty) {
          return const Text('Группы ещё не добавлены');
        }

        final theme = Theme.of(context);
        final slidableBgColor = theme.colorScheme.surface;
        final slidableFgColor = theme.colorScheme.onSurface;

        return ListView.separated(
          padding: const EdgeInsets.only(bottom: 90),
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemCount: groups.length,
          itemBuilder: (_, index) => Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) {
                    viewModel.deleteGroup.execute(groups[index].id);
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
                      form: GroupForm(group: groups[index]),
                    );
                  },
                  backgroundColor: slidableBgColor,
                  foregroundColor: slidableFgColor,
                  icon: Icons.edit,
                  label: 'Редактировать',
                ),
              ],
            ),
            child: GroupCardWidget(group: groups[index]),
          ),
        );
      },
    );
  }
}
