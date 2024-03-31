import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes.dart';
import 'package:story_app/widget/story_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final storyProvider = context.read<StoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyProvider.pageItems != null) {
          storyProvider.fecthStories();
        }
      }
    });

    Future.microtask(() async => storyProvider.fecthStories());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () async {
                final authRead = context.read<AuthProvider>();
                final result = await authRead.logout();
                if (result) {
                  await Future.delayed(const Duration(seconds: 2));
                  const CircularProgressIndicator();
                  GoRouter.of(context).pushReplacementNamed(Routes.login);
                }
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                "List Story",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: _buildList(context))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).pushNamed(Routes.addStory),
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add_a_photo_rounded),
      ),
    );
  }

  Widget _buildList(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, child) {
      // final displayStories = provider.result.listStory;

      if (provider.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ResultState.hasData) {
        final listStories = provider.listStories;
        return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount:
                listStories.length + (provider.pageItems != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == listStories.length &&
                  provider.pageItems != null) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              var story = listStories[index];
              return StoryCardWidget(story: story);
            });
      } else if (provider.state == ResultState.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_rounded),
              const Text("Upss anda sedang tidak terhubung dengan internet !"),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    provider.fecthStories();
                  },
                  child: const Text("Refresh"))
            ],
          ),
        );
      } else {
        return const Center(
          child: Column(
            children: [
              Icon(Icons.warning_rounded),
              Text("Terjadi kesalahan !")
            ],
          ),
        );
      }
    });
  }
}
