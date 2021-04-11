import 'dart:async';

import 'package:aqua_service/model/client.dart';
import 'package:aqua_service/repository/clients_repository.dart';

class ClientBloc {
  ClientBloc(this._repository);

  final ClientRepository _repository;
  final _clientStreamController = StreamController<ClientState>();

  Stream<ClientState> get client => _clientStreamController.stream;

  void dispose() {
    _clientStreamController.close();
  }

  void loadClient() {
    _clientStreamController.sink.add(ClientState._clientLoading());
    _repository.getClient().then((client) {
      _clientStreamController.sink.add(ClientState._clientData([client]));
    });
  }

  void loadAllClients(){
    _clientStreamController.sink.add(ClientState._clientLoading());
    _repository.getAllClients().then((clientsList) {
      _clientStreamController.sink.add(ClientState._clientData(clientsList));
    });
  }
}

class ClientState {
  ClientState();
  factory ClientState._clientData(List<Client> client) = ClientDataState;
  factory ClientState._clientLoading() = ClientLoadingState;
}

class ClientInitState extends ClientState {}

class ClientLoadingState extends ClientState{}

class ClientDataState extends ClientState {
  ClientDataState(this.clients);
  final List<Client> clients;
}