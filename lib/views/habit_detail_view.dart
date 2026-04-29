import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../models/habit_model.dart';
import 'habit_form_view.dart';

class HabitDetailView extends StatelessWidget {
  final Habit habit;

  const HabitDetailView({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final HabitController controller = Get.find<HabitController>();
    // Konsisten menggunakan Biru Accent
    const Color primaryColor = Colors.blueAccent; 
    
    return Obx(() {
      final currentHabit = controller.habits.firstWhere(
        (h) => h.id == habit.id,
        orElse: () => habit,
      );

      bool isTargetReached = currentHabit.progress >= currentHabit.targetDays;
      bool isDoneToday = currentHabit.isCompletedToday;
      
      double progressValue = currentHabit.targetDays > 0 
          ? currentHabit.progress / currentHabit.targetDays 
          : 0;

      bool isDark = Theme.of(context).brightness == Brightness.dark;

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
          title: Text('Detail Habit'.tr, 
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, 
              color: isDark ? Colors.white : Colors.black87
            )),
          actions: [
            IconButton(
              onPressed: isTargetReached 
                  ? () => _showLockedInfo() 
                  : () => Get.to(() => HabitFormView(habit: currentHabit)),
              icon: Icon(Icons.edit_note_rounded, 
                color: isTargetReached ? Colors.grey : primaryColor),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeaderCard(currentHabit, progressValue, primaryColor),
              const SizedBox(height: 24),
              
              // Kartu Statistik & Info
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildInfoRow(context, Icons.local_fire_department_rounded, 'current_streak'.tr, '${currentHabit.currentStreak} ${'days'.tr}', Colors.orange),
                      _buildInfoRow(context, Icons.emoji_events_rounded, 'best_streak'.tr, '${currentHabit.bestStreak} ${'days'.tr}', Colors.amber),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Divider(color: isDark ? Colors.white10 : Colors.grey[100]),
                      ),
                      _buildInfoRow(context, Icons.category_rounded, 'category'.tr, currentHabit.category.tr, primaryColor),
                      _buildInfoRow(context, Icons.calendar_today_rounded, 'target_days'.tr, '${currentHabit.targetDays} ${'days'.tr}', Colors.teal),
                      _buildInfoRow(context, Icons.notes_rounded, 'description'.tr, 
                        currentHabit.description.isEmpty ? '-' : currentHabit.description, Colors.blueGrey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Tombol Progres Terpadu
              if (isTargetReached)
                _buildCompletedBadge()
              else if (isDoneToday)
                _buildFinishedTodayBadge(primaryColor)
              else
                _buildProgressButton(controller, currentHabit, primaryColor),
                
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeaderCard(Habit habit, double progress, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            habit.title, 
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 12,
                width: (Get.width - 104) * (progress > 1.0 ? 1.0 : progress),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 10)
                  ]
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // SINKRONISASI: Menggunakan kunci tr yang benar
          Text(
            '${habit.progress} ${'of'.tr} ${habit.targetDays} ${'days_completed'.tr}',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value, Color iconColor) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                Text(
                  value, 
                  style: GoogleFonts.poppins(
                    fontSize: 15, 
                    fontWeight: FontWeight.w600, 
                    color: isDark ? Colors.white : Colors.black87,
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedBadge() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stars_rounded, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Text(
                'habit_completed_msg'.tr,
                style: GoogleFonts.poppins(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinishedTodayBadge(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, color: primaryColor, size: 28),
          const SizedBox(width: 12),
          Text(
            'finished_today'.tr,
            style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressButton(HabitController controller, Habit currentHabit, Color primaryColor) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: () {
           controller.incrementProgress(currentHabit);
           _showProgressSuccess();
        },
        icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
        label: Text(
          'add_progress'.tr.toUpperCase(),
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  void _showLockedInfo() {
    Get.snackbar(
      'info_title'.tr, 
      'cannot_edit_finished_habit'.tr, 
      snackPosition: SnackPosition.TOP, 
      backgroundColor: Colors.amber.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 15,
      icon: const Icon(Icons.lock_rounded, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showProgressSuccess() {
    Get.snackbar(
      'success_title'.tr, 
      'progress_added_msg'.tr, 
      snackPosition: SnackPosition.TOP, 
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 15,
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }
}