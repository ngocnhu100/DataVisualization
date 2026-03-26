import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../widgets/chart_card.dart';

class FlPieChartDemo extends StatefulWidget {
  const FlPieChartDemo({super.key});

  @override
  State<FlPieChartDemo> createState() => _FlPieChartDemoState();
}

class _FlPieChartDemoState extends State<FlPieChartDemo> {
  int _touchedIndex = -1;
  bool _donut = false;
  bool _loaded = false;
  static const _primary = Color(0xFF1976D2);

  final _rng = Random();

  List<_Slice> _slices = [
    _Slice('Android', 42, Color(0xFF43A047)),
    _Slice('iOS', 28, Color(0xFF1976D2)),
    _Slice('Web', 18, Color(0xFFE53935)),
    _Slice('Desktop', 12, Color(0xFFFF8F00)),
  ];

  @override
  void initState() {
    super.initState();
    // Entrance animation: bắt đầu từ phần bằng nhau, sau frame đầu animate sang giá trị thật
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _loaded = true);
    });
  }

  void _refreshData() {
    // Tạo 4 giá trị ngẫu nhiên tổng = 100
    final raw = List.generate(4, (_) => 10 + _rng.nextInt(40).toDouble());
    final total = raw.reduce((a, b) => a + b);
    final percents = raw.map((v) => (v / total * 100)).toList();

    setState(() {
      _touchedIndex = -1;
      _slices = [
        _Slice('Android', percents[0], const Color(0xFF43A047)),
        _Slice('iOS', percents[1], const Color(0xFF1976D2)),
        _Slice('Web', percents[2], const Color(0xFFE53935)),
        _Slice('Desktop', percents[3], const Color(0xFFFF8F00)),
      ];
    });
  }

  double _sectionValue(_Slice s) => _loaded ? s.percent : 25;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.pie_chart_rounded,
          color: _primary,
          text: 'PieChart — fl_chart\nChạm vào lát để phóng to. Toggle centerSpaceRadius để chuyển Pie ↔ Donut.',
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
          child: Column(
            children: [
              SizedBox(
                height: _donut ? 250 : 220,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            if (response?.touchedSection != null &&
                                event is! FlTapUpEvent) {
                              setState(() => _touchedIndex =
                                  response!.touchedSection!.touchedSectionIndex);
                            } else {
                              setState(() => _touchedIndex = -1);
                            }
                          },
                        ),
                        centerSpaceRadius: _donut ? 62 : 0,
                        sectionsSpace: 2,
                        startDegreeOffset: -90,
                        sections: List.generate(_slices.length, (i) {
                          final touched = i == _touchedIndex;
                          final s = _slices[i];
                          return PieChartSectionData(
                            color: s.color,
                            value: _sectionValue(s),
                            radius: _donut
                                ? (touched ? 72 : 58)
                                : (touched ? 100 : 84),
                            title: touched ? '${s.percent.toStringAsFixed(1)}%' : '',
                            titleStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            badgeWidget: (_donut || touched)
                                ? null
                                : _badge(s),
                            badgePositionPercentageOffset: 0.92,
                          );
                        }),
                      ),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    ),
                    if (_donut && _touchedIndex >= 0)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_slices[_touchedIndex].percent.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: _slices[_touchedIndex].color,
                            ),
                          ),
                          Text(
                            _slices[_touchedIndex].name,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _slices.map((s) => _legendChip(s)).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ControlPanel(children: [
          ControlSwitch(
            label: 'Donut mode',
            subtitle: 'centerSpaceRadius: 62',
            value: _donut,
            activeColor: _primary,
            onChanged: (v) => setState(() {
              _donut = v;
              _touchedIndex = -1;
            }),
          ),
        ]),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Entrance & swap animation',
          code:
              'PieChart(\n'
              '  data,\n'
              '  duration: Duration(milliseconds: 600),\n'
              '  curve: Curves.easeInOut,\n'
              ')\n'
              '// Entrance: khởi tạo value = 25 (đều nhau), sau postFrameCallback\n'
              '// setState với giá trị thật → fl_chart tự animate',
        ),
      ],
    );
  }

  Widget _badge(_Slice s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: s.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${s.percent.toStringAsFixed(1)}%',
        style: const TextStyle(
            fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _legendChip(_Slice s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: s.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: s.color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8, height: 8,
            decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(s.name,
              style: TextStyle(
                  fontSize: 11,
                  color: s.color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Slice {
  final String name;
  final double percent;
  final Color color;
  const _Slice(this.name, this.percent, this.color);
}
