import 'dart:async';

import '../model/client.dart';
import '../repository/client_repository.dart';

class ClientBloc {
  ClientBloc(this._repository);

  final ClientRepository _repository;
  // ignore: close_sinks
  static StreamController? _clientStreamController;

  Stream<ClientState> get client {
    if (_clientStreamController == null || _clientStreamController!.isClosed)
      _clientStreamController = StreamController<ClientState>();
    return _clientStreamController!.stream as Stream<ClientState>;
  }

  void dispose() {
    if(_clientStreamController != null  && !_clientStreamController!.isClosed) {
      _clientStreamController!.close();
    }
  }

  void loadAllClients() async {
    _clientStreamController!.sink.add(ClientState._clientLoading());
    _repository.getAllClients().then((clientList) {
      clientList
          .sort((a, b) => a.city!.toLowerCase().compareTo(b.city!.toLowerCase()));
      if (!_clientStreamController!.isClosed)
        _clientStreamController!.sink.add(ClientState._clientData(clientList));
    }).onError((dynamic error, stackTrace) {
      if (!_clientStreamController!.isClosed)
        _clientStreamController!.sink.add(ClientState._clientError(error,stackTrace));
    });
  }

  void deleteClient(int id) async{
    _clientStreamController!.sink.add(ClientState._clientLoading());
    _repository.deleteClient(id).then((value) {
      loadAllClients();
    });
  }

  void updateClient(Client client) async{
    _clientStreamController!.sink.add(ClientState._clientLoading());
    _repository.updateClient(client).then((value) {
      loadAllClients();
    });
  }

  Future addClient(Client client) async{
    _clientStreamController!.sink.add(ClientState._clientLoading());
    await _repository.addClient(client).then((value) {
      loadAllClients();
    });
  }

}

class ClientState {
  ClientState();

  factory ClientState._clientData(List<Client> clients) = ClientDataState;

  factory ClientState._clientLoading() = ClientLoadingState;

  factory ClientState._clientError(Error error, StackTrace stackTrace) = ClientErrorState;
}

class ClientInitState extends ClientState {}

class ClientLoadingState extends ClientState {}

class ClientErrorState extends ClientState {
  ClientErrorState(this.error, this.stackTrace);

  final Error error;
  final StackTrace stackTrace;
}

class ClientDataState extends ClientState {
  ClientDataState(this.clients);

  final List<Client> clients;
}
