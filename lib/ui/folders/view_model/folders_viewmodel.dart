import 'package:dynamix/data/models/folder.dart';
import 'package:dynamix/data/repositories/folder_repository.dart';
import 'package:dynamix/utils/command.dart';
import 'package:dynamix/utils/result.dart';
import 'package:flutter/material.dart';

class FoldersViewModel extends ChangeNotifier {
  FoldersViewModel() {
    load = Command0(_load)..execute();

    addFolder = Command1<void, Folder>(_addFolder);
    editFolder = Command1<void, Folder>(_editFolder);
    deleteFolder = Command1<void, int>(_deleteFolder);
  }

  List<Folder> _folders = [];
  List<Folder> get folders => _folders;

  late Command0 load;

  late Command1<void, Folder> addFolder;
  late Command1<void, Folder> editFolder;
  late Command1<void, int> deleteFolder;

  @override
  void dispose() {
    load.dispose();

    addFolder.dispose();
    editFolder.dispose();
    deleteFolder.dispose();

    super.dispose();
  }

  Future<Result<void>> _load() async {
    try {
      final foldersResult = await FolderRepository.getFolders();
      switch (foldersResult) {
        case Ok<List<Folder>>():
          _folders = foldersResult.value;
        case Error<List<Folder>>():
          throw foldersResult.error;
      }

      return foldersResult;
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addFolder(Folder folder) async {
    try {
      await FolderRepository.addFolder(folder);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _editFolder(Folder folder) async {
    try {
      await FolderRepository.editFolder(folder);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _deleteFolder(int id) async {
    try {
      await FolderRepository.deleteFolder(id);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
