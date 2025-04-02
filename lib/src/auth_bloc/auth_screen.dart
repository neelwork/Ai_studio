import 'package:ai_studio/global_functions_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/responsive.dart';
import '../../widget/app_button.dart';
import 'auth_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Center(
            child: _AuthCard(),
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
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
              letterSpacing: 1.2,
              color: theme.textTheme.bodyLarge?.color,
            ),
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
                      isDarkMode ? Colors.white : Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Where Innovation Meets\nSimplicity.',
                    textAlign: TextAlign.center,
                    style: responsive.getResponsiveValue(
                      mobile: AppTextStyles.medium20,
                      desktop: AppTextStyles.medium24,
                    ).copyWith(
                      color: theme.textTheme.bodyLarge?.color, // Use theme text color
                    ),
                  ),
                  SizedBox(
                    height: responsive.getResponsiveValue(
                      mobile: 24.0,
                      desktop: 32.0,
                    ),
                  ),
                  AppButton.outlined(
                    text: 'Login',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    onPressed: () {
                      nextPage(context, '/login');
                    },
                    borderColor: isDarkMode ? AppColors.white.withOpacity(.83)  :  AppColors.black.withOpacity(.83),
                    textColor: isDarkMode ? AppColors.white : AppColors.black,

                    textStyle: AppTextStyles.medium14,
                  ),
                  const SizedBox(height: 16),
                  AppButton.outlined(
                    text: 'Signup',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    onPressed: () {
                      nextPage(context, '/signup');
                    },
                    borderColor: isDarkMode ? AppColors.white.withOpacity(.83)  :  AppColors.black.withOpacity(.83),


                    textColor: isDarkMode ? AppColors.white : AppColors.black,
                    textStyle: AppTextStyles.medium14,
                  ),
                  const SizedBox(height: 16),
                  AppButton.filled(
                    text: 'Continue with Google',
                    width: double.infinity,
                    height: responsive.getResponsiveValue(
                      mobile: 45.0,
                      desktop: 50.0,
                    ),
                    onPressed: () {
                      nextPage(context, '/chat');
                    },
                    // onPressed: () =>
                    //     context.read<AuthBloc>().add(AuthGoogleLoginEvent()),
                    backgroundColor: isDarkMode ? Colors.white.withOpacity(0.83) : AppColors.black.withOpacity(.83),
                    textColor: isDarkMode ? AppColors.black : AppColors.white,
                    textStyle: AppTextStyles.medium14,
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CircularProgressIndicator(
                    color: AppColors.black,
                  ),
                );
              } else if (state is AuthErrorState) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    state.message,
                    style: AppTextStyles.regular14.copyWith(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
