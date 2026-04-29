import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final SettingsController controller = Get.find<SettingsController>();

  late TextEditingController nameController;
  late TextEditingController majorController;

  @override
  void initState() {
    super.initState();
    
    // Ambil nilai aktif dari controller
    nameController = TextEditingController(text: controller.userName.value);
    majorController = TextEditingController(text: controller.userMajor.value);

    // Sinkronkan nilai pending
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.pendingNotification.value = controller.isNotificationEnabled.value;
      controller.pendingLanguage.value = controller.selectedLanguage.value;
      controller.pendingDarkMode.value = Get.isDarkMode;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    majorController.dispose();
    super.dispose();
  }

  void _showTopSnackbar(String title, String message, {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Colors.orange.withOpacity(0.9) : Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 15,
      duration: const Duration(seconds: 3),
      icon: Icon(isError ? Icons.warning_rounded : Icons.check_circle, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    const Color primaryColor = Colors.blueAccent;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'settings'.tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('user_profile'.tr, primaryColor),
            const SizedBox(height: 16),
            _buildInputField('full_name'.tr, nameController, Icons.person_outline, isDark, primaryColor),
            const SizedBox(height: 16),
            _buildInputField('major'.tr, majorController, Icons.school_outlined, isDark, primaryColor),

            const SizedBox(height: 32),

            _buildSectionHeader('preferences'.tr, primaryColor),
            const SizedBox(height: 8),
            _buildSettingsCard(isDark, [
              // PERBAIKAN: Obx membungkus widget yang menggunakan .value
              Obx(() => _buildSwitchTile(
                Icons.notifications_none_rounded,
                'reminder_notif'.tr,
                controller.pendingNotification.value,
                primaryColor,
                (val) => controller.setPendingNotification(val),
              )),
              const Divider(height: 1, indent: 50),
              Obx(() => _buildSwitchTile(
                Icons.dark_mode_outlined,
                'dark_mode'.tr,
                controller.pendingDarkMode.value,
                primaryColor,
                (val) => controller.setPendingDarkMode(val),
              )),
              const Divider(height: 1, indent: 50),
              _buildLanguageTile(primaryColor, controller),
            ]),

            const SizedBox(height: 20),
            _buildInfoBox(), // Obx dihapus dari dalam fungsi ini
            const SizedBox(height: 32),

            _buildSaveButton(primaryColor, () async {
              final name = nameController.text.trim();
              final major = majorController.text.trim();

              if (name.isEmpty || major.isEmpty) {
                _showTopSnackbar('Oops', 'input_empty_error'.tr, isError: true);
                return;
              }

              await controller.saveAllSettings(name, major);
              _showTopSnackbar('success'.tr, 'success_save'.tr);
            }),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            // PERBAIKAN: Obx dihapus karena '.tr' bukan Rx variable
            child: Text(
              'settings_info'.tr, 
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Text(title.toUpperCase(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2, color: color));
  }

  Widget _buildSettingsCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, IconData icon, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[500], fontSize: 13),
          prefixIcon: Icon(icon, color: primaryColor, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Color color, Function(bool) onChanged) {
    return SwitchListTile.adaptive(
      secondary: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      value: value,
      activeColor: color,
      onChanged: onChanged,
    );
  }

  Widget _buildLanguageTile(Color color, SettingsController ctrl) {
    return ListTile(
      leading: Icon(Icons.language_rounded, color: color),
      title: Text('language'.tr, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: ctrl.pendingLanguage.value,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          style: GoogleFonts.poppins(fontSize: 14, color: color, fontWeight: FontWeight.w600),
          items: <String>['Bahasa Indonesia', 'English'].map((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val, style: GoogleFonts.poppins(fontSize: 14)));
          }).toList(),
          onChanged: (val) { if (val != null) ctrl.setPendingLanguage(val); },
        ),
      )),
    );
  }

  Widget _buildSaveButton(Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text('save_changes'.tr, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}