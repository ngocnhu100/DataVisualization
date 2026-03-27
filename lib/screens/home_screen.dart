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
        background: LayoutBuilder(
          builder: (context, constraints) {
            const gradient = BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF42A5F5)],
              ),
            );

            final topInset = MediaQuery.paddingOf(context).top;
            final minExtent = kToolbarHeight + topInset;
            final t = ((constraints.maxHeight - minExtent) / (200 - minExtent))
                .clamp(0.0, 1.0)
                .toDouble();
            final canShowHeroContent = constraints.maxHeight >= 136;

            return Container(
              decoration: gradient,
              child: SafeArea(
                child: Padding(
                  // Reserve bottom space for collapsing title.
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 56),
                  child: !canShowHeroContent || t <= 0.35
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6 + (12 * t)),
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
                            if (t > 0.72) ...[
                              const SizedBox(height: 16),
                              Opacity(
                                opacity: ((t - 0.72) / 0.28).clamp(0.0, 1.0),
                                child: const Text(
                                  'So sánh fl_chart · syncfusion · graphic',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            );
          },
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
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 360;
              final labelWidth = isCompact ? 74.0 : 90.0;
              final textSize = isCompact ? 11.0 : 12.0;

              return Column(
                children: [
                  _compareHeaderRow(
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                  const Divider(height: 12),
                  _compareRow(
                    'Dễ sử dụng',
                    '⭐⭐⭐',
                    '⭐⭐',
                    '⭐',
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                  _compareRow(
                    'Loại biểu đồ',
                    '⭐⭐',
                    '⭐⭐⭐',
                    '⭐⭐',
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                  _compareRow(
                    'Tùy biến',
                    '⭐⭐',
                    '⭐⭐⭐',
                    '⭐⭐⭐',
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                  _compareRow(
                    'Hiệu năng',
                    '⭐⭐',
                    '⭐⭐⭐',
                    '⭐⭐',
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                  _compareRow(
                    'Chi phí',
                    'Miễn phí',
                    'Trả phí*',
                    'Miễn phí',
                    labelWidth: labelWidth,
                    textSize: textSize,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          const Text(
            '* Syncfusion có Community License miễn phí cho cá nhân, mục đích học tập và doanh nghiệp nhỏ.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _compareHeaderRow({
    required double labelWidth,
    required double textSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: labelWidth),
          Expanded(
              child: Center(
                  child: Text('fl_chart',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1565C0))))),
          Expanded(
              child: Center(
                  child: Text('syncfusion',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E7D32))))),
          Expanded(
              child: Center(
                  child: Text('graphic',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: textSize,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6A1B9A))))),
        ],
      ),
    );
  }

  Widget _compareRow(
    String label,
    String a,
    String b,
    String c, {
    required double labelWidth,
    required double textSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(label, style: TextStyle(fontSize: textSize, color: Colors.grey)),
          ),
          Expanded(
              child: Center(
                  child: Text(a,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: textSize)))),
          Expanded(
              child: Center(
                  child: Text(b,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: textSize)))),
          Expanded(
              child: Center(
                  child: Text(c,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: textSize)))),
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
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: widget.gradientColors),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
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
