import 'package:dynamix/ui/core/fab_add_button_widget.dart';
import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/groups/view_model/groups_viewmodel.dart';
import 'package:dynamix/ui/groups/widgets/forms/group_form.dart';
import 'package:dynamix/ui/groups/widgets/group_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupsViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: FabAddButtonWidget(
            onPressed: () {
              Modal(context: context, form: const GroupForm());
            },
          ),
          appBar: AppBar(title: Text(viewModel.folder!.name)),
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
                  child: const Center(child: GroupListWidget()),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
