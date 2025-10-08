import 'dart:convert';

import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/data/repositories/report_repository.dart';
import 'package:dynamix/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupRepository {
  static const String _storageKey = 'groups';

  static Future<Result<List<Group>>> _getGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey) ?? '[]';
      final jsonList = json.decode(jsonString);
      if (jsonList.isEmpty) {
        return Result.ok([]);
      }
      List<Group> groups = [];
      for (var jsonItem in jsonList) {
        groups.add(Group.fromJson(jsonItem));
      }
      return Result.ok(groups);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<Group>>> getFolderGroups(int folderId) async {
    try {
      final groupsResult = await _getGroups();
      switch (groupsResult) {
        case Ok<List<Group>>():
          final List<Group> allGroups = groupsResult.value;
          List<Group> folderGroups = allGroups
              .where((group) => group.folderId == folderId)
              .toList();
          folderGroups.sort((a, b) => a.name.compareTo(b.name));
          return Result.ok(folderGroups);
        case Error<List<Group>>():
          return Result.error(groupsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> addGroup(Group group) async {
    try {
      final groupsResult = await _getGroups();
      switch (groupsResult) {
        case Ok<List<Group>>():
          final List<Group> allGroups = groupsResult.value;
          allGroups.add(group);
          await _setPrefsString(allGroups);
          return Result.ok(null);
        case Error<List<Group>>():
          return Result.error(groupsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> editGroup(Group updatedGroup) async {
    try {
      final groupsResult = await _getGroups();
      switch (groupsResult) {
        case Ok<List<Group>>():
          final List<Group> allGroups = groupsResult.value;
          final int index = allGroups.indexWhere(
            (group) => group.id == updatedGroup.id,
          );

          if (index == -1) {
            throw Exception('Group with id $updatedGroup.id not found');
          }
          allGroups[index] = updatedGroup;
          await _setPrefsString(allGroups);
          return Result.ok(null);
        case Error<List<Group>>():
          return Result.error(groupsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> deleteGroup(int id) async {
    try {
      final groupsResult = await _getGroups();
      switch (groupsResult) {
        case Ok<List<Group>>():
          final List<Group> allGroups = groupsResult.value;
          allGroups.removeWhere((group) => group.id == id);
          await _setPrefsString(allGroups);
          await ReportRepository.clearReportsWithGroupId(id);
          return Result.ok(null);
        case Error<List<Group>>():
          return Result.error(groupsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> clearGroupsWithGroupId(int folderId) async {
    try {
      final groupsResult = await _getGroups();
      switch (groupsResult) {
        case Ok<List<Group>>():
          final List<Group> allGroups = groupsResult.value;
          final List<Group> groupsToDelete = allGroups
              .where((group) => group.folderId == folderId)
              .toList();
          for (var group in groupsToDelete) {
            await ReportRepository.clearReportsWithGroupId(group.id);
            allGroups.removeWhere((g) => g.id == group.id);
          }
          await _setPrefsString(allGroups);
          return Result.ok(null);
        case Error<List<Group>>():
          return Result.error(groupsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<void> _setPrefsString(List<Group> groups) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      groups.map((group) => group.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }
}
