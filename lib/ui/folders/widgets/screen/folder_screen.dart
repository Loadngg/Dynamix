import 'package:dynamix/ui/core/fab_add_button_widget.dart';
import 'package:dynamix/ui/core/modal.dart';
import 'package:dynamix/ui/folders/view_model/folders_viewmodel.dart';
import 'package:dynamix/ui/folders/widgets/folder_list_widget.dart';
import 'package:dynamix/ui/folders/widgets/forms/folder_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FolderScreen extends StatelessWidget {
  const FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FoldersViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          floatingActionButton: FabAddButtonWidget(
            onPressed: () {
              Modal(context: context, form: const FolderForm());
            },
          ),
          appBar: AppBar(
            title: Text("Dynamix"),
            titleTextStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: SafeArea(
            child: ListenableBuilder(
              listenable: viewModel.load,
              builder: (context, child) {
                if (viewModel.load.running) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (viewModel.load.error) {
                  return ErrorWidget(viewModel.load.error);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Center(child: FolderListWidget()),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
