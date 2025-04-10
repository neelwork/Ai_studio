import 'package:ai_studio/src/auth_bloc/auth_bloc.dart';
import 'package:ai_studio/src/auth_bloc/auth_screen.dart';
import 'package:ai_studio/src/login_bloc/login_bloc.dart';
import 'package:ai_studio/src/login_bloc/login_screen.dart';
import 'package:ai_studio/src/setting_bloc/profile_bloc.dart';
import 'package:ai_studio/src/setting_bloc/setting_screen.dart';
import 'package:ai_studio/src/setting_bloc/update_user_bloc.dart';
import 'package:ai_studio/src/signup_bloc/signup_bloc.dart';
import 'package:ai_studio/src/signup_bloc/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(),
        ),
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(),
        ),
        BlocProvider<UpdateUserBloc>(
          create: (_) => UpdateUserBloc(),
        ),
        BlocProvider<SignUpBloc>(
          create: (_) => SignUpBloc(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              home: const AuthScreen(),
              routes: {
                '/auth': (context) => const AuthScreen(),
                '/login': (context) => const LoginScreen(),
                '/signup': (context) => const SignupScreen(),
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/login':
                    return _createRoute(const LoginScreen());
                  case '/signup':
                    return _createRoute(const SignupScreen());
                  default:
                    return _createRoute(const AuthScreen());
                }
              },
            );
          },
        ),
      ),
    );
  }

  PageRoute _createRoute(Widget page) {
    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => page,
    //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //     return FadeTransition(
    //       opacity: animation,
    //       child: child,
    //     );
    //   },
    // );
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var slideAnimation = Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    );
  }
}
