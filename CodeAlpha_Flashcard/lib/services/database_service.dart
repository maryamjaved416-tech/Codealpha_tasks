import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/flashcard_model.dart';

class DatabaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  // Cards Stream - ab users/uid/cards se
  Stream<List<FlashcardModel>> getFlashcards() {
    return _dbRef.child('users/$uid/cards').onValue.map((event) {
      final List<FlashcardModel> cards = [];
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          cards.add(FlashcardModel.fromMap(key, Map<String, dynamic>.from(value)));
        });
        cards.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      }
      return cards;
    });
  }

  // Card add karo + stats update karo
  Future<void> addFlashcard(String question, String answer) async {
    // 1. Card save karo
    await _dbRef.child('users/$uid/cards').push().set({
      'question': question,
      'answer': answer,
      'userId': uid,
      'createdAt': ServerValue.timestamp,
    });

    // 2. Total cards update karo
    final cardsSnap = await _dbRef.child('users/$uid/cards').get();
    await _dbRef.child('users/$uid/stats/totalCards').set(cardsSnap.children.length);
  }

  Future<void> updateFlashcard(String id, String question, String answer) async {
    await _dbRef.child('users/$uid/cards/$id').update({
      'question': question,
      'answer': answer,
    });
  }

  Future<void> deleteFlashcard(String id) async {
    await _dbRef.child('users/$uid/cards/$id').remove();
    final cardsSnap = await _dbRef.child('users/$uid/cards').get();
    await _dbRef.child('users/$uid/stats/totalCards').set(cardsSnap.children.length);
  }

  // Quiz result + stats dono update karo
  Future<void> saveQuizResult(String userId, int score, int totalCards) async {
    // 1. Result history mein save karo
    await _dbRef.child('quiz_results/$userId').push().set({
      'score': score,
      'totalCards': totalCards,
      'timestamp': ServerValue.timestamp,
    });

    // 2. Stats update karo Profile ke liye
    final statsRef = _dbRef.child('users/$userId/stats');
    final snap = await statsRef.get();

    int oldQuizzes = 0;
    double oldAvg = 0;
    int oldStreak = 0;

    if (snap.exists) {
      final data = Map<String, dynamic>.from(snap.value as Map);
      oldQuizzes = data['quizzesCompleted'] ?? 0;
      oldAvg = (data['averageScore'] ?? 0).toDouble();
      oldStreak = data['bestStreak'] ?? 0;
    }

    int newQuizzes = oldQuizzes + 1;
    double newAvg = ((oldAvg * oldQuizzes) + score) / newQuizzes;
    int newStreak = score >= 80 ? oldStreak + 1 : 0;

    await statsRef.update({
      'quizzesCompleted': newQuizzes,
      'averageScore': newAvg,
      'bestStreak': newStreak > oldStreak ? newStreak : oldStreak,
    });
  }

  // Performance ab stats se aayegi
  Stream<Map<String, dynamic>> getPerformance(String userId) {
    return _dbRef.child('users/$userId/stats').onValue.map((event) {
      if (event.snapshot.value == null) {
        return {'quizzesCompleted': 0, 'averageScore': 0, 'bestStreak': 0, 'totalCards': 0};
      }
      return Map<String, dynamic>.from(event.snapshot.value as Map);
    });
  }

  Future<void> resetPerformance(String userId) async {
    await _dbRef.child('quiz_results/$userId').remove();
    await _dbRef.child('users/$userId/stats').remove();
  }
}