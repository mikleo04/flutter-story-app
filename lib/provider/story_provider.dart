import 'package:flutter/material.dart';
import 'package:story_app/constant/result_state.dart';
import 'package:story_app/db/api_service.dart';
import 'package:story_app/model/detail_story_response.dart';
import 'package:story_app/model/list_story.dart';
import 'package:story_app/model/story_response.dart';

class StoryProvider extends ChangeNotifier {
  final ApiService apiService;
  late StoryResponse _storyResponse;
  late DetailStoryResponse _detailStoryResponse;
  late ResultState _state;
  String _message = '';

  int? pageItems = 1;
  int sizeItems = 10;

  StoryProvider({required this.apiService}) {
    _storyResponse = StoryResponse(error: false, message: '', listStory: []);
    fecthStories();
  }

  String get message => _message;

  StoryResponse get result => _storyResponse;
  DetailStoryResponse get resultDeyail => _detailStoryResponse;
  ResultState get state => _state;

  List<ListStory> listStories = [];

  Future<dynamic> fecthStories() async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final stories = await apiService.getStories(pageItems!, sizeItems);
      if (stories.listStory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        listStories.addAll(stories.listStory);

        if (stories.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }

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
