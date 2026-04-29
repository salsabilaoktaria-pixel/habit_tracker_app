import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GuideView extends StatelessWidget {
  const GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF6366F1); // Indigo Modern
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'guide_title'.tr, 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        // Tambahkan tombol back agar konsisten
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        children: [
          _buildGuideItem(
            context, 
            '1', 
            'guide_step_1_title'.tr, 
            'guide_step_1_desc'.tr, 
            Icons.add_task_rounded,
            primaryColor
          ),
          _buildGuideItem(
            context, 
            '2', 
            'guide_step_2_title'.tr, 
            'guide_step_2_desc'.tr, 
            Icons.bolt_rounded,
            primaryColor
          ),
          _buildGuideItem(
            context, 
            '3', 
            'guide_step_3_title'.tr, 
            'guide_step_3_desc'.tr, 
            Icons.emoji_events_rounded,
            primaryColor
          ),
          const SizedBox(height: 20),
          _buildProTip(isDark, primaryColor),
        ],
      ),
    );
  }

  Widget _buildGuideItem(
    BuildContext context, 
    String step, 
    String title, 
    String desc, 
    IconData icon,
    Color primaryColor
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: primaryColor, size: 28),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // PERBAIKAN: Gunakan kunci 'step' dari TranslationService
                    "${'days'.tr == 'Hari' ? 'Langkah' : 'Step'} $step",
                    style: GoogleFonts.poppins(
                      fontSize: 12, 
                      fontWeight: FontWeight.bold, 
                      color: primaryColor.withOpacity(0.7),
                      letterSpacing: 1.2
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title, 
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, 
                      fontSize: 17,
                      color: isDark ? Colors.white : Colors.black87
                    )
                  ),
                  const SizedBox(height: 8),
                  Text(
                    desc, 
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 14,
                      height: 1.5
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProTip(bool isDark, Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
        color: primaryColor.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              // PERBAIKAN: Gunakan .tr agar teks Pro Tip berubah bahasa
              'pro_tip_desc'.tr,
              style: GoogleFonts.poppins(
                fontSize: 13, 
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.white70 : Colors.black87
              ),
            ),
          ),
        ],
      ),
    );
  }
}