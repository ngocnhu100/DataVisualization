import 'package:flutter/material.dart';
import 'graphic_bar_chart.dart';
import 'graphic_line_chart.dart';
import 'graphic_pie_chart.dart';

class GraphicScreen extends StatefulWidget {
  const GraphicScreen({super.key});

  @override
  State<GraphicScreen> createState() => _GraphicScreenState();
}

class _GraphicScreenState extends State<GraphicScreen>
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
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        title: const Text(
          'graphic Demo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.bar_chart), text: 'Bar'),
            Tab(icon: Icon(Icons.show_chart), text: 'Line'),
            Tab(icon: Icon(Icons.pie_chart), text: 'Interval'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          GraphicBarChartDemo(),
          GraphicLineChartDemo(),
          GraphicPieChartDemo(),
        ],
      ),
    );
  }
}
