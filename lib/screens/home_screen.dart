import 'package:flutter/material.dart';
import 'fl_chart/fl_chart_screen.dart';
import 'syncfusion/syncfusion_screen.dart';
import 'graphic/graphic_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          _buildHeroHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionLabel('Chọn thư viện để demo'),
                const SizedBox(height: 16),
                _LibraryCard(
                  title: 'fl_chart',
                  subtitle: 'Phổ biến · Mã nguồn mở',
                  description:
                      'API đơn giản, dễ tích hợp. Hỗ trợ Line, Bar, Pie, Scatter, Radar với animation tích hợp sẵn.',
                  icon: Icons.show_chart_rounded,
                  gradientColors: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
                  badgeLabel: 'MIT License',
                  badgeColor: const Color(0xFF1565C0),
                  stats: const [
                    _Stat('30k+', 'pub likes'),
                    _Stat('MIT', 'License'),
                    _Stat('5', 'chart types'),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    _fadeRoute(const FlChartScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _LibraryCard(
                  title: 'syncfusion_flutter_charts',
                  subtitle: 'Enterprise · Thương mại',
                  description:
                      'Hơn 30 loại biểu đồ, hiệu năng cao, hỗ trợ zoom, pan, trackball và dữ liệu thời gian thực.',
                  icon: Icons.bar_chart_rounded,
                  gradientColors: [const Color(0xFF1B5E20), const Color(0xFF66BB6A)],
                  badgeLabel: 'Commercial',
                  badgeColor: const Color(0xFF2E7D32),
                  stats: const [
                    _Stat('30+', 'chart types'),
                    _Stat('RT', 'Real-time'),
                    _Stat('High', 'Performance'),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    _fadeRoute(const SyncfusionScreen()),
                  ),
                ),
                const SizedBox(height: 16),
                _LibraryCard(
                  title: 'graphic',
                  subtitle: 'Linh hoạt · Grammar of Graphics',
                  description:
                      'Xây dựng biểu đồ từ các thành phần: data → variables → marks → coord. Tùy biến không giới hạn.',
                  icon: Icons.scatter_plot_rounded,
                  gradientColors: [const Color(0xFF4A148C), const Color(0xFFAB47BC)],
                  badgeLabel: 'MIT License',
                  badgeColor: const Color(0xFF6A1B9A),
                  stats: const [
                    _Stat('GoG', 'Philosophy'),
                    _Stat('MIT', 'License'),
                    _Stat('∞', 'Flexibility'),
                  ],
                  onTap: () => Navigator.push(
                    context,
                    _fadeRoute(const GraphicScreen()),
                  ),
                ),
                const SizedBox(height: 24),
                _buildCompareCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  PageRoute _fadeRoute(Widget page) => PageRouteBuilder(
        pageBuilder: (context, animation, secondary) => page,
        transitionsBuilder: (context, animation, secondary, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      );

  Widget _buildHeroHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.bar_chart_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Flutter Chart Demo',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'CSC13118 · Nhóm 15',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'So sánh fl_chart · syncfusion · graphic',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        title: const Text(
          'Flutter Chart Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 14),
      ),
      backgroundColor: const Color(0xFF0D47A1),
    );
  }

  Widget _buildCompareCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.compare_arrows_rounded, color: Color(0xFF1565C0), size: 20),
              SizedBox(width: 8),
              Text('So sánh nhanh',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          _compareHeaderRow(),
          const Divider(height: 12),
          _compareRow('Dễ sử dụng', '⭐⭐⭐', '⭐⭐', '⭐'),
          _compareRow('Loại biểu đồ', '⭐⭐', '⭐⭐⭐', '⭐⭐'),
          _compareRow('Tùy biến', '⭐⭐', '⭐⭐⭐', '⭐⭐⭐'),
          _compareRow('Hiệu năng', '⭐⭐', '⭐⭐⭐', '⭐⭐'),
          _compareRow('Chi phí', 'Miễn phí', 'Miễn phí', 'Miễn phí'),
        ],
      ),
    );
  }

  Widget _compareHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(width: 90),
          Expanded(child: Center(child: Text('fl_chart', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1565C0))))),
          Expanded(child: Center(child: Text('syncfusion', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))))),
          Expanded(child: Center(child: Text('graphic', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A))))),
        ],
      ),
    );
  }

  Widget _compareRow(String label, String a, String b, String c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Expanded(child: Center(child: Text(a, style: const TextStyle(fontSize: 12)))),
          Expanded(child: Center(child: Text(b, style: const TextStyle(fontSize: 12)))),
          Expanded(child: Center(child: Text(c, style: const TextStyle(fontSize: 12)))),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _Stat {
  final String value;
  final String label;
  const _Stat(this.value, this.label);
}

class _LibraryCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final String badgeLabel;
  final Color badgeColor;
  final List<_Stat> stats;
  final VoidCallback onTap;

  const _LibraryCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.gradientColors,
    required this.badgeLabel,
    required this.badgeColor,
    required this.stats,
    required this.onTap,
  });

  @override
  State<_LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<_LibraryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.gradientColors.first.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            children: [
              // Header gradient
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.badgeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF555555),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        ...widget.stats.map((s) => Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    s.value,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: widget.gradientColors.first,
                                    ),
                                  ),
                                  Text(
                                    s.label,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: widget.gradientColors),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            children: [
                              Text('Demo',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded,
                                  color: Colors.white, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
