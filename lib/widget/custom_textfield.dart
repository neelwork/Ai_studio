import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../utils/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double borderRadius;
  final Color borderColor;
  final Color textColor;
  final Color labelColor;
  final Color hintColor;
  final TextEditingController? controller;
  final bool obscureText;
  final Color textfieldColor;
  final int? maxLines;
  final Function(String)? onChanged;

   CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.borderColor =  AppColors.black,
    this.textColor = Colors.black,
    this.labelColor = Colors.black,
    this.borderRadius = 12,
    this.hintColor = AppColors.black,
    this.textfieldColor = AppColors.transparent,
    this.controller,
    this.obscureText = false,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label,
            style: AppTextStyles.medium16
                .copyWith(color: labelColor),
          ),
        const SizedBox(height: 4),
        Material(
          color: textfieldColor,
          borderRadius: BorderRadius.circular(borderRadius),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            obscuringCharacter: '⚫',
            maxLines: maxLines,
            onChanged: onChanged,
            style: GoogleFonts.lexend(fontSize: 14, color: textColor),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.regular16.copyWith(color: hintColor),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: borderColor, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
