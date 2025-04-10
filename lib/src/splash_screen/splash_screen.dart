import 'package:ai_studio/services/shared_preference/shared_preference.dart';
import 'package:ai_studio/utils/colors.dart';
import 'package:ai_studio/utils/global_functions_variable.dart';
import 'package:ai_studio/utils/responsive.dart';
import 'package:ai_studio/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  void checkStatus() async {
    final token = await StorageService.read(StorageService.authToken);

    if (token != null && token.isNotEmpty) {
      Future.delayed(
          const Duration(
            seconds: 4,
          ), () {
        nextReplacePage(
          context,
          '/chat',
        );
      });
    } else {
      Future.delayed(
          const Duration(
            seconds: 4,
          ), () {
        nextReplacePage(context, '/auth');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    // Access current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/ai_icon.svg",
              height: responsive.getResponsiveValue(
                mobile: 60.0,
                tablet: 70.0,
                desktop: 80.0,
              ),
              // Apply color filter based on theme
              colorFilter: ColorFilter.mode(
                isDarkMode ? AppColors.white : AppColors.black,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Where Innovation Meets\nSimplicity.',
              textAlign: TextAlign.center,
              style: responsive
                  .getResponsiveValue(
                    mobile: AppTextStyles.medium20,
                    desktop: AppTextStyles.medium24,
                  )
                  .copyWith(
                    color: theme.textTheme.bodyLarge?.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
