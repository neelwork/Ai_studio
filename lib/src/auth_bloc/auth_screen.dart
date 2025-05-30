import 'package:ai_studio/services/google_signin_services.dart';
import 'package:ai_studio/src/signup_bloc/signup_bloc.dart';
import 'package:ai_studio/src/login_bloc/login_bloc.dart';
import 'package:ai_studio/utils/global_functions_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../utils/responsive.dart';
import '../../widget/app_button.dart';
import 'auth_bloc.dart';
import 'auth_state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => SignUpBloc()),
      ],
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

class _AuthCard extends StatefulWidget {
  @override
  State<_AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<_AuthCard> {
  UserCredential? googleUserCredential;

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
                    borderColor: isDarkMode
                        ? AppColors.white.withOpacity(.83)
                        : AppColors.black.withOpacity(.83),
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
                    borderColor: isDarkMode
                        ? AppColors.white.withOpacity(.83)
                        : AppColors.black.withOpacity(.83),
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
                    onPressed: () async {
                      debugPrint('User Clicked...');
                      final userCredential = await AuthService().signInWithGoogle();
                      if (userCredential != null) {
                        debugPrint("User signed in: ${userCredential.user!.displayName}");
                        setState(() {
                          googleUserCredential = userCredential;
                        });
                        
                        // First try to login with the Google email
                        context.read<LoginBloc>().add(
                          LoginRequested(
                            phone: userCredential.user!.email.toString(),
                            password: '123456', // Default password for Google users
                          ),
                        );
                      }
                    },
                    backgroundColor: isDarkMode
                        ? Colors.white.withOpacity(0.83)
                        : AppColors.black.withOpacity(.83),
                    textColor: isDarkMode ? AppColors.black : AppColors.white,
                    textStyle: AppTextStyles.medium14,
                  ),
                  BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        if (state.response.status == 'true') {
                          // User exists, navigate to chat
                          nextReplacePage(context, '/chat');
                        } else if (state.response.message?.contains('Account does not exist') == true) {
                          // User doesn't exist, create new account
                          final email = googleUserCredential?.user?.email ?? '';
                          final displayName = googleUserCredential?.user?.displayName ?? email.split('@')[0];
                          
                          // Show loading message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Creating new account...'),
                              duration: Duration(seconds: 1),
                            ),
                          );


                          
                          context.read<SignUpBloc>().add(
                            SignUpRequested(
                              email: email,
                              password: '123456',
                              userName: displayName,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.response.message.toString()),
                            ),
                          );
                        }
                      }
                      if (state is LoginFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                          ),
                        );
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                  BlocListener<SignUpBloc, SignUpState>(
                    listener: (context, state) {
                      if (state is SignUpSuccess) {
                        if (state.response.status == 'true') {
                          // Sign up successful, navigate to chat
                          nextReplacePage(context, '/chat');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.response.message.toString()),
                            ),
                          );
                        }
                      }
                      if (state is SignUpFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error),
                          ),
                        );
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16.0),
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
