import 'package:silver_ai/services/shared_preference/shared_preference.dart';
import 'package:silver_ai/src/setting_bloc/profile_bloc.dart';
import 'package:silver_ai/utils/colors.dart';
import 'package:silver_ai/utils/global_functions_variable.dart';
import 'package:silver_ai/utils/responsive.dart';
import 'package:silver_ai/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final token = await StorageService.read(StorageService.authToken);

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // Trigger profile API call
      context.read<ProfileBloc>().add(ProfileRequested());
    } else {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    if (!_hasNavigated) {
      _hasNavigated = true;
      nextReplacePage(context, '/auth');
    }
  }

  void _navigateToChat() {
    if (!_hasNavigated) {
      _hasNavigated = true;
      nextReplacePage(context, '/chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    // Access current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          _navigateToChat();
        } else if (state is ProfileFailure) {
          _navigateToAuth();
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
