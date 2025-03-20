import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class CustomSnackBar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.white,
      icon: Icons.check_circle_outline,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.white,
      icon: Icons.error_outline,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.white,
      icon: Icons.info_outline,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration? duration,
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.white,
      icon: Icons.warning_amber_rounded,
      duration: duration,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                style: AppTextStyles.medium14.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // margin: EdgeInsets.symmetric(
        //   horizontal: MediaQuery.of(context).size.width * 0.26,
        //   vertical: 20,
        // ),
        elevation: 4,width:  MediaQuery.of(context).size.width * 0.26,
        dismissDirection: DismissDirection.horizontal,
        // action: SnackBarAction(
        //   label: 'Dismiss',
        //   textColor: AppColors.white,
        //   onPressed: () {
        //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //   },
        // ),
      ),
    );
  }
}