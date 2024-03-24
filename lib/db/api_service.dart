import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/detail_story_response.dart';
import 'package:story_app/model/story_response.dart';

class ApiService {
  final http.Client client;

  ApiService(this.client);

  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<String?> getTokenFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<StoryResponse> getStories() async {
    String? token = await getTokenFromPreferences();
    print("Load The token $token");

    final response = await client.get(
      Uri.parse('$_baseUrl/stories'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return StoryResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed load stories');
    }
  }

  Future<DetailStoryResponse> getDetailStory(String storyId) async {
    print(storyId);
    String? token = await getTokenFromPreferences();
    final response = await client.get(
      Uri.parse('https://story-api.dicoding.dev/v1/stories/$storyId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return DetailStoryResponse.fromJson(json.decode(response.body));
    } else {
      print(json.decode(response.body));
      throw Exception('Failed load detail story');
    }
  }

  Future<bool> postStory(String description, List<int> imageData, String imageName  ) async {
    try {
      String? token = await getTokenFromPreferences();

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://story-api.dicoding.dev/v1/stories'));

      request.files
          .add(http.MultipartFile.fromBytes(  
            'photo',
            imageData,
            filename: imageName
          ));

      request.fields['description'] = description;

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();
      var jsonData = jsonDecode(responseBody);
      var message = jsonData['message'];

      if (response.statusCode == 201) {
        print(message);
        return true;
      } else {
        print("Post story fail ${response.statusCode}");
        print(message);
        return false;
      }
    } catch (e) {
      print(e);
      throw Exception("Failed post story");
    }
  }
}
