import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle publicSansTextStyle({
  double fontSize = 12,
  FontWeight fontWeight = FontWeight.normal,
  double lineHeight = 1.5,
  Color color = Colors.black,
}) {
  return GoogleFonts.publicSans(
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: lineHeight,
    color: color,
  );
}