import 'package:get/get.dart';

class TranslationService extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // General Dashboard
          'dashboard_title': 'Habit Dashboard',
          'greeting': 'Hello,',
          'spirit_message': 'Small steps every day lead to big changes!',
          'search_hint': 'Search habit...',
          'total': 'Total',
          'finished': 'Finished',
          'habit_today': 'Habit Today',
          'empty_habits': 'No active habits yet.',
          'add_habit': 'Add New Habit',
          'edit_habit': 'Edit Habit',
          'status_active': 'Active',
          'status_completed': 'Completed',
          'streak_days': 'Days Streak',

          // Sidebar & Navigation
          'history': 'History',
          'history_empty': 'No habits completed yet.',
          'statistic_title': 'Habit Statistics',
          'settings': 'Settings',
          'about': 'About App',
          'about_title': 'About Application',
          'guide_title': 'User Guide',
          'version_label': 'Version',

          // About & Guide Detail
          'about_app_description':
              'Habit Tracker is a self-management application designed to help users build and monitor positive habits consistently. Through a smart tracking system and informative statistics, this app focuses on increasing productivity and daily discipline.',
          'pro_tip_label': 'Pro Tip',
          'pro_tip_desc':
              'Pro Tip: Consistency is key! Don\'t miss a single day to keep your streak burning.',

          // Guide View Details
          'guide_step_1_title': 'Create Habit',
          'guide_step_1_desc':
              'Press the plus button to start a new positive habit.',
          'guide_step_2_title': 'Daily Update',
          'guide_step_2_desc':
              'Click the add progress button once a day to maintain your streak.',
          'guide_step_3_title': 'Reach Target',
          'guide_step_3_desc':
              'Complete the habit until it reaches the set day target.',

          // Settings & Profile
          'user_profile': 'User Profile',
          'full_name': 'Full Name',
          'major': 'Major',
          'preferences': 'Preferences',
          'reminder_notif': 'Reminder Notification',
          'dark_mode': 'Dark Mode',
          'language': 'Language',
          'save_changes': 'Save Changes',
          'change': 'Change',

          // Notifications & Dialogs
          'notification_title': 'Habit Time!',
          'success': 'Success',
          'info': 'Information',
          'deleted': 'Deleted',
          'success_save': 'Settings Saved Successfully!',
          'habit_added_msg': 'New habit has been added!',
          'habit_deleted_msg': 'Habit has been removed.',
          'error_save': 'Failed to save settings',
          'already_done_today':
          'You have already updated this habit today!',
          'habit_already_finished':
          'This habit is already fully completed!',
          'progress_updated': 'Progress updated and streak increased!',
          'delete_confirm_title': 'Delete Habit?',
          'delete_confirm_msg':
          'Are you sure you want to delete this habit? This action cannot be undone.',
          'yes': 'Yes, Delete',
          'no': 'Cancel',
          'done': 'Done',
          'info_title': 'Information',
          'cannot_edit_msg': 'Completed habits cannot be edited.',
          'success_title': 'Success',
          'progress_added_msg': 'Your progress has been updated!',
          'cannot_edit_finished_habit':
          'This habit is already finished and cannot be edited.',
          'days_completed': 'days completed',
          'of': 'of',
          'habit_completed_msg': 'Habit Completed!',
          'notif_title': 'Keep it up!',
          'notif_body':
          'Time to continue your habit today, don\'t forget!',
          'settings_info': 'Theme, language, and notification changes will only be active after you press the save button.',

          // Notifikasi pengingat (KEY BARU)
          'notif_enabled_msg':
              'Daily reminder set at 20:00. You will be reminded every day!',
          'notif_disabled_msg':
              'Daily reminder has been turned off.',

          // Statistics & Detail
          'no_data': 'No data available.',
          'weekly_progress': 'Weekly Progress',
          'total_streak': 'Total Streak',
          'habit_finished': 'Habit Finished',
          'highest_achievement': 'Highest Achievement',
          'days_no_break': 'Days without break',
          'on_habit': 'On habit',
          'habit_name': 'Habit Name',
          'description': 'Description',
          'category': 'Category',
          'target_days': 'Target Days',
          'days': 'Days',
          'streak': 'streak',
          'progress': 'Progress',

          // Form Input
          'habit_question': 'What is your new target?',
          'desc_question': 'Give a short description',
          'start_habit_btn': 'Start Habit Now',
          'update_habit_btn': 'Update Habit',
          'hint_habit_example': 'e.g. Morning Exercise',
          'hint_desc': 'e.g. Run for 20 minutes',
          'empty_title_error': 'Title cannot be empty',
          'target_reached': 'TARGET REACHED',
          'finished_today': 'FINISHED TODAY',
          'add_progress': 'ADD PROGRESS',

          // Category Mapping
          'kesehatan': 'Health',
          'produktivitas': 'Productivity',
          'edukasi': 'Education',
          'olahraga': 'Exercise',
          'keuangan': 'Finance',
          'sosial': 'Social',
          'spiritual': 'Spiritual',
          'lainnya': 'Others',
        },
        'id_ID': {
          // General Dashboard
          'dashboard_title': 'Dashboard Habit',
          'greeting': 'Halo,',
          'spirit_message':
              'Langkah kecil setiap hari membawa perubahan besar!',
          'search_hint': 'Cari habit...',
          'total': 'Total',
          'finished': 'Selesai',
          'habit_today': 'Habit Hari Ini',
          'empty_habits': 'Belum ada habit aktif.',
          'add_habit': 'Tambah Habit Baru',
          'edit_habit': 'Edit Habit',
          'status_active': 'Aktif',
          'status_completed': 'Selesai',
          'streak_days': 'Hari Streak',

          // Sidebar & Navigation
          'history': 'Riwayat',
          'history_empty': 'Belum ada habit yang diselesaikan.',
          'statistic_title': 'Statistik Habit',
          'settings': 'Pengaturan',
          'about': 'Tentang Aplikasi',
          'about_title': 'Tentang Aplikasi',
          'guide_title': 'Panduan Pengguna',
          'version_label': 'Versi',

          // About & Guide Detail
          'about_app_description':
              'Habit Tracker adalah aplikasi manajemen diri yang dirancang untuk membantu pengguna membangun dan memantau kebiasaan positif secara konsisten. Melalui sistem pelacakan yang cerdas dan statistik yang informatif, aplikasi ini berfokus pada peningkatan produktivitas dan disiplin harian.',
          'pro_tip_label': 'Tips Pro',
          'pro_tip_desc':
              'Tips Pro: Konsistensi adalah kunci! Jangan lewatkan satu hari pun untuk menjaga streak tetap menyala.',

          // Guide View Details
          'guide_step_1_title': 'Buat Habit',
          'guide_step_1_desc':
              'Tekan tombol tambah untuk memulai kebiasaan positif baru.',
          'guide_step_2_title': 'Pembaruan Harian',
          'guide_step_2_desc':
              'Klik tombol tambah progres satu kali sehari untuk menjaga streak.',
          'guide_step_3_title': 'Capai Target',
          'guide_step_3_desc':
              'Selesaikan habit hingga mencapai target hari yang ditentukan.',

          // Settings & Profile
          'user_profile': 'Profil Pengguna',
          'full_name': 'Nama Lengkap',
          'major': 'Jurusan',
          'preferences': 'Preferensi',
          'reminder_notif': 'Notifikasi Pengingat',
          'dark_mode': 'Mode Gelap',
          'language': 'Bahasa',
          'save_changes': 'Simpan Perubahan',
          'change': 'Ubah',

          // Notifications & Dialogs
          'notification_title': 'Waktunya Habit!',
          'success': 'Berhasil',
          'info': 'Informasi',
          'deleted': 'Dihapus',
          'success_save': 'Pengaturan Berhasil Disimpan!',
          'habit_added_msg': 'Habit baru berhasil ditambahkan!',
          'habit_deleted_msg': 'Habit telah dihapus.',
          'error_save': 'Gagal menyimpan pengaturan',
          'already_done_today':
              'Kamu sudah memperbarui habit ini hari ini!',
          'habit_already_finished': 'Habit ini sudah selesai sepenuhnya!',
          'progress_updated': 'Progres diperbarui dan streak bertambah!',
          'delete_confirm_title': 'Hapus Habit?',
          'delete_confirm_msg':
              'Yakin ingin menghapus habit ini? Tindakan ini tidak bisa dibatalkan.',
          'yes': 'Ya, Hapus',
          'no': 'Batal',
          'done': 'Selesai',
          'info_title': 'Informasi',
          'cannot_edit_msg': 'Habit yang sudah selesai tidak dapat diubah.',
          'success_title': 'Berhasil',
          'progress_added_msg': 'Progres kamu telah diperbarui!',
          'cannot_edit_finished_habit':
              'Habit ini sudah selesai dan tidak dapat diubah lagi.',
          'days_completed': 'hari tercapai',
          'of': 'dari',
          'habit_completed_msg': 'Habit Selesai!',
          'notif_title': 'Ayo, Semangat!',
          'notif_body': 'Waktunya lanjutin habit kamu hari ini, jangan lupa ya!',
          'settings_info': 'Perubahan tema, bahasa, dan notifikasi hanya akan aktif setelah Anda menekan tombol simpan.',

          // Notifikasi pengingat (KEY BARU)
          'notif_enabled_msg':
              'Pengingat harian disetel pukul 20.00. Kamu akan diingatkan setiap hari!',
          'notif_disabled_msg':
              'Pengingat harian telah dimatikan.',

          // Statistics & Detail
          'no_data': 'Belum ada data.',
          'weekly_progress': 'Progres Mingguan',
          'total_streak': 'Total Streak',
          'habit_finished': 'Habit Selesai',
          'highest_achievement': 'Pencapaian Tertinggi',
          'days_no_break': 'Hari tanpa putus',
          'on_habit': 'Pada habit',
          'habit_name': 'Nama Habit',
          'description': 'Deskripsi',
          'category': 'Kategori',
          'target_days': 'Target Hari',
          'days': 'Hari',
          'streak': 'streak',
          'progress': 'Progres',

          // Form Input
          'habit_question': 'Apa target baru kamu?',
          'desc_question': 'Beri deskripsi singkat',
          'start_habit_btn': 'Mulai Habit Sekarang',
          'update_habit_btn': 'Perbarui Habit',
          'hint_habit_example': 'misal: Olahraga Pagi',
          'hint_desc': 'misal: Lari selama 20 menit',
          'empty_title_error': 'Judul tidak boleh kosong',
          'target_reached': 'TARGET TERCAPAI',
          'finished_today': 'SELESAI HARI INI',
          'add_progress': 'TAMBAH PROGRES',

          // Category Mapping
          'kesehatan': 'Kesehatan',
          'produktivitas': 'Produktivitas',
          'edukasi': 'Edukasi',
          'olahraga': 'Olahraga',
          'keuangan': 'Keuangan',
          'sosial': 'Sosial',
          'spiritual': 'Spiritual',
          'lainnya': 'Lainnya',
        }
      };
}