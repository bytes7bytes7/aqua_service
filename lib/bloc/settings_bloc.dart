import 'dart:async';
import 'dart:io';

import '../model/client.dart';
import '../model/fabric.dart';
import '../model/order.dart';
import '../model/settings.dart';
import '../repository/settings_repository.dart';

class SettingsBloc {
  SettingsBloc(this._repository);

  final SettingsRepository _repository;
  // ignore: close_sinks
  static StreamController? _settingsStreamController;

  Stream<SettingsState> get settings {
    if (_settingsStreamController == null || _settingsStreamController!.isClosed)
      _settingsStreamController = StreamController<SettingsState>.broadcast();
    return _settingsStreamController!.stream as Stream<SettingsState>;
  }

  void dispose() {
    if(_settingsStreamController != null && !_settingsStreamController!.isClosed) {
      _settingsStreamController!.close();
    }
  }

  void loadAllSettings() async {
    _settingsStreamController!.sink.add(SettingsState._settingsLoading());
    _repository.getSettings().then((settings) {
      Iterable<int>? bytes;
      if (settings.icon != null) {
        var hasLocalImage = File(settings.icon!).existsSync();
        if (hasLocalImage) {
          bytes = File(settings.icon!).readAsBytesSync();
        }
      }
      if (!_settingsStreamController!.isClosed)
        _settingsStreamController!.sink
            .add(SettingsState._settingsData(settings, bytes));
    }).onError((dynamic error, stackTrace) {
      if (!_settingsStreamController!.isClosed)
        _settingsStreamController!.sink.add(SettingsState._settingsError(error,stackTrace));
    });
  }

  void importExcel(List<Client> clients,
      List<Fabric> fabrics, List<Order> orders, Settings settings) async {
    _settingsStreamController!.sink.add(SettingsState._settingsLoading());
    await _repository.importExcel(clients,fabrics,orders, settings).then((value) {
      loadAllSettings();
    });
  }

  Future updateSettings(Settings settings) async {
    _settingsStreamController!.sink.add(SettingsState._settingsLoading());
    await _repository.updateSettings(settings).then((value) {
      loadAllSettings();
    });
  }

  void clearDatabase(List<String> dbName) async {
    _settingsStreamController!.sink.add(SettingsState._settingsLoading());
    _repository.clearDatabase(dbName).then((value) {
      loadAllSettings();
    });
  }
}

class SettingsState {
  SettingsState();

  factory SettingsState._settingsData(Settings settings, Iterable<int>? bytes) =
      SettingsDataState;

  factory SettingsState._settingsLoading() = SettingsLoadingState;

  factory SettingsState._settingsError(Error error,StackTrace stackTrace) = SettingsErrorState;
}

class SettingsInitState extends SettingsState {}

class SettingsLoadingState extends SettingsState {}

class SettingsErrorState extends SettingsState {
  SettingsErrorState(this.error,this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class SettingsDataState extends SettingsState {
  SettingsDataState(this.settings, this.bytes);

  final Settings? settings;
  final Iterable<int>? bytes;
}
