import 'package:ai_studio/utils/global_functions_variable.dart';
import 'package:ai_studio/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/responsive.dart';
import '../../widget/app_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: _SignupStep1Card(),
        ),
      ),
    );
  }
}

class _SignupStep1Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
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
                letterSpacing: 1.2, color: theme.textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
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
                    "assets/icons/ai_icon.svg",
                    height: responsive.getResponsiveValue(
                      mobile: 60.0,
                      tablet: 70.0,
                      desktop: 80.0,
                    ),
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
                    label: 'Name',
                    hintText: 'Motionize Studio',
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    hintText: 'motionizestudio@gmail.com',
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  AppButton.filled(
                    text: 'Continue',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    borderRadius: 24,
                    onPressed: () {
                      nextPage(context, '/signupStep2');
                    },
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

class SignupScreenDetails extends StatelessWidget {
  const SignupScreenDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: _SignupStep2Card(),
        ),
      ),
    );
  }
}

class _SignupStep2Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
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
                letterSpacing: 1.2, color: theme.textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
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
                    "assets/icons/ai_icon.svg",
                    height: responsive.getResponsiveValue(
                      mobile: 60.0,
                      tablet: 70.0,
                      desktop: 80.0,
                    ),
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
                    label: 'Password',
                    hintText: '⚫⚫⚫⚫⚫⚫⚫',
                    obscureText: true,
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirm Password',
                    hintText: '⚫⚫⚫⚫⚫⚫⚫',
                    obscureText: true,
                    borderColor: isDarkMode ? AppColors.white : AppColors.black,
                    hintColor: isDarkMode
                        ? AppColors.white.withOpacity(.6)
                        : AppColors.black.withOpacity(.6),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    labelColor: isDarkMode ? AppColors.white : AppColors.black,
                  ),
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  AppButton.filled(
                    text: 'Signup',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    borderRadius: 24,
                    onPressed: () {},
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
