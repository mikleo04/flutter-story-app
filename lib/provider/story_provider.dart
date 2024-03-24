import 'package:flutter/material.dart';
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/db/api_service.dart';
import 'package:story_app/model/detail_story_response.dart';
import 'package:story_app/model/story_response.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  late StoryResponse _storyResponse;
  late DetailStoryResponse _detailStoryResponse;
  late ResultState _state;
  String _message = '';

  StoryProvider({required this.apiService}) {
    _storyResponse = StoryResponse(error: false, message: '', listStory: []);
    fecthStories();
  }

  String get message => _message;

  StoryResponse get result => _storyResponse;
  DetailStoryResponse get resultDeyail => _detailStoryResponse;
  ResultState get state => _state;

  Future<dynamic> fecthStories() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final stories = await apiService.getStories();
      if (stories.listStory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _storyResponse = stories;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
