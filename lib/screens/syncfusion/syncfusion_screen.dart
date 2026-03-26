import 'package:flutter/material.dart';
import 'sf_line_chart.dart';
import 'sf_bar_chart.dart';
import 'sf_pie_chart.dart';

class SyncfusionScreen extends StatefulWidget {
  const SyncfusionScreen({super.key});

  @override
  State<SyncfusionScreen> createState() => _SyncfusionScreenState();
}

class _SyncfusionScreenState extends State<SyncfusionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF388E3C),
        foregroundColor: Colors.white,
        title: const Text(
          'syncfusion_flutter_charts Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.show_chart), text: 'Line'),
            Tab(icon: Icon(Icons.bar_chart), text: 'Bar'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Circular'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SfLineChartDemo(),
          SfBarChartDemo(),
          SfPieChartDemo(),
        ],
      ),
    );
  }
}
