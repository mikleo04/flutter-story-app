import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geocoding/geocoding.dart';
import 'package:story_app/db/api_service.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  String? imagePath;
  XFile? imageFile;
  geo.Placemark? placemark;
  double? lat;
  double? lon;

  AddStoryProvider({required this.apiService});

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  geo.Placemark? get newPlacemark => placemark;

  void updatePlaceMark(geo.Placemark value) {
    placemark = value;
    notifyListeners();
  }

  Future<bool> postStory(String description) async {
    
    if (placemark != null) {
      final address =
        '${placemark!.subLocality}, ${placemark!.locality}, ${placemark!.postalCode}, ${placemark!.country}';

    final locations = await geo.locationFromAddress(address);

    lat = locations[0].latitude;
    lon = locations[0].longitude;

    print("latitudenya => $lat  longitudenya => $lon");
    }

    if (imageFile != null) {
      List<int> compressImage = (await FlutterImageCompress.compressWithFile(
        imageFile!.path,
        minHeight: 800,
        minWidth: 800,
        quality: 85,
      )) as List<int>;

      String imageName = imageFile!.name;

      return await apiService.postStory(
          description, compressImage, imageName, lat, lon);
    } else {
      return false;
    }
  }
}
