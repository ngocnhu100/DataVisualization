import 'package:flutter/material.dart';
import 'fl_line_chart.dart';
import 'fl_bar_chart.dart';
import 'fl_pie_chart.dart';

class FlChartScreen extends StatefulWidget {
  const FlChartScreen({super.key});

  @override
  State<FlChartScreen> createState() => _FlChartScreenState();
}

class _FlChartScreenState extends State<FlChartScreen>
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
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: const Text(
          'fl_chart Demo',
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
            Tab(icon: Icon(Icons.pie_chart), text: 'Pie'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FlLineChartDemo(),
          FlBarChartDemo(),
          FlPieChartDemo(),
        ],
      ),
    );
  }
}
