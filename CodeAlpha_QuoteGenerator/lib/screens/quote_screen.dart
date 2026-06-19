import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/favorites_provider.dart';
import '../models/quote_model.dart';
import '../data/quotes_data.dart';

class QuoteScreen extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const QuoteScreen({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  late Quote currentQuote;

  @override
  void initState() {
    super.initState();
    currentQuote = QuotesData.getRandomQuote(widget.selectedCategory);
  }

  @override
  void didUpdateWidget(QuoteScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      setState(() {
        currentQuote = QuotesData.getRandomQuote(widget.selectedCategory);
      });
    }
  }

  void getNewQuote() {
    setState(() {
      currentQuote = QuotesData.getRandomQuote(widget.selectedCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFF8B4513)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quote Generator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentQuote.category,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    Consumer<FavoritesProvider>(
                      builder: (context, favProvider, child) {
                        final isFav = favProvider.isFavorite(currentQuote);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                            size: 32,
                          ),
                          onPressed: () {
                            favProvider.toggleFavorite(currentQuote);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isFav ? 'Removed from favorites' : 'Added to favorites'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      color: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.format_quote, size: 40, color: Colors.white70),
                            const SizedBox(height: 16),
                            Text(
                              currentQuote.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '— ${currentQuote.author}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final text = '"${currentQuote.text}" — ${currentQuote.author}';
                              await Clipboard.setData(ClipboardData(text: text));
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Quote copied!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.copy, color: Colors.white),
                            label: const Text('Copy', style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final text = '"${currentQuote.text}" — ${currentQuote.author}';
                              if (kIsWeb) {
                                final encodedText = Uri.encodeComponent(text);
                                final whatsappUrl = 'https://wa.me/?text=$encodedText';
                                if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                                  await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
                                } else {
                                  await Clipboard.setData(ClipboardData(text: text));
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Copied! Share not available on web'), duration: Duration(seconds: 2)),
                                    );
                                  }
                                }
                              } else {
                                Share.share(text);
                              }
                            },
                            icon: const Icon(Icons.share, color: Colors.white),
                            label: const Text('Share', style: TextStyle(color: Colors.white)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: getNewQuote,
                        icon: const Icon(Icons.refresh),
                        label: const Text('New Quote'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}