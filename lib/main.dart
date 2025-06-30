import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silver_ai/src/auth_bloc/auth_bloc.dart';
import 'package:silver_ai/src/auth_bloc/auth_screen.dart';
import 'package:silver_ai/src/chat_bloc/chat_screen.dart';
import 'package:silver_ai/src/login_bloc/login_screen.dart';
import 'package:silver_ai/src/setting_bloc/setting_screen.dart';
import 'package:silver_ai/src/signup_bloc/signup_screen.dart';
import 'package:silver_ai/src/splash_screen/splash_screen.dart';
import 'package:silver_ai/src/chat_bloc/get_all_chat_history_bloc.dart';
import 'package:silver_ai/src/chat_bloc/get_prompt_by_id_bloc.dart';
import 'package:silver_ai/src/setting_bloc/profile_bloc.dart';
import 'package:silver_ai/src/setting_bloc/delete_all_chat_bloc.dart';
import 'package:silver_ai/src/setting_bloc/update_user_bloc.dart';
import 'package:silver_ai/src/chat_bloc/chat_bloc.dart';
import 'package:silver_ai/src/login_bloc/login_bloc.dart';
import 'package:silver_ai/src/signup_bloc/signup_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  // Test asset loading
  try {
    await rootBundle.load('assets/icons/ai_icon.svg');
    debugPrint('✅ Asset loaded successfully: assets/icons/ai_icon.svg');
  } catch (e) {
    debugPrint('❌ Asset loading failed: assets/icons/ai_icon.svg - $e');
  }

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC7uh_X4Q9ekVJA34XjdHfqKlqbv_XVAw4",
        authDomain: "aistudio-ae528.firebaseapp.com",
        projectId: "aistudio-ae528",
        storageBucket: "aistudio-ae528.appspot.com",
        messagingSenderId: "1005197027466",
        appId: "1:1005197027466:web:7e65588d42a5458c8b6573",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
        BlocProvider<ChatBloc>(
          create: (_) => ChatBloc(),
        ),
        BlocProvider<GetAllChatHistoryBloc>(
          create: (_) => GetAllChatHistoryBloc(),
        ),
        BlocProvider<DeleteAllChatBloc>(
          create: (_) => DeleteAllChatBloc(),
        ),
        BlocProvider<GetPromptByIdBloc>(
          create: (_) => GetPromptByIdBloc(),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'SilverMind',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeProvider.themeMode,
              routes: {
                '/': (context) => const SplashScreen(),
                '/auth': (context) => const AuthScreen(),
                '/login': (context) => const LoginScreen(),
                '/signup': (context) => const SignupScreen(),
                '/chat': (context) => const ChatScreen(),
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/login':
                    return _createRoute(const LoginScreen());
                  case '/signup':
                    return _createRoute(const SignupScreen());
                  case '/chat':
                    return _createRoute(const ChatScreen());
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
