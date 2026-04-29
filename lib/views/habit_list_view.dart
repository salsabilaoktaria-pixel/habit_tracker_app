import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/habit_controller.dart';
import 'habit_form_view.dart';
import 'habit_stats_view.dart';
import 'settings_view.dart';
import 'about_view.dart';
import 'history_view.dart';
import 'guide_view.dart';
import 'widgets/habit_card.dart';

class HabitListView extends StatefulWidget {
  const HabitListView({super.key});

  @override
  State<HabitListView> createState() => _HabitListViewState();
}

class _HabitListViewState extends State<HabitListView> {
  final HabitController controller = Get.put(HabitController());
  final RxBool isSearching = false.obs;
  String displayName = 'Pengguna';
  String major = 'Manajemen Informatika';

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  void _refreshProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Mengambil data dari SharedPreferences atau fallback ke default
      displayName = prefs.getString('user_name') ?? 'Pengguna';
      major = prefs.getString('user_major') ?? 'Manajemen Informatika';
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildSideDrawer(isDark, primaryColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: false,
        title: Obx(() => isSearching.value
            ? _buildSearchField(isDark)
            : Text('dashboard_title'.tr,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20))),
        actions: [
          Obx(() => IconButton(
                icon: Icon(isSearching.value ? Icons.close_rounded : Icons.search_rounded),
                onPressed: () {
                  isSearching.value = !isSearching.value;
                  if (!isSearching.value) controller.searchHabits('');
                },
              )),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.fetchHabits(),
        child: Obx(() => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(primaryColor),
                  _buildQuickStats(isDark),
                  _buildSectionLabel('habit_today'.tr),
                  controller.filteredHabits.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.filteredHabits.length,
                          itemBuilder: (context, index) => HabitCard(
                            habit: controller.filteredHabits[index],
                            controller: controller,
                          ),
                        ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        autofocus: true,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'search_hint'.tr,
          prefixIcon: const Icon(Icons.search, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onChanged: (value) => controller.searchHabits(value),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, const Color(0xFF818CF8)],
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PERBAIKAN DI SINI: Menghapus koma manual agar tidak double
          Text('${'greeting'.tr} $displayName! 👋',
              style: GoogleFonts.poppins(
                  color: Colors.white, 
                  fontSize: 22, 
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('spirit_message'.tr,
              style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.9), 
                  fontSize: 13, 
                  letterSpacing: 0.3)),
        ],
      ),
    );
  }

  Widget _buildQuickStats(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _statTile('total'.tr, '${controller.habits.length}', const Color(0xFF6366F1), isDark),
          const SizedBox(width: 12),
          _statTile('finished'.tr, '${controller.totalCompleted}', const Color(0xFF10B981), isDark),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50),
          boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(value, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 4),
            Text(label.toUpperCase(),
                style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 1.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_motion_rounded, size: 100, color: isDark ? Colors.white10 : Colors.grey[200]),
          const SizedBox(height: 20),
          Text('empty_habits'.tr,
              style: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(bool isDark, Color primaryColor) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [primaryColor, const Color(0xFF818CF8)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            accountName: Text(displayName, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(major, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
            currentAccountPicture: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person_rounded, color: primaryColor, size: 40),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                const SizedBox(height: 8),
                _drawerItem(Icons.grid_view_rounded, 'dashboard_title'.tr, () => Get.back(), isDark),
                _drawerItem(
                  Icons.add_circle_outline_rounded,
                  'add_habit'.tr,
                  () {
                    Get.back();
                    Get.to(() => const HabitFormView());
                  },
                  isDark,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Divider(color: isDark ? Colors.white10 : Colors.grey[200]),
                ),
                _drawerItem(Icons.history_rounded, 'history'.tr, () {
                  Get.back();
                  Get.to(() => const HistoryView());
                }, isDark),
                _drawerItem(Icons.analytics_outlined, 'statistic_title'.tr, () {
                  Get.back();
                  Get.to(() => const HabitStatsView());
                }, isDark),
                _drawerItem(Icons.lightbulb_outline_rounded, 'guide_title'.tr, () {
                  Get.back();
                  Get.to(() => const GuideView());
                }, isDark),
                _drawerItem(Icons.settings_outlined, 'settings'.tr, () async {
                  Get.back();
                  await Get.to(() => const SettingsView());
                  _refreshProfile(); // Refresh tampilan setelah ganti nama di setting
                }, isDark),
                _drawerItem(Icons.info_outline_rounded, 'about_title'.tr, () {
                  Get.back();
                  Get.to(() => const AboutView());
                }, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap, bool isDark) {
    Color contentColor = isDark ? Colors.white70 : Colors.black87;
    Color iconColor = isDark ? const Color(0xFF818CF8) : Colors.grey[600]!;

    return ListTile(
      onTap: onTap,
      tileColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icon, size: 24, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: contentColor,
        ),
      ),
    );
  }
}