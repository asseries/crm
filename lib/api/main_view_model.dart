import 'dart:async';

import 'package:crm/model/audio_response.dart';
import 'package:stacked/stacked.dart';

import '../model/login_response.dart';
import '../utils/pref_utils.dart';
import 'api_service.dart';

class MainViewModel extends BaseViewModel {
  final api = ApiService();
  final StreamController<String> _errorStream = StreamController();

  Stream<String> get errorData {
    return _errorStream.stream;
  }

  final StreamController<AudioResponse> _audioStream = StreamController();

  Stream<AudioResponse> get audioStream {
    return _audioStream.stream;
  }

  final StreamController<LoginResponse> _loginConfirmStream = StreamController();

  Stream<LoginResponse> get loginConfirmData {
    return _loginConfirmStream.stream;
  }

  var progressData = false;

  void sendAudio(String fullPath, String number,int date) async {
    progressData = true;
    notifyListeners();
    final data = await api.sendAudio(fullPath, number,date, _errorStream);
    if (data != null) {
      _audioStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  void login(String username, String password) async {
    progressData = true;
    notifyListeners();
    final data = await api.login(username, password, _errorStream);
    if (data != null) {
      PrefUtils.setToken(data.token);
      PrefUtils.setUser(data);
      _loginConfirmStream.sink.add(data);
    }
    progressData = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _errorStream.close();
    super.dispose();
  }
}
