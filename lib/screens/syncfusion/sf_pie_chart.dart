import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widgets/chart_card.dart';

class SfPieChartDemo extends StatefulWidget {
  const SfPieChartDemo({super.key});

  @override
  State<SfPieChartDemo> createState() => _SfPieChartDemoState();
}

class _SfPieChartDemoState extends State<SfPieChartDemo> {
  bool _doughnut = false;
  bool _explode = false;
  static const _primary = Color(0xFF2E7D32);

  final _rng = Random();

  List<_PieData> _data = const [
    _PieData('Android', 42, Color(0xFF43A047)),
    _PieData('iOS', 28, Color(0xFF1976D2)),
    _PieData('Web', 18, Color(0xFFE53935)),
    _PieData('Desktop', 12, Color(0xFFFF8F00)),
  ];

  void _refreshData() {
    final raw = List.generate(4, (_) => 10 + _rng.nextInt(40).toDouble());
    final total = raw.reduce((a, b) => a + b);
    setState(() {
      _data = [
        _PieData('Android', raw[0] / total * 100, const Color(0xFF43A047)),
        _PieData('iOS', raw[1] / total * 100, const Color(0xFF1976D2)),
        _PieData('Web', raw[2] / total * 100, const Color(0xFFE53935)),
        _PieData('Desktop', raw[3] / total * 100, const Color(0xFFFF8F00)),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.pie_chart_rounded,
          color: _primary,
          text: 'SfCircularChart — Syncfusion\nPieSeries ↔ DoughnutSeries chỉ bằng 1 switch. Explode animation tích hợp.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Thị phần nền tảng di động 2024',
          trailing: IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: _primary,
            tooltip: 'Thay đổi dữ liệu',
            onPressed: _refreshData,
          ),
          child: SfCircularChart(
            legend: const Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: TextStyle(fontSize: 12),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              color: const Color(0xFF1B5E20),
              textStyle: const TextStyle(color: Colors.white, fontSize: 11),
            ),
            series: [
              if (_doughnut)
                DoughnutSeries<_PieData, String>(
                  dataSource: _data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                  innerRadius: '55%',
                  explode: _explode,
                  explodeIndex: 0,
                  explodeOffset: '8%',
                  animationDuration: 800,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 11),
                  ),
                )
              else
                PieSeries<_PieData, String>(
                  dataSource: _data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                  explode: _explode,
                  explodeIndex: 0,
                  explodeOffset: '8%',
                  animationDuration: 800,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(fontSize: 11),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ControlPanel(children: [
          ControlSwitch(
            label: 'Doughnut mode',
            subtitle: 'PieSeries → DoughnutSeries (innerRadius: 55%)',
            value: _doughnut,
            activeColor: _primary,
            onChanged: (v) => setState(() => _doughnut = v),
          ),
          ControlSwitch(
            label: 'Explode lát đầu tiên',
            subtitle: 'explode: true, explodeIndex: 0',
            value: _explode,
            activeColor: _primary,
            onChanged: (v) => setState(() => _explode = v),
          ),
        ]),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Animation — Syncfusion',
          code:
              '// Entrance: tự động khi widget xuất hiện\n'
              'PieSeries(\n'
              '  animationDuration: 800,\n'
              '  ...\n'
              ')\n\n'
              '// Data change: setState → Syncfusion tự re-animate\n'
              'setState(() => _data = newData);',
        ),
      ],
    );
  }
}

class _PieData {
  final String label;
  final double value;
  final Color color;
  const _PieData(this.label, this.value, this.color);
}
