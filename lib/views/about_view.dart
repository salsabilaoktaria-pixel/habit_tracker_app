import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

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
          'about_title'.tr, // BERUBAH: Menggunakan .tr
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            
            // Logo App
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primaryColor, const Color(0xFF818CF8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_graph_rounded, 
                  size: 60, 
                  color: Colors.white
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Nama Aplikasi
            Text(
              'Habit Tracker', 
              style: GoogleFonts.poppins(
                fontSize: 26, 
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              )
            ),
            const SizedBox(height: 8),
            
            // Versi Aplikasi
            Text(
              // BERUBAH: Memanggil kunci bahasa untuk kata "Versi/Version"
              '${'language'.tr == 'Bahasa' ? 'Versi' : 'Version'} 1.0.0', 
              style: GoogleFonts.poppins(
                color: primaryColor, 
                fontWeight: FontWeight.w600,
                fontSize: 14
              )
            ),
            
            const SizedBox(height: 40),
            
            // Deskripsi Khusus Tentang Aplikasi
            Text(
              // BERUBAH: Pastikan kunci 'about_app_description' ada di TranslationService
              'about_app_description'.tr, 
              textAlign: TextAlign.center, 
              style: GoogleFonts.poppins(
                fontSize: 15, 
                color: isDark ? Colors.white70 : Colors.black54,
                height: 1.6
              )
            ),
            
            const Spacer(flex: 3),
            
            // Footer Brand
            Text(
              '© 2026 Habit Tracker Team',
              style: GoogleFonts.poppins(
                fontSize: 12, 
                color: Colors.grey[500],
                letterSpacing: 1.1
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}