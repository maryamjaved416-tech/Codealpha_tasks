import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  int totalQuizzes = 0;
  double averageScore = 0;
  int bestStreak = 0;
  int totalCards = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPerformance();
  }

  Future<void> _loadPerformance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}/stats');
      final snapshot = await dbRef.get();

      if (snapshot.exists && snapshot.value != null) {
        // Null check lagaya - ye sabse important hai
        final data = Map<String, dynamic>.from(snapshot.value as Map);

        totalQuizzes = (data['quizzesCompleted'] as num?)?.toInt() ?? 0;
        averageScore = (data['averageScore'] as num?)?.toDouble() ?? 0.0;
        bestStreak = (data['bestStreak'] as num?)?.toInt() ?? 0;
        totalCards = (data['totalCards'] as num?)?.toInt() ?? 0;
      }
    } catch (e) {
      print('Error loading performance: $e');
      // Error aaye to bhi default 0 rakho
      totalQuizzes = 0;
      averageScore = 0;
      bestStreak = 0;
      totalCards = 0;
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text('Performance', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadPerformance,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildCard('Total Quizzes', '$totalQuizzes'),
            _buildCard('Average Score', '${averageScore.toStringAsFixed(0)}%'),
            _buildCard('Best Streak', '$bestStreak Days'),
            _buildCard('Total Cards', '$totalCards'),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 18)),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}