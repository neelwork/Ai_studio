import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:silver_ai/src/auth_bloc/auth_screen.dart';
import 'package:silver_ai/src/chat_bloc/chat_screen.dart';
import 'package:silver_ai/src/login_bloc/login_screen.dart';
import 'package:silver_ai/src/setting_bloc/setting_screen.dart';
import 'package:silver_ai/src/signup_bloc/signup_screen.dart';
import 'package:silver_ai/src/splash_screen/splash_screen.dart';

Future<T?> nextPage<T>(BuildContext context, String routeName,
    {bool isHistory = false, Object? arguments}) {
  return Navigator.of(context).push<T>(
    PageRouteBuilder(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildRouteFromName(context, routeName, isHistory);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    ),
  );
}

Future<T?> nextReplacePage<T>(BuildContext context, String routeName,
    {bool isHistory = false, Object? arguments}) {
  log("isHistory: $isHistory");

  return Navigator.of(context).pushReplacement<T, void>(
    PageRouteBuilder(
      settings: RouteSettings(name: routeName, arguments: arguments),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildRouteFromName(context, routeName, isHistory);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

        return FadeTransition(
          opacity: fadeAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 700),
    ),
  );
}

Future<T?> slideFadeTransition<T>(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    PageRouteBuilder(
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
    ),
  );
}

Widget _buildRouteFromName(
    BuildContext context, String routeName, bool isHistory) {
  switch (routeName) {
    case '/':
      return const SplashScreen();
    case '/auth':
      return const AuthScreen();
    case '/login':
      return const LoginScreen();
    case '/signup':
      return const SignupScreen();
    // case '/signupStep2':
    //   return const SignupScreenDetails();
    case '/chat':
      return ChatScreen(
        isHistory: isHistory,
      );

    case '/settings':
      return const SettingsScreen();

    default:
      return const AuthScreen();
  }
}
