import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';
import '../../models/flashcard_model.dart';
import '../../services/auth_service.dart';
import '../../main.dart';

class QuizScreen extends StatefulWidget {
  QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  bool showAnswer = false;
  final DatabaseService _dbService = DatabaseService();
  int correctAnswers = 0;
  bool quizFinished = false;

  void nextCard(int totalCards) {
    setState(() {
      if (currentIndex < totalCards - 1) {
        currentIndex++;
        showAnswer = false;
      } else {
        _finishQuiz(totalCards);
      }
    });
  }

  void previousCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showAnswer = false;
      }
    });
  }

  void _markAnswer(bool isCorrect, int totalCards) {
    if (isCorrect) correctAnswers++;
    nextCard(totalCards);
  }

  Future<void> _finishQuiz(int totalCards) async {
    setState(() {
      quizFinished = true;
    });

    final userId = Provider.of<AuthService>(context, listen: false).currentUser?.uid;
    if (userId!= null) {
      int score = ((correctAnswers / totalCards) * 100).round();
      await _dbService.saveQuizResult(userId, score, totalCards);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text('Quiz', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeProvider.isDarkMode
                ? [const Color(0xFF1E1B4B), const Color(0xFF312E81)]
                : [const Color(0xFF4F46E5), const Color(0xFFEC4899)],
          ),
        ),
        child: StreamBuilder<List<FlashcardModel>>(
          stream: _dbService.getFlashcards(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final flashcards = snapshot.data?? [];

            if (flashcards.isEmpty) {
              return const Center(
                child: Text(
                  'No cards available!\nAdd some cards first',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              );
            }

            if (quizFinished) {
              int percentage = ((correctAnswers / flashcards.length) * 100).round();
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                    const SizedBox(height: 20),
                    const Text('Quiz Completed!',
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Text('$percentage%',
                        style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('$correctAnswers / ${flashcards.length} Correct',
                        style: const TextStyle(color: Colors.white70, fontSize: 20)),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      ),
                      child: const Text('Back to Home',
                          style: TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            }

            if (currentIndex >= flashcards.length) currentIndex = 0;
            final currentCard = flashcards[currentIndex];

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Question ${currentIndex + 1} of ${flashcards.length}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showAnswer =!showAnswer),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              showAnswer? 'Answer' : 'Question',
                              style: const TextStyle(fontSize: 16, color: Color(0xFF1E40AF), fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              showAnswer? currentCard.answer : currentCard.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            const SizedBox(height: 30),
                            if (!showAnswer)
                              Text(
                                'Tap to reveal answer',
                                style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (showAnswer)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: () => _markAnswer(false, flashcards.length),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text('Wrong', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () => _markAnswer(true, flashcards.length),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text('Correct', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentIndex == 0? Colors.grey : const Color(0xFF1E40AF),
                          ),
                          onPressed: currentIndex == 0? null : previousCard,
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          label: const Text('Previous', style: TextStyle(color: Colors.white)),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                          onPressed: () => setState(() => showAnswer = true),
                          label: const Text('Show Answer', style: TextStyle(color: Colors.white)),
                          icon: const Icon(Icons.visibility, color: Colors.white),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}