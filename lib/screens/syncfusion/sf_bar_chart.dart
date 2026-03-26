import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widgets/chart_card.dart';

class SfBarChartDemo extends StatefulWidget {
  const SfBarChartDemo({super.key});

  @override
  State<SfBarChartDemo> createState() => _SfBarChartDemoState();
}

class _SfBarChartDemoState extends State<SfBarChartDemo> {
  bool _stacked = false;
  static const _primary = Color(0xFF2E7D32);

  final _rng = Random();

  List<_FwData> _q1 = [
    _FwData('Flutter', 4200), _FwData('React Native', 3800),
    _FwData('Kotlin', 3100), _FwData('Swift', 2900), _FwData('Xamarin', 1800),
  ];

  List<_FwData> _q2 = [
    _FwData('Flutter', 4800), _FwData('React Native', 3600),
    _FwData('Kotlin', 3300), _FwData('Swift', 3100), _FwData('Xamarin', 1500),
  ];

  final _frameworks = ['Flutter', 'React Native', 'Kotlin', 'Swift', 'Xamarin'];

  void _refreshData() {
    setState(() {
      _q1 = _frameworks.map((f) =>
          _FwData(f, 1000 + _rng.nextInt(4000).toDouble())).toList();
      _q2 = _frameworks.map((f) =>
          _FwData(f, 1000 + _rng.nextInt(4000).toDouble())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.bar_chart_rounded,
          color: _primary,
          text: 'SfCartesianChart (ColumnSeries) — Syncfusion\nBật Stacked để xem tổng cộng dồn. Tooltip tích hợp sẵn.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: _stacked ? 'Tổng job Q1+Q2 (Stacked)' : 'Job tuyển dụng Q1 vs Q2',
          trailing: IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: _primary,
            tooltip: 'Thay đổi dữ liệu',
            onPressed: _refreshData,
          ),
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              textStyle: TextStyle(fontSize: 12),
            ),
            primaryXAxis: const CategoryAxis(
              labelStyle: TextStyle(fontSize: 10, color: Colors.grey),
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(width: 0),
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: _stacked ? 10000 : 6000,
              labelStyle: const TextStyle(fontSize: 10, color: Colors.grey),
              majorGridLines: const MajorGridLines(
                  width: 1, color: Color(0xFFEEEEEE)),
              axisLine: const AxisLine(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              color: const Color(0xFF1B5E20),
              textStyle: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            series: _stacked ? _stackedSeries() : _groupedSeries(),
          ),
        ),
        const SizedBox(height: 14),
        ControlPanel(children: [
          ControlSwitch(
            label: 'Stacked columns',
            subtitle: 'ColumnSeries → StackedColumnSeries',
            value: _stacked,
            activeColor: _primary,
            onChanged: (v) => setState(() => _stacked = v),
          ),
        ]),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Animation — Syncfusion',
          code:
              '// Entrance: tự động khi widget xuất hiện\n'
              'ColumnSeries(\n'
              '  animationDuration: 800,\n'
              '  ...\n'
              ')\n\n'
              '// Data change: setState → Syncfusion tự re-animate\n'
              'setState(() => _data = newData);',
        ),
      ],
    );
  }

  List<CartesianSeries> _groupedSeries() => [
        ColumnSeries<_FwData, String>(
          name: 'Q1',
          dataSource: _q1,
          xValueMapper: (d, _) => d.fw,
          yValueMapper: (d, _) => d.jobs,
          color: _primary,
          animationDuration: 800,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
        ColumnSeries<_FwData, String>(
          name: 'Q2',
          dataSource: _q2,
          xValueMapper: (d, _) => d.fw,
          yValueMapper: (d, _) => d.jobs,
          color: const Color(0xFF81C784),
          animationDuration: 800,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
        ),
      ];

  List<CartesianSeries> _stackedSeries() => [
        StackedColumnSeries<_FwData, String>(
          name: 'Q1',
          dataSource: _q1,
          xValueMapper: (d, _) => d.fw,
          yValueMapper: (d, _) => d.jobs,
          color: _primary,
          animationDuration: 800,
        ),
        StackedColumnSeries<_FwData, String>(
          name: 'Q2',
          dataSource: _q2,
          xValueMapper: (d, _) => d.fw,
          yValueMapper: (d, _) => d.jobs,
          color: const Color(0xFF81C784),
          animationDuration: 800,
        ),
      ];
}

class _FwData {
  final String fw;
  final double jobs;
  _FwData(this.fw, this.jobs);
}
