import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/model/detail_story_response.dart';
import 'package:story_app/model/login_response.dart';
import 'package:story_app/model/story_response.dart';
import 'package:story_app/model/user.dart';

class ApiService {
  final http.Client client;

  ApiService(this.client);

  static const String _baseUrl = "https://story-api.dicoding.dev/v1";

  Future<String?> getTokenFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> register(User user) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        body: jsonEncode({
          'name': user.name,
          'email': user.email,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        // print("Register fail ${response.statusCode}");
        return false;
      }
    } catch (error) {
      // print('Error registering user: $error');
      return false;
    }
  }

  Future<LoginResponse> login(User user) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception("failed login");
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<StoryResponse> getStories([int page = 1, int size = 10]) async {
    String? token = await getTokenFromPreferences();

    final response = await client.get(
      Uri.parse('$_baseUrl/stories?page=$page&size=$size'),
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
      Uri.parse('$_baseUrl/stories/$storyId'),
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

  Future<bool> postStory(String description, List<int> imageData,
      String imageName, double? lat, double? lon) async {
    try {
      String? token = await getTokenFromPreferences();

      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/stories'));

      request.files.add(http.MultipartFile.fromBytes('photo', imageData,
          filename: imageName));

      request.fields['description'] = description;

      if (lat != null) request.fields['lat'] = '$lat';
      if (lon != null) request.fields['lon'] = '$lon';

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
