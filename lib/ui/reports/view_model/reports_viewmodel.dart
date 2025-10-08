import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/data/repositories/report_repository.dart';
import 'package:dynamix/utils/command.dart';
import 'package:dynamix/utils/result.dart';
import 'package:flutter/material.dart';

class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel() {
    load = Command0(_load);
    setGroup = Command1<void, Group>(_setGroup);
    setLastSelectedDate = Command1<void, DateTime>(_setLastSelectedDate);
    addReport = Command1<void, Report>(_addReport);
    editReport = Command1<void, Report>(_editReport);
    deleteReport = Command1<void, int>(_deleteReport);
  }

  Group? _group;
  Group? get group => _group;

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  DateTime _lastSelectedDate = DateTime.now();
  DateTime get lastSelectedDate => _lastSelectedDate;

  late Command0 load;
  late Command1<void, Group> setGroup;
  late Command1<void, DateTime> setLastSelectedDate;
  late Command1<void, Report> addReport;
  late Command1<void, Report> editReport;
  late Command1<void, int> deleteReport;

  @override
  void dispose() {
    load.dispose();
    setGroup.dispose();
    setLastSelectedDate.dispose();
    addReport.dispose();
    editReport.dispose();
    deleteReport.dispose();

    super.dispose();
  }

  Future<Result<void>> _setGroup(Group group) async {
    try {
      _group = group;
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setLastSelectedDate(DateTime lastSelectedDate) async {
    try {
      _lastSelectedDate = lastSelectedDate;
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _load() async {
    try {
      if (group == null) {
        throw Exception('Group is null');
      }
      final reportsResult = await ReportRepository.getGroupReports(group!.id);
      switch (reportsResult) {
        case Ok<List<Report>>():
          _reports = reportsResult.value;
          return reportsResult;
        case Error<List<Report>>():
          throw reportsResult.error;
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _addReport(Report report) async {
    try {
      await ReportRepository.addReport(report);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _editReport(Report report) async {
    try {
      await ReportRepository.editReport(report);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _deleteReport(int id) async {
    try {
      await ReportRepository.deleteReport(id);
      await _load();
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
