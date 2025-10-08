import 'package:dynamix/data/models/group.dart';
import 'package:dynamix/data/models/report.dart';
import 'package:dynamix/utils/command.dart';
import 'package:dynamix/utils/result.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartViewModel extends ChangeNotifier {
  ChartViewModel() {
    setData = Command1<void, List<Report>>(_setData);
    setGroup = Command1<void, Group>(_setGroup);
  }

  Group? _group;
  Group? get group => _group;

  final List<FlSpot> _spots = [];
  List<FlSpot> get spots => _spots;

  final List<DateTime> _dates = [];
  List<DateTime> get dates => _dates;

  double? _minY;
  double? get minY => _minY;

  double? _maxY;
  double? get maxY => _maxY;

  late Command1<void, Group> setGroup;
  late Command1<void, List<Report>> setData;

  @override
  void dispose() {
    setData.dispose();
    setGroup.dispose();

    super.dispose();
  }

  Future<Result<void>> _setGroup(Group group) async {
    try {
      _group = group;
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> _setData(List<Report> reports) async {
    try {
      _spots.clear();
      _dates.clear();
      final reversed = reports.reversed.toList();
      reversed.asMap().forEach((key, value) {
        _spots.add(FlSpot(key.toDouble(), value.value));
        _dates.add(value.date);
      });

      final minY = reports.reduce(
        (curr, next) => curr.value < next.value ? curr : next,
      );

      final maxY = reports.reduce(
        (curr, next) => curr.value > next.value ? curr : next,
      );

      _minY = minY.value - 2;
      _maxY = maxY.value + 2;
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
