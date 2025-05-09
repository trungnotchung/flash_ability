import 'package:flutter/material.dart';

// Color palette for community screens
class CommunityTheme {
  // Primary colors
  static const Color primary = Color(0xFF3D5AFE);
  static const Color primaryLight = Color(0xFFE8EAFF);
  static const Color primaryDark = Color(0xFF0031CA);

  // Background colors
  static const Color background = Color(0xFFF8F9FF);
  static const Color cardBackground = Colors.white;
  static const Color inputBackground = Color(0xFFF5F5F7);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A2C);
  static const Color textSecondary = Color(0xFF71727A);
  static const Color textLight = Color(0xFF9E9EA7);

  // Accent colors
  static const Color accent = Color(0xFF00C853);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);

  // Border colors
  static const Color border = Color(0xFFE1E1E6);
  static const Color divider = Color(0xFFEEEEF0);

  // Tag colors
  static Map<String, Color> tagColors = {
    'Q&A': Color(0xFFE8F5E9),
    'Tips': Color(0xFFE3F2FD),
    'Discussion': Color(0xFFF3E5F5),
    'New Flashcard': Color(0xFFFFF8E1),
    'Help': Color(0xFFFFEBEE),
  };

  static Map<String, Color> tagTextColors = {
    'Q&A': Color(0xFF2E7D32),
    'Tips': Color(0xFF1565C0),
    'Discussion': Color(0xFF6A1B9A),
    'New Flashcard': Color(0xFFFF8F00),
    'Help': Color(0xFFC62828),
  };

  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
    ],
  );

  // Input decoration
  static InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textLight, fontSize: 14),
      filled: true,
      fillColor: inputBackground,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: primary, width: 1),
      ),
    );
  }

  // Button style
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primary,
    foregroundColor: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  static ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: primary,
    side: BorderSide(color: primary),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  // Text styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textPrimary,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );
}
