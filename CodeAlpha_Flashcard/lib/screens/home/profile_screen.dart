import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int totalCards = 0;
  int quizzesCompleted = 0;
  double averageScore = 0;
  int bestStreak = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserStats();
  }

  Future<void> _fetchUserStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => isLoading = false);
      return;
    }

    final dbRef = FirebaseDatabase.instance.ref('users/${user.uid}');

    try {
      // Stats nikal lo
      final statsSnap = await dbRef.child('stats').get();
      if (statsSnap.exists) {
        final data = Map<String, dynamic>.from(statsSnap.value as Map);
        totalCards = data['totalCards'] ?? 0;
        quizzesCompleted = data['quizzesCompleted'] ?? 0;
        averageScore = (data['averageScore'] ?? 0).toDouble();
        bestStreak = data['bestStreak'] ?? 0;
      }
    } catch (e) {
      print('Error: $e');
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchUserStats,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 50)),
                    const SizedBox(height: 10),
                    const Text('User', style: TextStyle(fontSize: 20)),
                    Text(user?.email ?? ''),
                    const Divider(height: 30),
                    _buildStatRow('Total Cards', '$totalCards'),
                    _buildStatRow('Quizzes Completed', '$quizzesCompleted'),
                    _buildStatRow('Average Score', '${averageScore.toStringAsFixed(0)}%'),
                    _buildStatRow('Best Streak', '$bestStreak Days'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}