import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/db/api_service.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(http.Client());
    authProvider = AuthProvider(apiService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StoryProvider(
              apiService: ApiService(http.Client())),
        ),
        ChangeNotifierProvider(
            create: (context) => DetailStoryProvider(
                apiService: ApiService(http.Client()),
                storyId: '',
        )),
        ChangeNotifierProvider(
            create: (context) =>
                AddStoryProvider(apiService: ApiService(http.Client()))),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider)
      ],
      child: MaterialApp.router(routerConfig: Routes.goRouter),
    );
  }
}
