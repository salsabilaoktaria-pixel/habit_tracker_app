import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/habit_controller.dart';
import '../models/habit_model.dart';

class HabitFormView extends StatefulWidget {
  final Habit? habit;
  final Function(Habit)? onSave;

  const HabitFormView({super.key, this.habit, this.onSave});

  @override
  State<HabitFormView> createState() => _HabitFormViewState();
}

class _HabitFormViewState extends State<HabitFormView> {
  final _formKey = GlobalKey<FormState>();
  
  // PERBAIKAN 1: Inisialisasi controller langsung untuk efisiensi
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _targetController;
  
  String _selectedCategory = 'Kesehatan';
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Kesehatan', 'icon': Icons.favorite},
    {'name': 'Produktivitas', 'icon': Icons.bolt},
    {'name': 'Edukasi', 'icon': Icons.book},
    {'name': 'Olahraga', 'icon': Icons.fitness_center},
    {'name': 'Keuangan', 'icon': Icons.payments},
    {'name': 'Sosial', 'icon': Icons.group},
    {'name': 'Spiritual', 'icon': Icons.self_improvement},
    {'name': 'Lainnya', 'icon': Icons.category},
  ];

  final HabitController controller = Get.find<HabitController>();
  bool get _isLocked => widget.habit?.isCompleted ?? false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit?.title ?? '');
    _descriptionController = TextEditingController(text: widget.habit?.description ?? '');
    _targetController = TextEditingController(text: widget.habit?.targetDays.toString() ?? '7');
    _selectedCategory = widget.habit?.category ?? 'Kesehatan';
  }

  // PERBAIKAN 2: Wajib dispose agar tidak bocor memori
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF6366F1);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.habit == null ? 'add_habit'.tr : 'edit_habit'.tr,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLocked) _buildLockWarning(),
              _buildSectionTitle('habit_question'.tr, primaryColor),
              _buildTextField(
                context,
                controller: _titleController,
                label: 'habit_name'.tr,
                hint: 'hint_habit_example'.tr,
                icon: Icons.edit_rounded,
                enabled: !_isLocked,
                validator: (v) => v!.isEmpty ? 'empty_title_error'.tr : null,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('desc_question'.tr, primaryColor),
              _buildTextField(
                context,
                controller: _descriptionController,
                label: 'description'.tr,
                hint: 'hint_desc'.tr,
                icon: Icons.notes_rounded,
                maxLines: 3,
                enabled: !_isLocked,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('category'.tr, primaryColor),
              _buildCategoryPicker(primaryColor),
              const SizedBox(height: 20),
              _buildSectionTitle('target_days'.tr, primaryColor),
              _buildTargetInput(primaryColor),
              const SizedBox(height: 40),
              // PERBAIKAN 3: Tombol tetap muncul tapi dengan kondisi berbeda
              _buildSubmitButton(primaryColor),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockWarning() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_rounded, color: Colors.amber),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'cannot_edit_finished_habit'.tr,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.amber[700], fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: enabled ? const Color(0xFF6366F1) : Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(18),
        ),
      ),
    );
  }

  Widget _buildCategoryPicker(Color primaryColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        bool isSelected = _selectedCategory == cat['name'];
        return InkWell(
          onTap: _isLocked ? null : () => setState(() => _selectedCategory = cat['name']),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? primaryColor : Colors.transparent),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'], size: 16, color: isSelected ? Colors.white : primaryColor),
                const SizedBox(width: 8),
                Text(
                  cat['name'].toString().toLowerCase().tr,
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : primaryColor,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTargetInput(Color primaryColor) {
    // PERBAIKAN 4: Penanganan parse double yang lebih aman
    double currentVal = double.tryParse(_targetController.text) ?? 7;
    if (currentVal < 1) currentVal = 1;
    if (currentVal > 30) currentVal = 30;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1 ${'days'.tr}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
            Text('${currentVal.round()} ${'days'.tr}', 
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: primaryColor)),
            Text('30 ${'days'.tr}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Slider(
          value: currentVal,
          min: 1,
          max: 30,
          divisions: 29,
          activeColor: primaryColor,
          onChanged: _isLocked ? null : (val) {
            setState(() {
              _targetController.text = val.round().toString();
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(Color primaryColor) {
    if (_isLocked) return const SizedBox.shrink(); // Jangan tampilkan jika terkunci

    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isLoading.value ? null : _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        child: controller.isLoading.value
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                widget.habit == null ? 'start_habit_btn'.tr : 'update_habit_btn'.tr,
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      )),
    );
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      Habit finalHabit;
      final int target = int.tryParse(_targetController.text) ?? 7;

      if (widget.habit == null) {
        finalHabit = Habit(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          targetDays: target,
          createdAt: DateTime.now(),
          category: _selectedCategory,
        );
        controller.addHabit(finalHabit);
      } else {
        finalHabit = widget.habit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          targetDays: target,
          category: _selectedCategory,
        );
        
        if (widget.onSave != null) {
          widget.onSave!(finalHabit);
        } else {
          controller.updateHabit(finalHabit);
        }
      }
      Get.back();
    }
  }
}