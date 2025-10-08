import 'package:dynamix/data/models/folder.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/groups/widgets/screen/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderCardWidget extends StatelessWidget {
  const FolderCardWidget({super.key, required this.folder});

  final Folder folder;

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        final titleStyle = Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

        return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {
              viewModel.setFolder.execute(folder);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const GroupScreen(),
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Text(softWrap: true, folder.name, style: titleStyle),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
