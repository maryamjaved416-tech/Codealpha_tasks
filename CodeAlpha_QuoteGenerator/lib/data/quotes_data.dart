import '../models/quote_model.dart';

class QuotesData {
  static final List<Quote> _allQuotes = [
    // Motivation
    Quote(
      id: 1, // ← int hai, String nahi
      text: 'Believe you can and you\'re halfway there.',
      author: 'Theodore Roosevelt',
      category: 'Motivation',
    ),
    Quote(
      id: 2,
      text: 'The only way to do great work is to love what you do.',
      author: 'Albert Einstein',
      category: 'Motivation',
    ),
    Quote(
      id: 3,
      text: 'It does not matter how slowly you go as long as you do not stop.',
      author: 'Confucius',
      category: 'Motivation',
    ),
    // Success
    Quote(
      id: 4,
      text: 'Success is not final, failure is not fatal: It is the courage to continue that counts.',
      author: 'Winston Churchill',
      category: 'Success',
    ),
    Quote(
      id: 5,
      text: 'The way to get started is to quit talking and begin doing.',
      author: 'Walt Disney',
      category: 'Success',
    ),
    Quote(
      id: 6,
      text: 'Don\'t be afraid to give up the good to go for the great.',
      author: 'John D. Rockefeller',
      category: 'Success',
    ),
    // Life
    Quote(
      id: 7,
      text: 'Life is what happens when you\'re busy making other plans.',
      author: 'John Lennon',
      category: 'Life',
    ),
    Quote(
      id: 8,
      text: 'You are never too old to set another goal or to dream a new dream.',
      author: 'C.S. Lewis',
      category: 'Life',
    ),
  ];

  // Search screen ke liye - YE ADD KARO
  static List<Quote> get quotes => _allQuotes;

  // Saari categories
  static List<String> get categories {
    return ['All', ..._allQuotes.map((q) => q.category).toSet().toList()];
  }

  // Category ke hisab se quotes
  static List<Quote> getQuotesByCategory(String category) {
    if (category == 'All') {
      return _allQuotes;
    }
    return _allQuotes.where((quote) => quote.category == category).toList();
  }

  // Random quote
  static Quote getRandomQuote(String category) {
    final filteredQuotes = getQuotesByCategory(category);
    if (filteredQuotes.isEmpty) return _allQuotes.first;
    filteredQuotes.shuffle();
    return filteredQuotes.first;
  }

  // Saare quotes
  static List<Quote> getAllQuotes() {
    return _allQuotes;
  }
}