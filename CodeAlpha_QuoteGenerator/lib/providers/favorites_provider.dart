import 'package:flutter/material.dart';
import '../models/quote_model.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Quote> _favorites = [];

  List<Quote> get favorites => _favorites;

  bool isFavorite(Quote quote) {
    return _favorites.any((q) => q.id == quote.id);
  }

  void toggleFavorite(Quote quote) {
    if (isFavorite(quote)) {
      _favorites.removeWhere((q) => q.id == quote.id);
    } else {
      _favorites.add(quote);
    }
    notifyListeners();
  }
}