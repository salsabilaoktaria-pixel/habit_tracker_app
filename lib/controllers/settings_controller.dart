import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class SettingsController extends GetxController {
  // Nilai AKTIF (tersimpan di database/disk)
  var isNotificationEnabled = false.obs;
  var selectedLanguage = 'Bahasa Indonesia'.obs;
  final RxString userName = ''.obs;
  final RxString userMajor = ''.obs;

  // Nilai PENDING (Draft/Sementara - Belum disimpan)
  var pendingNotification = false.obs;
  var pendingLanguage = 'Bahasa Indonesia'.obs;
  var pendingDarkMode = false.obs;

  static const String _notifKey = 'notif_active';
  static const String _langKey = 'app_lang';
  static const String _nameKey = 'user_name';
  static const String _majorKey = 'user_major';

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      isNotificationEnabled.value = prefs.getBool(_notifKey) ?? false;
      String savedLang = prefs.getString(_langKey) ?? 'Bahasa Indonesia';
      userName.value = prefs.getString(_nameKey) ?? '';
      userMajor.value = prefs.getString(_majorKey) ?? '';

      // Sinkronkan nilai pending dengan nilai yang tersimpan saat aplikasi dibuka
      pendingNotification.value = isNotificationEnabled.value;
      selectedLanguage.value = savedLang;
      pendingLanguage.value = savedLang;
      pendingDarkMode.value = Get.isDarkMode;

      // Terapkan bahasa yang tersimpan di awal
      _applyLocale(savedLang);
    } catch (e) {
      debugPrint("Error loading settings: $e");
    }
  }

  // =========================================================
  // PENDING CHANGES (Hanya mengubah variabel, tidak mengubah UI Sistem)
  // =========================================================

  void setPendingNotification(bool value) => pendingNotification.value = value;

  void setPendingLanguage(String langName) {
    // PERBAIKAN: Hanya update nilai string, JANGAN panggil _applyLocale di sini
    pendingLanguage.value = langName;
  }

  void setPendingDarkMode(bool value) {
    pendingDarkMode.value = value;
  }

  // =========================================================
  // SAVE ALL - Di sinilah perubahan benar-benar diterapkan
  // =========================================================

  Future<void> saveAllSettings(String name, String major) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Simpan profil
    await prefs.setString(_nameKey, name);
    await prefs.setString(_majorKey, major);
    userName.value = name;
    userMajor.value = major;

    // 2. Simpan & Terapkan Dark Mode
    if (pendingDarkMode.value != Get.isDarkMode) {
      Get.changeThemeMode(pendingDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      await prefs.setBool('is_dark', pendingDarkMode.value);
    }

    // 3. Simpan & Terapkan Bahasa (Locale)
    if (pendingLanguage.value != selectedLanguage.value) {
      selectedLanguage.value = pendingLanguage.value;
      await prefs.setString(_langKey, pendingLanguage.value);
      
      // PERBAIKAN: Baru terapkan bahasa ke sistem saat tombol simpan ditekan
      _applyLocale(pendingLanguage.value);
    }

    // 4. Simpan & Terapkan Notifikasi
    if (pendingNotification.value != isNotificationEnabled.value) {
      isNotificationEnabled.value = pendingNotification.value;
      await prefs.setBool(_notifKey, pendingNotification.value);

      if (pendingNotification.value) {
        await _setupDailyReminder();
      } else {
        await NotificationService.cancelAllNotifications();
      }
    }
  }

  // =========================================================
  // PRIVATE HELPERS
  // =========================================================

  void _applyLocale(String langName) {
    Locale locale = langName == 'English'
        ? const Locale('en', 'US')
        : const Locale('id', 'ID');
    
    // Update bahasa sistem
    Get.updateLocale(locale);
  }

  Future<void> _setupDailyReminder() async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, 20, 0);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await NotificationService.scheduleNotification(
      1,
      'notif_title'.tr,
      'notif_body'.tr,
      scheduledTime,
    );
  }
}