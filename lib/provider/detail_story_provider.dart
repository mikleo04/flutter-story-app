import 'package:flutter/material.dart';
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/db/api_service.dart';
import 'package:story_app/model/detail_story_response.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final String storyId;

  late DetailStoryResponse _detailStoryResponse;
  late ResultState _state;
  String _message = '';

  DetailStoryProvider(
      {required this.apiService, required this.storyId}) {
    fecthDeatilStory(storyId);
  }

  DetailStoryResponse get result => _detailStoryResponse;
  ResultState get state => _state;
  String get message => _message;

  Future<dynamic> fecthDeatilStory(String storyId) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final storyDetail = await apiService.getDetailStory(storyId);

      _state = ResultState.hasData;
      notifyListeners();

      return _detailStoryResponse = storyDetail;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
