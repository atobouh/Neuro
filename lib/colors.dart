import 'package:flutter/material.dart';

// Primary color palette
final Color primaryTeal = const Color(0xFF2CB9B0); // Main action color
final Color warmYellow = const Color(0xFFFFD166); // Accent, playful touch
final Color coral = const Color(
    0xFFF46C5E); // Potentially for error states or warnings, or playful highlights
final Color skyBlue = const Color(0xFF84D6FF); // Another light, playful accent
final Color freshSage =
const Color(0xFFC7E8CA); // Soft, complementary light color
final Color cocoa =
const Color(0xFF55423D); // Darker text and primary elements for contrast
final Color lightTealBg =
const Color(0xFFE3FAF9); // Soft background color for the playful feel

// Additional colors derived or for specific uses to ensure contrast and readability for dyslexia
final Color darkCocoa =
cocoa.withOpacity(0.8); // Slightly darker for critical text
final Color lightGrey =
    Colors.grey.shade300; // For disabled states or subtle separators
final Color white =
    Colors.white; // For button text on dark backgrounds and input fields
final Color black =
    Colors.black; // For very strong contrast if needed, but cocoa is preferred
