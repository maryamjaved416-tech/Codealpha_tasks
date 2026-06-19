class FlashcardModel {
  final String id;
  final String question;
  final String answer;
  final String userId;
  final int createdAt;

  FlashcardModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.userId,
    required this.createdAt,
  });

  factory FlashcardModel.fromMap(String id, Map<String, dynamic> data) {
    return FlashcardModel(
      id: id,
      question: data['question']?? '',
      answer: data['answer']?? '',
      userId: data['userId']?? '',
      createdAt: data['createdAt']?? 0,
    );
  }
}