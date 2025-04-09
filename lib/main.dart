import 'package:ai_studio/src/auth_bloc/auth_bloc.dart';
import 'package:ai_studio/src/auth_bloc/auth_screen.dart';
import 'package:ai_studio/src/login_bloc/login_screen.dart';
import 'package:ai_studio/src/setting_bloc/setting_screen.dart';
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
              home: AuthScreen(),
              routes: {
                '/auth': (context) => AuthScreen(),
                '/login': (context) => LoginScreen(),
                '/signup': (context) => SignupScreen(),
                // '/menu': (context) =>  MenuScreen(),
                // '/dashboard': (context) => DashboardScreen(),
                // // '/appointments': (context) => AppointmentScreen(),
                // // '/messages': (context) => ChatScreen(),
                // '/subscription': (context) => const SubscriptionScreen(),
                // '/support': (context) => const SupportScreen(),
                // '/settings': (context) => const SettingsScreen(),
                // // '/practitioner-detail': (context) => PractitionerDetailScreen(),
                // '/schedule': (context) => ScheduleScreen(),
              },
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/login':
                    return _createRoute(LoginScreen());
                  case '/signup':
                    return _createRoute(SignupScreen());
                  //   case '/menu':
                  //     return _createRoute( MenuScreen());
                  //   case '/dashboard':
                  //     return _createRoute( DashboardScreen());
                  // // case '/appointments':
                  // //   return _createRoute(const AppointmentScreen());
                  // // case '/messages':
                  // //   return _createRoute( ChatScreen());
                  //   case '/subscription':
                  //     return _createRoute( const SubscriptionScreen());
                  //   case '/support':
                  //     return _createRoute(const SupportScreen());
                  //   case '/settings':
                  //     return _createRoute(const SettingsScreen());
                  //   case '/organization-detail':
                  //     return _createRoute( OrganizationDetailScreen());
                  // // case '/schedule':
                  //   return _createRoute(const ScheduleScreen());
                  default:
                    return _createRoute(AuthScreen());
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
