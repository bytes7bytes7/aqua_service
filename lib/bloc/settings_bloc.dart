import 'dart:async';
import 'dart:io';

import '../model/settings.dart';
import '../repository/settings_repository.dart';

class SettingsBloc{
  SettingsBloc(this._repository);

  final SettingsRepository _repository;
  static StreamController _settingsStreamController;

  Stream<SettingsState> get settings {
    if (_settingsStreamController == null || _settingsStreamController.isClosed)
      _settingsStreamController = StreamController<SettingsState>();
    return _settingsStreamController.stream;
  }

  void dispose(){
    _settingsStreamController.close();
  }

  void loadAllSettings() async{
    _settingsStreamController.sink.add(SettingsState._settingsLoading());
    _repository.getSettings().then((settings) {
      Iterable<int> bytes;
      if(settings.icon!=null) {
        var hasLocalImage = File(settings.icon).existsSync();
        if (hasLocalImage) {
          bytes = File(settings.icon).readAsBytesSync();
        }
      }
      if(!_settingsStreamController.isClosed)
        _settingsStreamController.sink.add(SettingsState._settingsData(settings,bytes));
    });
  }

  Future updateSettings(Settings settings)async{
    _settingsStreamController.sink.add(SettingsState._settingsLoading());
    await _repository.updateSettings(settings).then((value) {
      loadAllSettings();
    });
  }

  void deleteAllData()async{
    _settingsStreamController.sink.add(SettingsState._settingsLoading());
    _repository.deleteAllData().then((value) {
      loadAllSettings();
    });
  }
}

class SettingsState {
  SettingsState();
  factory SettingsState._settingsData(Settings settings, Iterable<int> bytes) = SettingsDataState;
  factory SettingsState._settingsLoading() = SettingsLoadingState;
}

class SettingsInitState extends SettingsState{}

class SettingsLoadingState extends SettingsState {}

class SettingsDataState extends SettingsState{
  SettingsDataState(this.settings, this.bytes);
  final Settings settings;
  final Iterable<int> bytes;
}