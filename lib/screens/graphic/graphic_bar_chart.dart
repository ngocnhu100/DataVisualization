import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import '../../widgets/chart_card.dart';

class GraphicBarChartDemo extends StatefulWidget {
  const GraphicBarChartDemo({super.key});

  @override
  State<GraphicBarChartDemo> createState() => _GraphicBarChartDemoState();
}

class _GraphicBarChartDemoState extends State<GraphicBarChartDemo>
    with SingleTickerProviderStateMixin {
  static const _primary = Color(0xFF6A1B9A);
  final _rng = Random();

  late AnimationController _entranceCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  final _dataStream = StreamController<ChangeDataEvent<Map>>();

  List<Map> _data = [
    {'genre': 'Flutter', 'sold': 4200},
    {'genre': 'React\nNative', 'sold': 3800},
    {'genre': 'Kotlin', 'sold': 3100},
    {'genre': 'Swift', 'sold': 2900},
    {'genre': 'Xamarin', 'sold': 1800},
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
    final frameworks = ['Flutter', 'React\nNative', 'Kotlin', 'Swift', 'Xamarin'];
    _data = frameworks.map((f) => {
      'genre': f,
      'sold': 1000 + _rng.nextInt(4000),
    }).toList();
    _dataStream.add(ChangeDataEvent(_data));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.bar_chart_rounded,
          color: _primary,
          text: 'IntervalMark — graphic\nChạm vào cột để xem tooltip. Kéo để chọn vùng (IntervalSelection).',
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
                    'genre': Variable(
                      accessor: (Map map) => map['genre'] as String,
                    ),
                    'sold': Variable(
                      accessor: (Map map) => map['sold'] as num,
                      scale: LinearScale(min: 0, max: 5500),
                    ),
                  },
                  marks: [
                    IntervalMark(
                      color: ColorEncode(
                        variable: 'genre',
                        values: [
                          const Color(0xFF6A1B9A),
                          const Color(0xFF7B1FA2),
                          const Color(0xFF8E24AA),
                          const Color(0xFFAB47BC),
                          const Color(0xFFCE93D8),
                        ],
                      ),
                      elevation: ElevationEncode(value: 2),
                      label: LabelEncode(
                        encoder: (tuple) => Label(
                          '${(tuple['sold'] as num).toInt()}',
                          LabelStyle(
                            textStyle: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  axes: [
                    Defaults.horizontalAxis,
                    Defaults.verticalAxis,
                  ],
                  selections: {
                    'tap': PointSelection(
                      on: {GestureType.tap},
                      dim: Dim.x,
                    ),
                    'drag': IntervalSelection(
                      color: _primary.withValues(alpha: 0.08),
                    ),
                  },
                  tooltip: TooltipGuide(
                    backgroundColor: const Color(0xFF4A148C),
                    elevation: 4,
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    variables: ['genre', 'sold'],
                  ),
                  crosshair: CrosshairGuide(
                    followPointer: [false, true],
                    styles: [
                      PaintStyle(),
                      PaintStyle(
                        strokeColor: _primary.withValues(alpha: 0.4),
                        strokeWidth: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Interaction — tooltip & selection',
          code:
              'Chart(\n'
              '  selections: {\n'
              '    "tap": PointSelection(\n'
              '      on: {GestureType.tap}, dim: Dim.x),\n'
              '    "drag": IntervalSelection(),\n'
              '  },\n'
              '  tooltip: TooltipGuide(\n'
              '    backgroundColor: Color(0xFF4A148C),\n'
              '    textStyle: TextStyle(color: Colors.white),\n'
              '  ),\n'
              '  crosshair: CrosshairGuide(\n'
              '    followPointer: [false, true],\n'
              '  ),\n'
              ')',
        ),
      ],
    );
  }
}
