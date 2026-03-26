import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/chart_card.dart';

class FlBarChartDemo extends StatefulWidget {
  const FlBarChartDemo({super.key});

  @override
  State<FlBarChartDemo> createState() => _FlBarChartDemoState();
}

class _FlBarChartDemoState extends State<FlBarChartDemo> {
  int _touchedIndex = -1;
  bool _loaded = false;
  static const _primary = Color(0xFF1976D2);

  final _rng = Random();

  List<_Item> _data = [
    _Item('Flutter', 4200, Color(0xFF1976D2)),
    _Item('React\nNative', 3800, Color(0xFF43A047)),
    _Item('Kotlin', 3100, Color(0xFFE53935)),
    _Item('Swift', 2900, Color(0xFFFF8F00)),
    _Item('Xamarin', 1800, Color(0xFF8E24AA)),
  ];

  @override
  void initState() {
    super.initState();
    // Entrance animation: bắt đầu từ 0, sau frame đầu animate lên giá trị thật
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _loaded = true);
    });
  }

  void _refreshData() {
    setState(() {
      _touchedIndex = -1;
      _data = [
        _Item('Flutter', 2000 + _rng.nextInt(3000).toDouble(), const Color(0xFF1976D2)),
        _Item('React\nNative', 2000 + _rng.nextInt(3000).toDouble(), const Color(0xFF43A047)),
        _Item('Kotlin', 1500 + _rng.nextInt(2500).toDouble(), const Color(0xFFE53935)),
        _Item('Swift', 1500 + _rng.nextInt(2500).toDouble(), const Color(0xFFFF8F00)),
        _Item('Xamarin', 800 + _rng.nextInt(1500).toDouble(), const Color(0xFF8E24AA)),
      ];
    });
  }

  double get _maxY =>
      _data.map((e) => e.value).reduce(max) * 1.25;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.bar_chart_rounded,
          color: _primary,
          text: 'BarChart — fl_chart\nChạm vào cột để xem chi tiết. touchCallback trả về index và tọa độ.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Job tuyển dụng theo framework',
          trailing: IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            color: _primary,
            tooltip: 'Thay đổi dữ liệu',
            onPressed: _refreshData,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    maxY: _maxY,
                    barTouchData: BarTouchData(
                      touchCallback: (event, response) {
                        if (response?.spot != null &&
                            event is! FlTapUpEvent &&
                            event is! FlPanEndEvent) {
                          setState(() => _touchedIndex =
                              response!.spot!.touchedBarGroupIndex);
                        } else {
                          setState(() => _touchedIndex = -1);
                        }
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (_) => const Color(0xFF1A237E),
                        getTooltipItem: (group, p1, rod, p2) => BarTooltipItem(
                          '${_data[group.x].name.replaceAll('\n', ' ')}\n${rod.toY.toInt()} jobs',
                          const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (v, _) {
                            final i = v.toInt();
                            if (i < 0 || i >= _data.length) return const SizedBox();
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _data[i].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: i == _touchedIndex
                                      ? _data[i].color
                                      : Colors.grey,
                                  fontWeight: i == _touchedIndex
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (v, _) => Text(
                            '${(v / 1000).toStringAsFixed(0)}k',
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (v) => FlLine(
                        color: Colors.grey.withValues(alpha: 0.12),
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(_data.length, (i) {
                      final touched = i == _touchedIndex;
                      final value = _loaded
                          ? (touched ? _data[i].value * 1.06 : _data[i].value)
                          : 0.0;
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: value,
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: touched
                                  ? [_data[i].color, _data[i].color.withValues(alpha: 0.6)]
                                  : [
                                      _data[i].color.withValues(alpha: 0.5),
                                      _data[i].color.withValues(alpha: 0.85),
                                    ],
                            ),
                            width: 36,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                        ],
                      );
                    }),
                  ),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                ),
              ),
              if (_touchedIndex >= 0) ...[
                const SizedBox(height: 12),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _data[_touchedIndex].color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _data[_touchedIndex].color.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app_rounded,
                          color: _data[_touchedIndex].color, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '${_data[_touchedIndex].name.replaceAll('\n', ' ')}: ${_data[_touchedIndex].value.toInt()} job listings',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _data[_touchedIndex].color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Entrance & swap animation',
          code:
              'BarChart(\n'
              '  data,\n'
              '  duration: Duration(milliseconds: 600),\n'
              '  curve: Curves.easeInOut,\n'
              ')\n'
              '// Entrance: khởi tạo toY = 0, sau postFrameCallback\n'
              '// setState với giá trị thật → fl_chart tự animate',
        ),
      ],
    );
  }
}

class _Item {
  final String name;
  final double value;
  final Color color;
  const _Item(this.name, this.value, this.color);
}
