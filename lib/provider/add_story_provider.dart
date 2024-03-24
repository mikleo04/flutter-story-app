import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:story_app/db/api_service.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  String? imagePath;
  XFile? imageFile;

  AddStoryProvider({required this.apiService});

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  Future<bool> postStory(String description) async {
    if (imageFile != null) {
      List<int> compressImage = (await FlutterImageCompress.compressWithFile(
        imageFile!.path,
        minHeight: 800,
        minWidth: 800,
        quality: 85,
      )) as List<int>;

      String imageName = imageFile!.name;

      return await apiService.postStory(description, compressImage, imageName);
    } else {
      return false;
    }
  }
}
