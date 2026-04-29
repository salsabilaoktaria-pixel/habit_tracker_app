import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import 'widgets/habit_card.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memanggil controller yang sudah ada di memori
    final HabitController controller = Get.find<HabitController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text(
          'history'.tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // PERBAIKAN: Mengambil data habit yang sudah selesai (isCompleted == true)
        final completedList = controller.habits.where((h) => h.isCompleted).toList();

        if (completedList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Menggunakan icon yang lebih estetik untuk empty state
                Icon(
                  Icons.auto_awesome_motion_rounded,
                  size: 80,
                  color: isDark ? Colors.white10 : Colors.grey[200],
                ),
                const SizedBox(height: 16),
                Text(
                  'history_empty'.tr,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: completedList.length,
          itemBuilder: (context, index) {
            return HabitCard(
              habit: completedList[index],
              controller: controller,
            );
          },
        );
      }),
    );
  }
}