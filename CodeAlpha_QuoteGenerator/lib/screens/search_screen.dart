import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/quotes_data.dart';
import '../models/quote_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Quote> _results = [];
  final _controller = TextEditingController();

  void _search(String query) {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() {
      _results = QuotesData.quotes.where((q) =>
      q.text.toLowerCase().contains(query.toLowerCase()) ||
          q.author.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search', style: GoogleFonts.poppins(fontWeight: FontWeight.w600))),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Search quotes or authors...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final quote = _results[index];
                return ListTile(
                  title: Text(quote.text, style: GoogleFonts.poppins()),
                  subtitle: Text('— ${quote.author}', style: GoogleFonts.poppins(fontStyle: FontStyle.italic)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}