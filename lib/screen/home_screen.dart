import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/provider/auth_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes.dart';
import 'package:story_app/widget/story_card_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
      List<ListStory> displayStories = provider.result.listStory;

      if (provider.state == ResultState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (provider.state == ResultState.hasData) {
        return ListView.builder(
            shrinkWrap: true,
            itemCount: displayStories.length,
            itemBuilder: (context, index) {
              var story = displayStories[index];
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
