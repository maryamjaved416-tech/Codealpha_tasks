import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/favorites_screen.dart';
import '../data/quotes_data.dart';

class AppDrawer extends StatelessWidget {
  final Function(String) onCategorySelected;
  final String selectedCategory;

  const AppDrawer({
    super.key,
    required this.onCategorySelected,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.format_quote, size: 40, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  'Quote Generator',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: Text('Home', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context); // ← Drawer band karo
              Navigator.of(context).popUntil((route) => route.isFirst); // ← Home pe jao
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite_rounded),
            title: Text('Favorites', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'CATEGORIES',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          ...QuotesData.categories.map((category) {
            return ListTile(
              leading: Icon(
                selectedCategory == category
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: selectedCategory == category
                    ? const Color(0xFF1E40AF)
                    : Colors.grey,
              ),
              title: Text(
                category,
                style: GoogleFonts.poppins(
                  fontWeight: selectedCategory == category
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
              onTap: () {
                onCategorySelected(category);
                Navigator.pop(context);
              },
            );
          }).toList(),
          const Divider(),
          ListTile(
            leading: Icon(themeProvider.isDark? Icons.light_mode : Icons.dark_mode),
            title: Text(
              themeProvider.isDark? 'Light Mode' : 'Dark Mode',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('About', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Quote Generator',
                applicationVersion: '1.0.0',
                children: [
                  Text('A professional quote app made with Flutter', style: GoogleFonts.poppins()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}