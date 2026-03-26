import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../widgets/chart_card.dart';

class SfLineChartDemo extends StatefulWidget {
  const SfLineChartDemo({super.key});

  @override
  State<SfLineChartDemo> createState() => _SfLineChartDemoState();
}

class _SfLineChartDemoState extends State<SfLineChartDemo> {
  bool _enableZoom = false;
  bool _enableTrackball = true;
  static const _primary = Color(0xFF2E7D32);

  final _rng = Random();

  List<_SalesData> _revenue = [
    _SalesData('T1', 1.2), _SalesData('T2', 1.8), _SalesData('T3', 2.6),
    _SalesData('T4', 2.1), _SalesData('T5', 3.2), _SalesData('T6', 3.0),
    _SalesData('T7', 3.8),
  ];

  List<_SalesData> _profit = [
    _SalesData('T1', 0.4), _SalesData('T2', 0.6), _SalesData('T3', 0.9),
    _SalesData('T4', 0.7), _SalesData('T5', 1.1), _SalesData('T6', 1.0),
    _SalesData('T7', 1.4),
  ];

  // ── Real-time ──────────────────────────────────────────────
  ChartSeriesController? _rtController;
  final List<_RealtimePoint> _rtData = [];
  Timer? _timer;
  bool _running = false;
  int _tick = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _refreshData() {
    final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
    setState(() {
      _revenue = List.generate(7, (i) =>
          _SalesData(months[i], 1.0 + _rng.nextDouble() * 3.5));
      _profit = List.generate(7, (i) =>
          _SalesData(months[i], 0.3 + _rng.nextDouble() * 1.2));
    });
  }

