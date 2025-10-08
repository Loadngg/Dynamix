import 'dart:convert';

import 'package:dynamix/data/models/folder.dart';
import 'package:dynamix/data/repositories/group_repository.dart';
import 'package:dynamix/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderRepository {
  static const String _storageKey = 'folders';

  static Future<Result<List<Folder>>> getFolders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey) ?? '[]';
      final jsonList = json.decode(jsonString);
      if (jsonList.isEmpty) {
        return Result.ok([]);
      }
      List<Folder> folders = [];
      for (var jsonItem in jsonList) {
        folders.add(Folder.fromJson(jsonItem));
      }
      folders.sort((a, b) => a.name.compareTo(b.name));
      return Result.ok(folders);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> addFolder(Folder folder) async {
    try {
      final foldersResult = await getFolders();
      switch (foldersResult) {
        case Ok<List<Folder>>():
          final List<Folder> allFolders = foldersResult.value;
          allFolders.add(folder);
          await _setPrefsString(allFolders);
          return Result.ok(null);
        case Error<List<Folder>>():
          return Result.error(foldersResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> editFolder(Folder updatedFolder) async {
    try {
      final foldersResult = await getFolders();
      switch (foldersResult) {
        case Ok<List<Folder>>():
          final List<Folder> allFolders = foldersResult.value;
          final int index = allFolders.indexWhere(
            (folder) => folder.id == updatedFolder.id,
          );

          if (index == -1) {
            throw Exception('Folder with id $updatedFolder.id not found');
          }
          allFolders[index] = updatedFolder;
          await _setPrefsString(allFolders);
          return Result.ok(null);
        case Error<List<Folder>>():
          return Result.error(foldersResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> deleteFolder(int id) async {
    try {
      final foldersResult = await getFolders();
      switch (foldersResult) {
        case Ok<List<Folder>>():
          final List<Folder> allFolders = foldersResult.value;
          allFolders.removeWhere((folder) => folder.id == id);
          await _setPrefsString(allFolders);
          await GroupRepository.clearGroupsWithGroupId(id);
          return Result.ok(null);
        case Error<List<Folder>>():
          return Result.error(foldersResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<void> _setPrefsString(List<Folder> folders) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      folders.map((folder) => folder.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }
}
