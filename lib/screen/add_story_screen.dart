import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/story_provider.dart';
import 'package:story_app/routes.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Stroty"),
        actions: [
          IconButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              String description = _descriptionController.text;
              final authRead = context.read<AddStoryProvider>();
              final result = await authRead.postStory(description);

              if (result) {
                scaffoldMessenger.showSnackBar(const SnackBar(
                  content: Text("Success upload story"),
                  duration: Duration(seconds: 2),
                ));
                final authReadHome = context.read<StoryProvider>();
                await authReadHome.fecthStories();
                GoRouter.of(context).pop();
              }
            },
            icon: const Icon(Icons.done_all_rounded, color: Colors.deepPurple),
            tooltip: "Unggah",
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  flex: 2,
                  child: context.watch<AddStoryProvider>().imagePath == null
                      ? const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_rounded,
                            size: 100,
                          ),
                        )
                      : _showImage()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      child: Consumer<AddStoryProvider>(builder: (context, provider, _) {
                        final placemark = provider.newPlacemark;
                        return placemark == null
                            ? const Text("Choose the location")
                            : Text(
                                "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}");
                      }),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.fromLTRB(5, 30, 0, 10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    child: IconButton(
                        onPressed: () async {
                          final recievePlacemark =
                              await GoRouter.of(context).pushNamed(Routes.maps);
                          Provider.of<AddStoryProvider>(context, listen: false)
                              .updatePlaceMark(
                                  recievePlacemark as geo.Placemark);
                        },
                        icon: const Icon(Icons.location_pin, color: Colors.white)),
                  )
                ],
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    hintText: "Write description story here",
                    border: OutlineInputBorder()),
                maxLines: 4,
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _onGalleryView(),
                      child: const Text("Gallery")),
                  ElevatedButton(
                      onPressed: () => _onCameraView(),
                      child: const Text("Camera")),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  _onGalleryView() async {
    final isMacOs = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    final ImagePicker picker = ImagePicker();
    final provider = context.read<AddStoryProvider>();
    if (isMacOs || isLinux) return;

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    return kIsWeb
        ? ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.network(
              imagePath.toString(),
              fit: BoxFit.contain,
            ),
          )
        : ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Image.file(
              File(imagePath.toString()),
              fit: BoxFit.contain,
            ),
          );
  }

  _onCameraView() async {
    final ImagePicker picker = ImagePicker();
    final provider = context.read<AddStoryProvider>();
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid | isiOS);

    if (isNotMobile) return;

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }
}
