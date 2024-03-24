import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/routes.dart';

class StoryCardWidget extends StatelessWidget {
  final ListStory story;
  const StoryCardWidget({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      child: InkWell(
        onTap: () {
          GoRouter.of(context)
              .pushNamed(Routes.detail, pathParameters: {'storyId': story.id});
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Hero(
                tag: story.photoUrl,
                child: Image.network(
                  story.photoUrl,
                  width: double.infinity, 
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, _) =>
                      const Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        story.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        story.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 14.0),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        story.createdAt.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 12.0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
