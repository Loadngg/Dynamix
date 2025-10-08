import 'package:dynamix/ui/chart/view_model/chart_viewmodel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChartWidget extends StatelessWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChartViewModel>(
      builder: (context, viewModel, child) {
        final theme = Theme.of(context);
        final mainChartColor = theme.colorScheme.primary;
        final onMainChartColor = theme.colorScheme.onPrimary;
        final minValueColor = Colors.orange.withAlpha(70);
        final maxValueColor = Colors.red.withAlpha(70);

        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        final controller = TransformationController();

        return AspectRatio(
          aspectRatio: screenWidth / (screenHeight - 110),
          child: LineChart(
            transformationConfig: FlTransformationConfig(
              scaleAxis: FlScaleAxis.free,
              minScale: 1.0,
              maxScale: 10.0,
              panEnabled: true,
              scaleEnabled: true,
              transformationController: controller,
            ),
            LineChartData(
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => onMainChartColor,
                  tooltipBorder: BorderSide(color: mainChartColor),
                ),
              ),
              maxY: viewModel.maxY,
              minY: viewModel.minY,
              extraLinesData: ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: viewModel.group!.minValue,
                    color: minValueColor,
                  ),
                  HorizontalLine(
                    y: viewModel.group!.maxValue,
                    color: maxValueColor,
                  ),
                ],
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    interval: 1,
                    maxIncluded: true,
                    minIncluded: true,
                    getTitlesWidget: (value, meta) {
                      final angle = -45 * 3.14 / 180;
                      final date = viewModel.dates[value.toInt()];
                      return SideTitleWidget(
                        space: 30,
                        meta: meta,
                        child: Transform.rotate(
                          angle: angle,
                          child: Text(DateFormat.yMd('ru').format(date)),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: viewModel.spots,
                  isCurved: true,
                  barWidth: 2,
                  color: mainChartColor,
                  belowBarData: BarAreaData(
                    show: true,
                    color: maxValueColor,
                    cutOffY: viewModel.group!.maxValue,
                    applyCutOffY: true,
                  ),
                  aboveBarData: BarAreaData(
                    show: true,
                    color: minValueColor,
                    cutOffY: viewModel.group!.minValue,
                    applyCutOffY: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
