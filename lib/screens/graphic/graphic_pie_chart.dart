import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../../widgets/chart_card.dart';

class GraphicPieChartDemo extends StatefulWidget {
  const GraphicPieChartDemo({super.key});

  @override
  State<GraphicPieChartDemo> createState() => _GraphicPieChartDemoState();
}

class _GraphicPieChartDemoState extends State<GraphicPieChartDemo>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF6A1B9A);
  final _rng = Random();

  late AnimationController _entranceCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _dataStream = StreamController<ChangeDataEvent<Map>>();

  static const _colors = [
    Color(0xFF43A047),
    Color(0xFF1976D2),
    Color(0xFFE53935),
    Color(0xFFFF8F00),
  ];

  static const _platforms = ['Android', 'iOS', 'Web', 'Desktop'];

  List<Map> _data = [
    {'platform': 'Android', 'share': 42},
    {'platform': 'iOS', 'share': 28},
    {'platform': 'Web', 'share': 18},
    {'platform': 'Desktop', 'share': 12},
  ];

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut));
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _dataStream.close();
    super.dispose();
  }

  void _refreshData() {
    final raw = List.generate(4, (_) => 10 + _rng.nextInt(40));
    final total = raw.reduce((a, b) => a + b);
    setState(() {
      _data = List.generate(4, (i) => {
        'platform': _platforms[i],
        'share': (raw[i] / total * 100).round(),
      });
    });
    _dataStream.add(ChangeDataEvent(_data));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.pie_chart_rounded,
          color: _primary,
          text: 'IntervalMark + PolarCoord — graphic\nKhông có PieChart. Chỉ cần thêm coord: PolarCoord() vào IntervalMark.',
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
              FadeTransition(
                opacity: _fade,
                child: SlideTransition(
                  position: _slide,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Chart(
                      data: _data,
                      changeDataStream: _dataStream,
                      variables: {
                        'platform': Variable(
                          accessor: (Map map) => map['platform'] as String,
                        ),
                        'share': Variable(
                          accessor: (Map map) => map['share'] as num,
                          scale: LinearScale(min: 0),
                        ),
                      },
                      marks: [
                        IntervalMark(
                          position: Varset('platform') * Varset('share'),
                          color: ColorEncode(
                            variable: 'platform',
                            values: _colors,
                          ),
                          elevation: ElevationEncode(value: 3),
                        ),
                      ],
                      coord: PolarCoord(transposed: true, dimCount: 1),
                      selections: {
                        'tap': PointSelection(
                          on: {GestureType.tap},
                        ),
                      },
                      tooltip: TooltipGuide(
                        backgroundColor: const Color(0xFF4A148C),
                        elevation: 4,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        variables: ['platform', 'share'],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: List.generate(_data.length, (i) => _chip(
                  _platforms[i],
                  _data[i]['share'] as int,
                  _colors[i],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Fix tròn + Interaction',
          code:
              '// Fix hình tròn: container phải vuông\n'
              'AspectRatio(\n'
              '  aspectRatio: 1,\n'
              '  child: Chart(\n'
              '    coord: PolarCoord(\n'
              '      transposed: true, dimCount: 1),\n'
              '    selections: {\n'
              '      "tap": PointSelection(\n'
              '        on: {GestureType.tap}),\n'
              '    },\n'
              '    tooltip: TooltipGuide(...),\n'
              '  ),\n'
              ')',
        ),
      ],
    );
  }

  static Widget _chip(String name, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            '$name $value%',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
