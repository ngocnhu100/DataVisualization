import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../../widgets/chart_card.dart';

class GraphicLineChartDemo extends StatefulWidget {
  const GraphicLineChartDemo({super.key});

  @override
  State<GraphicLineChartDemo> createState() => _GraphicLineChartDemoState();
}

class _GraphicLineChartDemoState extends State<GraphicLineChartDemo>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF6A1B9A);
  final _rng = Random();

  late AnimationController _entranceCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _dataStream = StreamController<ChangeDataEvent<Map>>();

  List<Map> _data = [
    {'month': 'T1', 'series': 'Doanh thu', 'value': 1.2},
    {'month': 'T2', 'series': 'Doanh thu', 'value': 1.8},
    {'month': 'T3', 'series': 'Doanh thu', 'value': 2.6},
    {'month': 'T4', 'series': 'Doanh thu', 'value': 2.1},
    {'month': 'T5', 'series': 'Doanh thu', 'value': 3.2},
    {'month': 'T6', 'series': 'Doanh thu', 'value': 3.0},
    {'month': 'T7', 'series': 'Doanh thu', 'value': 3.8},
    {'month': 'T1', 'series': 'Lợi nhuận', 'value': 0.4},
    {'month': 'T2', 'series': 'Lợi nhuận', 'value': 0.6},
    {'month': 'T3', 'series': 'Lợi nhuận', 'value': 0.9},
    {'month': 'T4', 'series': 'Lợi nhuận', 'value': 0.7},
    {'month': 'T5', 'series': 'Lợi nhuận', 'value': 1.1},
    {'month': 'T6', 'series': 'Lợi nhuận', 'value': 1.0},
    {'month': 'T7', 'series': 'Lợi nhuận', 'value': 1.4},
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
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    _data = [
      ...months.map((m) => {
        'month': m,
        'series': 'Doanh thu',
        'value': double.parse((1.0 + _rng.nextDouble() * 3.5).toStringAsFixed(1)),
      }),
      ...months.map((m) => {
        'month': m,
        'series': 'Lợi nhuận',
        'value': double.parse((0.3 + _rng.nextDouble() * 1.2).toStringAsFixed(1)),
      }),
    ];
    _dataStream.add(ChangeDataEvent(_data));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.show_chart_rounded,
          color: _primary,
          text: 'LineMark + PointMark — graphic\nChạm để xem tooltip. Crosshair theo con trỏ. Kéo để chọn vùng.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Doanh thu & Lợi nhuận (tỷ đồng)',
          trailing: Row(
            children: [
              _dot(const Color(0xFF6A1B9A), 'Doanh thu'),
              const SizedBox(width: 12),
              _dot(const Color(0xFF26A69A), 'Lợi nhuận'),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                color: _primary,
                tooltip: 'Thay đổi dữ liệu',
                onPressed: _refreshData,
              ),
            ],
          ),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: SizedBox(
                height: 240,
                child: Chart(
                  data: _data,
                  changeDataStream: _dataStream,
                  variables: {
                    'month': Variable(
                      accessor: (Map map) => map['month'] as String,
                    ),
                    'value': Variable(
                      accessor: (Map map) => map['value'] as num,
                      scale: LinearScale(min: 0, max: 4.5),
                    ),
                    'series': Variable(
                      accessor: (Map map) => map['series'] as String,
                    ),
                  },
                  marks: [
                    LineMark(
                      position: Varset('month') * Varset('value'),
                      color: ColorEncode(
                        variable: 'series',
                        values: [
                          const Color(0xFF6A1B9A),
                          const Color(0xFF26A69A),
                        ],
                      ),
                      size: SizeEncode(value: 2.5),
                    ),
                    PointMark(
                      position: Varset('month') * Varset('value'),
                      color: ColorEncode(
                        variable: 'series',
                        values: [
                          const Color(0xFF6A1B9A),
                          const Color(0xFF26A69A),
                        ],
                      ),
                      size: SizeEncode(value: 4.5),
                    ),
                  ],
                  axes: [
                    Defaults.horizontalAxis,
                    Defaults.verticalAxis,
                  ],
                  selections: {
                    'tap': PointSelection(
                      on: {GestureType.tap},
                      nearest: true,
                      dim: Dim.x,
                    ),
                  },
                  tooltip: TooltipGuide(
                    backgroundColor: const Color(0xFF4A148C),
                    elevation: 4,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    variables: ['month', 'series', 'value'],
                  ),
                  crosshair: CrosshairGuide(
                    followPointer: [true, false],
                    styles: [
                      PaintStyle(
                        strokeColor: _primary.withValues(alpha: 0.4),
                        strokeWidth: 1,
                      ),
                      PaintStyle(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Interaction — tooltip & crosshair',
          code:
              'Chart(\n'
              '  selections: {\n'
              '    "tap": PointSelection(\n'
              '      on: {GestureType.tap},\n'
              '      nearest: true, dim: Dim.x),\n'
              '  },\n'
              '  tooltip: TooltipGuide(\n'
              '    backgroundColor: Color(0xFF4A148C),\n'
              '    variables: ["month", "series", "value"],\n'
              '  ),\n'
              '  crosshair: CrosshairGuide(\n'
              '    followPointer: [true, false],\n'
              '  ),\n'
              ')',
        ),
      ],
    );
  }

  static Widget _dot(Color color, String label) => Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      );
}
