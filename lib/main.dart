import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/habit_list_view.dart';
import 'services/translation_service.dart';
import 'services/notification_service.dart'; // 1. IMPORT SERVICE NOTIFIKASI
import 'controllers/settings_controller.dart';

void main() async {
  // Pastikan binding inisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. INISIALISASI NOTIFIKASI (Wajib await agar timezone & plugin siap)
  await NotificationService.init(); 
  
  // Load preferences awal untuk tema dan bahasa
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  bool isDark = prefs.getBool('is_dark') ?? false; 
  String lang = prefs.getString('app_lang') ?? 'Bahasa Indonesia';
  
  // Inject SettingsController ke memori
  Get.put(SettingsController()); 

  Locale initialLocale = lang == 'English'
      ? const Locale('en', 'US')
      : const Locale('id', 'ID');

  runApp(MyApp(
    isDarkMode: isDark,
    initialLocale: initialLocale,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final Locale initialLocale;

  const MyApp({
    super.key, 
    required this.isDarkMode, 
    required this.initialLocale
  });

  @override
  Widget build(BuildContext context) {
    // Palette Warna Modern (Indigo & Slate)
    const primaryColor = Color(0xFF6366F1); 
    const accentColor = Color(0xFF818CF8);
    const darkBg = Color(0xFF0F172A); 
    const darkCard = Color(0xFF1E293B); 
    const lightBg = Color(0xFFF8FAFC);

    return GetMaterialApp(
      title: 'Habit Tracker',
      translations: TranslationService(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      
      // Tema Terang
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: accentColor,
          surface: Colors.white,
          background: lightBg,
        ),
        scaffoldBackgroundColor: lightBg,
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: AppBarTheme(
          backgroundColor: lightBg,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E293B),
          ),
        ),
        cardTheme: CardThemeData( 
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade100),
          ),
        ),
      ),

      // Tema Gelap
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: accentColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
          primary: accentColor,
          secondary: primaryColor,
          surface: darkCard,
          background: darkBg,
        ),
        scaffoldBackgroundColor: darkBg,
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        appBarTheme: AppBarTheme(
          backgroundColor: darkBg,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        cardTheme: CardThemeData(
          color: darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HabitListView(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
    );
  }
}