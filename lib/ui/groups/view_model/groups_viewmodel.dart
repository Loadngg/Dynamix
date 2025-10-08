import 'package:dynamix/data/models/folder.dart';
import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/data/repositories/group_repository.dart';
import 'package:dynamix/data/repositories/report_repository.dart';
import 'package:dynamix/utils/command.dart';
import 'package:dynamix/utils/result.dart';
import 'package:flutter/material.dart';

class GroupsViewModel extends ChangeNotifier {
  GroupsViewModel() {
    load = Command0(_load);
    setFolder = Command1<void, Folder>(_setFolder);
    addGroup = Command1<void, Group>(_addGroup);
    editGroup = Command1<void, Group>(_editGroup);
    deleteGroup = Command1<void, int>(_deleteGroup);
  }

  Folder? _folder;
  Folder? get folder => _folder;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  final Map<int, List<Report>> _groupReports = {};
  Map<int, List<Report>> get groupReports => _groupReports;

  late Command0 load;
  late Command1<void, Folder> setFolder;
  late Command1<void, Group> addGroup;
  late Command1<void, Group> editGroup;
  late Command1<void, int> deleteGroup;

  @override
  void dispose() {
    load.dispose();
    setFolder.dispose();
    addGroup.dispose();
    editGroup.dispose();
    deleteGroup.dispose();

    super.dispose();
  }

  Future<Result<void>> _setFolder(Folder folder) async {
    try {
      _folder = folder;
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _load() async {
    try {
      _groups.clear();
      if (folder == null) {
        throw Exception('Folder is null');
      }
      final groupsResult = await GroupRepository.getFolderGroups(folder!.id);
      switch (groupsResult) {
        case Ok<List<Group>>():
          _groups = groupsResult.value;
        case Error<List<Group>>():
          throw groupsResult.error;
      }

      _groupReports.clear();
      for (final group in _groups) {
        final reportsResult = await ReportRepository.getGroupReports(group.id);
        switch (reportsResult) {
          case Ok<List<Report>>():
            _groupReports[group.id] = reportsResult.value;
          case Error<List<Report>>():
            throw reportsResult.error;
        }
      }

      return groupsResult;
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addGroup(Group group) async {
    try {
      await GroupRepository.addGroup(group);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _editGroup(Group group) async {
    try {
      await GroupRepository.editGroup(group);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _deleteGroup(int id) async {
    try {
      await GroupRepository.deleteGroup(id);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
