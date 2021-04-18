import 'dart:async';

import '../model/client.dart';
import '../repository/client_repository.dart';

class ClientBloc {
  ClientBloc(this._repository);

  final ClientRepository _repository;
  final _clientStreamController = StreamController<ClientState>();

  Stream<ClientState> get client => _clientStreamController.stream;

  void dispose() {
    _clientStreamController.close();
  }

  void loadAllClients(){
    _clientStreamController.sink.add(ClientState._clientLoading());
    _repository.getAllClients().then((clientList) {
      clientList.sort((a,b) => a.city.compareTo(b.city));
      if(!_clientStreamController.isClosed)
      _clientStreamController.sink.add(ClientState._clientData(clientList));
    });
  }
}

class ClientState {
  ClientState();
  factory ClientState._clientData(List<Client> clients) = ClientDataState;
  factory ClientState._clientLoading() = ClientLoadingState;
}

class ClientInitState extends ClientState {}

class ClientLoadingState extends ClientState{}

class ClientDataState extends ClientState {
  ClientDataState(this.clients);
  final List<Client> clients;
}