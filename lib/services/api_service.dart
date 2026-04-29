import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit_model.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com'; // Dummy API

  // Sync habit ke server (simulasi)
  Future<bool> syncHabitToServer(Habit habit) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': habit.title,
          'description': habit.description,
          'targetDays': habit.targetDays,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error syncing: $e');
      return false;
    }
  }

  // Fetch dari server (simulasi)
  Future<List<Habit>> fetchHabitsFromServer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts'));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        // Konversi dummy data ke habit (contoh)
        return data.take(5).map((item) {
          return Habit(
            title: item['title'] ?? 'Habit from server',
            description: 'Synced habit',
            targetDays: 7,
            createdAt: DateTime.now(),
          );
        }).toList();
      }
    } catch (e) {
      print('Error fetching: $e');
    }
    return [];
  }
}