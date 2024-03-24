import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/screen/add_story_screen.dart';
import 'package:story_app/screen/detail_story_screen.dart';
import 'package:story_app/screen/home_screen.dart';
import 'package:story_app/screen/login_screen.dart';
import 'package:story_app/screen/register_screen.dart';
import 'package:story_app/screen/splash_screen.dart';

class Routes {
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String detail = 'detail';
  static const String addStory = 'add-story';
  static const String camera = 'camera';

  static GoRouter goRouter =
      GoRouter(initialLocation: '/', debugLogDiagnostics: true, routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (context, state) {
        return const MaterialPage(child: SplashScreen());
      },
    ),
    GoRoute(
      path: '/login',
      name: login,
      pageBuilder: (context, state) {
        return MaterialPage(
            child: LoginScreen(
          onLogin: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Login Success")));
            GoRouter.of(context).pushReplacementNamed(Routes.home);
          },
          onRegister: () {
            GoRouter.of(context).pushNamed(Routes.register);
          },
        ));
      },
    ),
    GoRoute(
        path: '/register',
        name: register,
        pageBuilder: (context, state) {
          return MaterialPage(
              child: RegisterScreen(
            onRegister: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Register Success")));
            },
            onLogin: () {
              GoRouter.of(context).pushNamed(Routes.login);
            },
          ));
        }),
    GoRoute(
        path: '/home',
        name: home,
        pageBuilder: (context, state) {
          return const MaterialPage(child: HomeScreen());
        }),
    GoRoute(
        path: '/detail:storyId',
        name: detail,
        pageBuilder: (context, state) {
          final storyId = state.pathParameters['storyId'] as String;
          return MaterialPage(child: DetailStoryScreen(storyId: storyId));
        }),
    GoRoute(
        path: '/add-story',
        name: addStory,
        pageBuilder: (context, state) {
          return const MaterialPage(child: AddStoryScreen());
        }),
  ]);
}
