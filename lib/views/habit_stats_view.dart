import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../models/habit_model.dart';

class HabitStatsView extends StatelessWidget {
  const HabitStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find();
    final primaryColor = const Color(0xFF6366F1); // Indigo

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('statistic_title'.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Obx(() {
        if (controller.habits.isEmpty) {
          return Center(child: Text('no_data'.tr, style: GoogleFonts.poppins()));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuickSummary(context, controller, primaryColor),
              const SizedBox(height: 32),
              Text(
                'weekly_progress'.tr,
                style: GoogleFonts.poppins(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: primaryColor
                ),
              ),
              const SizedBox(height: 16),
              _buildStyledChart(context, controller, primaryColor),
              const SizedBox(height: 32),
              _buildBestRecords(controller, primaryColor),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuickSummary(BuildContext context, HabitController controller, Color primaryColor) {
    int totalStreak = controller.habits.fold(0, (sum, item) => sum + item.currentStreak);
    int completed = controller.habits.where((h) => h.progress >= h.targetDays).length;

    return Row(
      children: [
        _statCard(context, 'total_streak'.tr, '$totalStreak', Icons.local_fire_department_rounded, Colors.orange),
        const SizedBox(width: 16),
        _statCard(context, 'habit_finished'.tr, '$completed', Icons.verified_rounded, Colors.green),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon, Color color) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8)
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledChart(BuildContext context, HabitController controller, Color primaryColor) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(12, 24, 24, 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: controller.habits.map((h) => h.targetDays.toDouble()).reduce((a, b) => a > b ? a : b) + 2,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, 
                getTitlesWidget: (v, m) {
                  int idx = v.toInt();
                  if (idx < 0 || idx >= controller.habits.length) return const SizedBox();
                  String t = controller.habits[idx].title;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      t.length > 3 ? t.substring(0, 3).toUpperCase() : t.toUpperCase(), 
                      style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)
                    ),
                  );
                }
              )
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true, 
                reservedSize: 30,
                getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(color: Colors.grey, fontSize: 10))
              )
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: isDark ? Colors.white10 : Colors.grey[100], strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: controller.habits.asMap().entries.map((e) {
            final bool isFinished = e.value.progress >= e.value.targetDays;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.progress.toDouble(),
                  gradient: LinearGradient(
                    colors: isFinished 
                      ? [Colors.greenAccent, Colors.green] 
                      : [primaryColor, primaryColor.withOpacity(0.6)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: e.value.targetDays.toDouble(),
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBestRecords(HabitController controller, Color primaryColor) {
    Habit bestOfAll = controller.habits.reduce((a, b) => a.bestStreak > b.bestStreak ? a : b);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)], // Indigo to Violet
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.stars_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('highest_achievement'.tr, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                Text('${bestOfAll.bestStreak} ${'days_no_break'.tr}', 
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${'on_habit'.tr}: ${bestOfAll.title}', 
                  style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}