  void _toggleRealtime() {
    if (_running) {
      _timer?.cancel();
      setState(() => _running = false);
    } else {
      if (_rtData.isEmpty) {
        for (int i = 0; i < 10; i++) {
          _rtData.add(_RealtimePoint(i, _rng.nextDouble() * 4 + 1));
        }
        _tick = 9;
      }
      setState(() => _running = true);
      _timer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        _tick++;
        _rtData.add(_RealtimePoint(_tick, _rng.nextDouble() * 4 + 1));
        if (_rtData.length > 20) {
          _rtData.removeAt(0);
          _rtController?.updateDataSource(
            addedDataIndexes: [_rtData.length - 1],
            removedDataIndexes: [0],
          );
        } else {
          _rtController?.updateDataSource(
            addedDataIndexes: [_rtData.length - 1],
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const InfoBanner(
          icon: Icons.show_chart_rounded,
          color: _primary,
          text: 'SfCartesianChart (SplineSeries) — Syncfusion\nTrackball, zoom/pan tích hợp sẵn. Bật switch để thử.',
        ),
        const SizedBox(height: 14),

        // ── Spline chart ──────────────────────────────────────
        ChartCard(
          title: 'Doanh thu & Lợi nhuận (tỷ đồng)',
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
            primaryYAxis: const NumericAxis(
              minimum: 0,
              maximum: 4.5,
              interval: 1,
              labelFormat: '{value}B',
              labelStyle: TextStyle(fontSize: 10, color: Colors.grey),
              majorGridLines: MajorGridLines(width: 1, color: Color(0xFFEEEEEE)),
              axisLine: AxisLine(width: 0),
            ),
            zoomPanBehavior: _enableZoom
                ? ZoomPanBehavior(
                    enablePinching: true,
                    enableDoubleTapZooming: true,
                    enablePanning: true,
                  )
                : null,
            trackballBehavior: _enableTrackball
                ? TrackballBehavior(
                    enable: true,
                    activationMode: ActivationMode.singleTap,
                    lineColor: _primary.withValues(alpha: 0.4),
                    tooltipSettings: const InteractiveTooltip(
                      color: Color(0xFF1B5E20),
                      textStyle: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  )
                : null,
            series: <CartesianSeries>[
              SplineSeries<_SalesData, String>(
                name: 'Doanh thu',
                dataSource: _revenue,
                xValueMapper: (d, _) => d.month,
                yValueMapper: (d, _) => d.value,
                color: _primary,
                width: 2.5,
                animationDuration: 800,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 7,
                  height: 7,
                  borderColor: Colors.white,
                  borderWidth: 2,
                ),
              ),
              SplineAreaSeries<_SalesData, String>(
                name: 'Lợi nhuận',
                dataSource: _profit,
                xValueMapper: (d, _) => d.month,
                yValueMapper: (d, _) => d.value,
                color: const Color(0xFF66BB6A).withValues(alpha: 0.25),
                borderColor: const Color(0xFF66BB6A),
                borderWidth: 2.5,
                animationDuration: 800,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 7,
                  height: 7,
                  color: Color(0xFF66BB6A),
                  borderColor: Colors.white,
                  borderWidth: 2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        ControlPanel(children: [
          ControlSwitch(
            label: 'Zoom & Pan',
            subtitle: 'ZoomPanBehavior — pinch, double-tap',
            value: _enableZoom,
            activeColor: _primary,
            onChanged: (v) => setState(() => _enableZoom = v),
          ),
          ControlSwitch(
            label: 'Trackball',
            subtitle: 'TrackballBehavior — chạm & kéo trên biểu đồ',
            value: _enableTrackball,
            activeColor: _primary,
            onChanged: (v) => setState(() => _enableTrackball = v),
          ),
        ]),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Animation — Syncfusion',
          code:
              '// Entrance: tự động khi widget xuất hiện\n'
              'SplineSeries(\n'
              '  animationDuration: 800, // ms\n'
              '  ...\n'
              ')\n\n'
              '// Data change: setState → Syncfusion tự re-animate\n'
              'setState(() => _data = newData);',
        ),

        // ── Real-time update ──────────────────────────────────
        const SizedBox(height: 24),
        const InfoBanner(
          icon: Icons.timeline_rounded,
          color: _primary,
          text: 'Real-time update — Syncfusion\nChartSeriesController.updateDataSource() cập nhật từng điểm mà không rebuild toàn bộ chart.',
        ),
        const SizedBox(height: 14),
        ChartCard(
          title: 'Dữ liệu thời gian thực',
          trailing: TextButton.icon(
            onPressed: _toggleRealtime,
            icon: Icon(
              _running ? Icons.stop_rounded : Icons.play_arrow_rounded,
              size: 18,
            ),
            label: Text(_running ? 'Dừng' : 'Bắt đầu'),
            style: TextButton.styleFrom(
              foregroundColor: _running ? Colors.red : _primary,
            ),
          ),
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: const NumericAxis(
              isVisible: false,
              majorGridLines: MajorGridLines(width: 0),
            ),
            primaryYAxis: const NumericAxis(
              minimum: 0,
              maximum: 6,
              interval: 1,
              labelFormat: '{value}B',
              labelStyle: TextStyle(fontSize: 10, color: Colors.grey),
              majorGridLines: MajorGridLines(width: 1, color: Color(0xFFEEEEEE)),
              axisLine: AxisLine(width: 0),
            ),
            series: <CartesianSeries>[
              LineSeries<_RealtimePoint, int>(
                onRendererCreated: (c) => _rtController = c,
                dataSource: _rtData,
                xValueMapper: (d, _) => d.x,
                yValueMapper: (d, _) => d.y,
                color: _primary,
                width: 2,
                animationDuration: 0,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  shape: DataMarkerType.circle,
                  width: 6,
                  height: 6,
                  color: Color(0xFF2E7D32),
                  borderColor: Colors.white,
                  borderWidth: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const CodeSnippet(
          title: 'Real-time — updateDataSource',
          code:
              'ChartSeriesController? _controller;\n\n'
              'LineSeries(\n'
              '  onRendererCreated: (c) => _controller = c,\n'
              '  animationDuration: 0,\n'
              '  ...\n'
              ')\n\n'
              '_data.add(newPoint);\n'
              '_data.removeAt(0);\n'
              '_controller?.updateDataSource(\n'
              '  addedDataIndexes: [_data.length - 1],\n'
              '  removedDataIndexes: [0],\n'
              ')',
        ),
      ],
    );
  }
}

class _SalesData {
  final String month;
  final double value;
  _SalesData(this.month, this.value);
}

class _RealtimePoint {
  final int x;
  final double y;
  _RealtimePoint(this.x, this.y);
}
