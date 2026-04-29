import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/habit_model.dart';
import '../../controllers/habit_controller.dart';
import '../habit_detail_view.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final HabitController controller;

  const HabitCard({
    super.key,
    required this.habit,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    double progressValue = habit.targetDays > 0 ? habit.progress / habit.targetDays : 0;
    if (progressValue > 1.0) progressValue = 1.0;
    
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    // Menggunakan Biru sebagai warna utama kartu (Indigo/Blue Accent)
    const Color customBlue = Colors.blueAccent; 

    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          onTap: () => Get.to(() => HabitDetailView(habit: habit)),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                              color: habit.isCompleted 
                                  ? Colors.grey 
                                  : (isDark ? Colors.white : const Color(0xFF1E293B)),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                '${habit.currentStreak} ${'streak_days'.tr}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(context, customBlue),
                  ],
                ),
                const SizedBox(height: 20),
                _buildProgressSection(context, progressValue, customBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, Color primaryColor) {
    bool isCompleted = habit.isCompleted;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isCompleted 
            ? Colors.green.withOpacity(0.1) 
            : primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isCompleted ? 'status_completed'.tr : 'status_active'.tr,
        style: TextStyle(
          color: isCompleted ? Colors.green : primaryColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, double progressValue, Color primaryColor) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isFinished = habit.isCompleted;
    bool isDoneToday = habit.isCompletedToday;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${'progress'.tr}: ${habit.progress}/${habit.targetDays} ${'days'.tr}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progressValue * 100).toInt()}%',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isFinished ? Colors.green : primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progressValue,
            minHeight: 8,
            backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isFinished ? Colors.green : primaryColor
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => _confirmDelete(),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
              tooltip: 'delete'.tr,
              style: IconButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1),
                padding: const EdgeInsets.all(8),
              ),
            ),
            const SizedBox(width: 8),
            
            // TOMBOL UTAMA (KONSISTEN BIRU)
            ElevatedButton.icon(
              onPressed: (isFinished || isDoneToday) 
                  ? null 
                  : () => controller.incrementProgress(habit),
              icon: Icon(
                isFinished 
                    ? Icons.stars_rounded 
                    : (isDoneToday ? Icons.check_circle : Icons.add_circle_outline),
                size: 18,
                color: Colors.white, 
              ),
              label: Text(
                isFinished 
                    ? 'target_reached'.tr 
                    : (isDoneToday ? 'finished_today'.tr : 'add_progress'.tr),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                // Menggunakan primaryColor (Biru) untuk semua kondisi
                backgroundColor: primaryColor, 
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                // Efek visual saat tombol mati (disable): Biru dengan opasitas rendah agar tetap terlihat biru
                disabledBackgroundColor: primaryColor.withOpacity(0.6),
                disabledForegroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'delete_confirm_title'.tr,
      middleText: 'delete_confirm_msg'.tr,
      textConfirm: 'yes'.tr,
      textCancel: 'no'.tr,
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      onConfirm: () {
        controller.deleteHabit(habit.id!);
        if (Get.isOverlaysOpen) Get.back();
      },
    );
  }
}