import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/chart_card.dart';

class FlLineChartDemo extends StatefulWidget {
  const FlLineChartDemo({super.key});

  @override
  State<FlLineChartDemo> createState() => _FlLineChartDemoState();
}

class _FlLineChartDemoState extends State<FlLineChartDemo> {
  bool _showArea = false;
  bool _curved = true;
  bool _loaded = false;

  static const _blue = Color(0xFF1976D2);
  static const _green = Color(0xFF43A047);

  final _rng = Random();

  List<FlSpot> _revenue = [
    FlSpot(0, 1.2), FlSpot(1, 1.8), FlSpot(2, 2.6),
    FlSpot(3, 2.1), FlSpot(4, 3.2), FlSpot(5, 3.0), FlSpot(6, 3.8),
  ];

  List<FlSpot> _profit = [
    FlSpot(0, 0.4), FlSpot(1, 0.6), FlSpot(2, 0.9),
    FlSpot(3, 0.7), FlSpot(4, 1.1), FlSpot(5, 1.0), FlSpot(6, 1.4),
  ];

  final List<String> _months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

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
      _revenue = List.generate(7, (i) =>
          FlSpot(i.toDouble(), 1.0 + _rng.nextDouble() * 3.5));
      _profit = List.generate(7, (i) =>
          FlSpot(i.toDouble(), 0.3 + _rng.nextDouble() * 1.2));
    });
  }

  List<FlSpot> _displaySpots(List<FlSpot> spots) => _loaded
      ? spots
      : spots.map((s) => FlSpot(s.x, 0)).toList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.show_chart_rounded,
          color: _blue,
          text: 'LineChart — fl_chart\nCấu hình qua LineChartData + LineChartBarData. Hỗ trợ multi-series, tooltip, area fill.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Doanh thu & Lợi nhuận (tỷ đồng)',
          trailing: Row(
            children: [
              _legendDot(_blue, 'Doanh thu'),
              const SizedBox(width: 12),
              _legendDot(_green, 'Lợi nhuận'),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                color: _blue,
                tooltip: 'Thay đổi dữ liệu',
                onPressed: _refreshData,
              ),
            ],
          ),
          child: SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0, maxX: 6, minY: 0, maxY: 4.5,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.grey.withValues(alpha: 0.12),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toStringAsFixed(0)}B',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final i = v.toInt();
                        if (i < 0 || i >= _months.length) return const SizedBox();
                        return Text(_months[i],
                            style: const TextStyle(fontSize: 10, color: Colors.grey));
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1A237E),
                    getTooltipItems: (spots) => spots.map((s) {
                      final label = s.barIndex == 0 ? 'Doanh thu' : 'Lợi nhuận';
                      return LineTooltipItem(
                        '$label\n${s.y.toStringAsFixed(1)}B',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                lineBarsData: [
                  _barData(_displaySpots(_revenue), _blue),
                  _barData(_displaySpots(_profit), _green),
                ],
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            ),
          ),
        ),
        const SizedBox(height: 14),
        ControlPanel(children: [
          ControlSwitch(
            label: 'Đường cong',
            subtitle: 'isCurved: true',
            value: _curved,
            activeColor: _blue,
            onChanged: (v) => setState(() => _curved = v),
          ),
          ControlSwitch(
            label: 'Vùng đổ bóng',
            subtitle: 'BarAreaData(show: true)',
            value: _showArea,
            activeColor: _blue,
            onChanged: (v) => setState(() => _showArea = v),
          ),
        ]),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Entrance & swap animation',
          code:
              'LineChart(\n'
              '  data,\n'
              '  duration: Duration(milliseconds: 600),\n'
              '  curve: Curves.easeInOut,\n'
              ')\n'
              '// Entrance: khởi tạo spots y = 0, sau postFrameCallback\n'
              '// setState với giá trị thật → fl_chart tự animate',
        ),
      ],
    );
  }

  LineChartBarData _barData(List<FlSpot> spots, Color color) =>
      LineChartBarData(
        spots: spots,
        isCurved: _curved,
        color: color,
        barWidth: 2.5,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, bar, index) =>
              FlDotCirclePainter(
                radius: 3.5,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: color,
              ),
        ),
        belowBarData: BarAreaData(
          show: _showArea,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
          ),
        ),
      );

  Widget _legendDot(Color color, String label) => Row(
        children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}
