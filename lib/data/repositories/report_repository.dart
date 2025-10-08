import 'dart:convert';

import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportRepository {
  static const String _storageKey = 'reports';

  static Future<Result<List<Report>>> _getReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey) ?? '[]';
      final jsonList = json.decode(jsonString);
      if (jsonList.isEmpty) {
        return Result.ok([]);
      }
      List<Report> reports = [];
      for (var jsonItem in jsonList) {
        reports.add(Report.fromJson(jsonItem));
      }
      return Result.ok(reports);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<Report>>> getGroupReports(int groupId) async {
    try {
      final reportsResult = await _getReports();
      switch (reportsResult) {
        case Ok<List<Report>>():
          final List<Report> allReports = reportsResult.value;
          List<Report> groupReports = allReports
              .where((report) => report.groupId == groupId)
              .toList();
          groupReports.sort((a, b) => b.date.compareTo(a.date));
          return Result.ok(groupReports);
        case Error<List<Report>>():
          return Result.error(reportsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> addReport(Report report) async {
    try {
      final reportsResult = await _getReports();
      switch (reportsResult) {
        case Ok<List<Report>>():
          final List<Report> allReports = reportsResult.value;
          allReports.add(report);
          await _setPrefsString(allReports);
          return Result.ok(null);
        case Error<List<Report>>():
          return Result.error(reportsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> editReport(Report updatedReport) async {
    try {
      final reportsResult = await _getReports();
      switch (reportsResult) {
        case Ok<List<Report>>():
          final List<Report> allReports = reportsResult.value;
          final int index = allReports.indexWhere(
            (report) => report.id == updatedReport.id,
          );

          if (index == -1) {
            throw Exception('Report with id $updatedReport.id not found');
          }
          allReports[index] = updatedReport;
          await _setPrefsString(allReports);
          return Result.ok(null);
        case Error<List<Report>>():
          return Result.error(reportsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> deleteReport(int id) async {
    try {
      final reportsResult = await _getReports();
      switch (reportsResult) {
        case Ok<List<Report>>():
          final List<Report> allReports = reportsResult.value;
          allReports.removeWhere((report) => report.id == id);
          await _setPrefsString(allReports);
          return Result.ok(null);
        case Error<List<Report>>():
          return Result.error(reportsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<void>> clearReportsWithGroupId(int groupId) async {
    try {
      final reportsResult = await _getReports();
      switch (reportsResult) {
        case Ok<List<Report>>():
          final List<Report> allReports = reportsResult.value;
          allReports.removeWhere((report) => report.groupId == groupId);
          await _setPrefsString(allReports);
          return Result.ok(null);
        case Error<List<Report>>():
          return Result.error(reportsResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<void> _setPrefsString(List<Report> reports) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      reports.map((report) => report.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }
}
