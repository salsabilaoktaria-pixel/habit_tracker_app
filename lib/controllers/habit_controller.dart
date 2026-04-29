import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/habit_model.dart';
import '../services/database_service.dart';

class HabitController extends GetxController {
  var habits = <Habit>[].obs;
  var filteredHabits = <Habit>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHabits();
  }

  // --- GETTER STATISTIK ---
  int get totalActive => habits.where((h) => !h.isCompleted).length;
  int get totalCompleted => habits.where((h) => h.isCompleted).length;

  int get highestStreak {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  // PERBAIKAN: Ubah void menjadi Future<void> agar bisa di-await
  Future<void> fetchHabits() async {
    isLoading.value = true;
    try {
      final data = await DatabaseService.instance.getAllHabits();
      habits.assignAll(data);
      filteredHabits.assignAll(data);
    } catch (e) {
      debugPrint("Error Fetching: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void searchHabits(String query) {
    if (query.isEmpty) {
      filteredHabits.assignAll(habits);
    } else {
      filteredHabits.assignAll(
        habits.where((h) => h.title.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  // --- LOGIKA TAMBAH PROGRESS ---
  void incrementProgress(Habit habit) async {
    if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();

    // Menggunakan getter isCompleted dari model
    if (habit.isCompleted) {
      _showLockedSnackbar('cannot_edit_finished_habit'.tr);
      return;
    }

    // Menggunakan getter isCompletedToday yang baru kita tambahkan di model
    if (habit.isCompletedToday) {
      _showLockedSnackbar('already_done_today'.tr, color: Colors.orangeAccent);
      return;
    }

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    int newProgress = habit.progress + 1;
    int newStreak = habit.currentStreak + 1;
    
    // Model copyWith sudah menangani isNowCompleted secara otomatis jika kita kirim progress baru
    Habit updatedHabit = habit.copyWith(
      progress: newProgress,
      currentStreak: newStreak,
      bestStreak: newStreak > habit.bestStreak ? newStreak : habit.bestStreak,
      lastCompletedDate: todayStr,
    );

    await DatabaseService.instance.updateHabit(updatedHabit);
    await fetchHabits(); // Sekarang bisa di-await dengan aman

    _showCustomSnackbar('success'.tr, 'progress_added_msg'.tr, Colors.green);
  }

  // --- LOGIKA UPDATE (FORM EDIT) ---
  Future<void> updateHabit(Habit habit) async {
    if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();

    if (habit.isCompleted) {
      _showLockedSnackbar('cannot_edit_finished_habit'.tr);
      return;
    }

    isLoading.value = true;
    try {
      await DatabaseService.instance.updateHabit(habit);
      await fetchHabits(); 
      
      _showCustomSnackbar('success'.tr, 'success_save'.tr, const Color(0xFF6366F1));
    } catch (e) {
      debugPrint("Error Update: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addHabit(Habit habit) async {
    if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();
    
    isLoading.value = true;
    try {
      await DatabaseService.instance.insertHabit(habit);
      await fetchHabits();
      _showCustomSnackbar('success'.tr, 'habit_added_msg'.tr, Colors.green);
    } catch (e) {
      debugPrint("Error Add: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void deleteHabit(int id) async {
    if (Get.isSnackbarOpen) await Get.closeCurrentSnackbar();

    try {
      await DatabaseService.instance.deleteHabit(id);
      await fetchHabits();
      _showCustomSnackbar('deleted'.tr, 'habit_deleted_msg'.tr, Colors.redAccent);
    } catch (e) {
      debugPrint("Error Delete: $e");
    }
  }

  // --- HELPER UI SNACKBAR ---
  
  void _showLockedSnackbar(String message, {Color color = const Color(0xFF6366F1)}) {
    Get.closeAllSnackbars(); 

    Get.snackbar(
      'info_title'.tr, 
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: color.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 15,
      margin: const EdgeInsets.all(15),
      icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  void _showCustomSnackbar(String title, String message, Color bgColor) {
    Get.closeAllSnackbars();

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: bgColor.withOpacity(0.9),
      colorText: Colors.white,
      borderRadius: 15,
      margin: const EdgeInsets.all(15),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }
}