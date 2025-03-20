import 'package:ai_studio/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/responsive.dart';
import '../../widget/app_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access current theme directly from Theme.of(context)

    return Scaffold(
      // Use theme's scaffoldBackgroundColor instead of manual selection
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: _LoginCard(),
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    // Access current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final cardWidth = responsive.getResponsiveValue(
      mobile: responsive.wp(85),
      tablet: responsive.wp(70),
      desktop: responsive.wp(35),
    );

    return SizedBox(
      width: cardWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AI NAME',
            style: AppTextStyles.bold16.copyWith(
              letterSpacing: 1.2,
              color: theme.textTheme.bodyLarge?.color, // Use theme text color
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                // Use appropriate border color based on theme
                color: isDarkMode ? AppColors.white : AppColors.black,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: responsive.getResponsiveValue(
                mobile: const EdgeInsets.all(16.0),
                tablet: const EdgeInsets.all(24.0),
                desktop: const EdgeInsets.all(24.0),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  SvgPicture.asset(
                    "icons/ai_icon.svg",
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
                          color: theme.textTheme.bodyLarge
                              ?.color, // Use theme text color
                        ),
                  ),
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  CustomTextField(

                    label: 'Email',
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintText: 'motionizestudio@gmail.com',
                    // You may need to update CustomTextField to accept theme colors
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintText: '⚫⚫⚫⚫⚫⚫⚫',
                    obscureText: true,

                  ),
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  AppButton.filled(
                    text: 'Login',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    borderRadius: 24,
                    onPressed: () {},
                    // Use theme colors for the button
                    backgroundColor: isDarkMode
                        ? AppColors.white.withOpacity(0.83)
                        : AppColors.black.withOpacity(.83),
                    textColor: isDarkMode ? AppColors.black : AppColors.white,
                    textStyle: AppTextStyles.medium14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
