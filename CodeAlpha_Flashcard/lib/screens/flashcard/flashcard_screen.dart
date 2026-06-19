import 'package:flutter/material.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int currentIndex = 0;
  bool showAnswer = false;

  final List<Map<String, String>> flashcards = [
    {
      'question': 'Area of Circle ka formula?',
      'answer': 'A = πr²\njahan r = radius',
    },
    {
      'question': 'Quadratic Formula?',
      'answer': 'x = (-b ± √(b² - 4ac)) / 2a',
    },
    {
      'question': 'Pythagoras Theorem?',
      'answer': 'a² + b² = c²\njahan c = hypotenuse',
    },
    {
      'question': 'Speed ka formula?',
      'answer': 'Speed = Distance / Time',
    },
    {
      'question': 'Ohm\'s Law?',
      'answer': 'V = IR\nV = Voltage, I = Current, R = Resistance',
    },
  ];

  void nextCard() {
    setState(() {
      if (currentIndex < flashcards.length - 1) {
        currentIndex++;
        showAnswer = false;
      }
    });
  }

  void prevCard() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        showAnswer = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4F46E5), Color(0xFFEC4899)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text('Formula Quiz', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('${currentIndex + 1}/${flashcards.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 30),

                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showAnswer =!showAnswer),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                showAnswer? 'Answer:' : 'Question:',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: showAnswer? const Color(0xFF10B981) : const Color(0xFFEC4899),
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                showAnswer
                                    ? flashcards[currentIndex]['answer']!
                                    : flashcards[currentIndex]['question']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 30),
                              if (!showAnswer)
                                const Text(
                                  'Tap to see answer',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: currentIndex > 0? prevCard : null,
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            label: const Text('Previous'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF4F46E5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: currentIndex < flashcards.length - 1? nextCard : null,
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            label: const Text('Next'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF4F46E5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}