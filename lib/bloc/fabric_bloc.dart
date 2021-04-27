import 'dart:async';

import '../model/fabric.dart';
import '../repository/fabric_repository.dart';

class FabricBloc{
  FabricBloc(this._repository);

  final FabricRepository _repository;
  final StreamController _fabricStreamController = StreamController<FabricState>();

  Stream<FabricState> get fabric => _fabricStreamController.stream;

  void dispose(){
    _fabricStreamController.close();
  }

  void loadAllFabrics(){
    _fabricStreamController.sink.add(FabricState._fabricLoading());
    _repository.getAllFabrics().then((fabricList) {
      fabricList.sort((a,b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      if(!_fabricStreamController.isClosed)
      _fabricStreamController.sink.add(FabricState._fabricData(fabricList));
    });
  }

  void deleteFabric(int id) {
    _fabricStreamController.sink.add(FabricState._fabricLoading());
    _repository.deleteFabric(id).then((value) {
      loadAllFabrics();
    });
  }

  void updateFabric(Fabric fabric){
    _fabricStreamController.sink.add(FabricState._fabricLoading());
    _repository.updateFabric(fabric).then((value) {
      loadAllFabrics();
    });
  }

  void addFabric(Fabric fabric){
    _fabricStreamController.sink.add(FabricState._fabricLoading());
    _repository.addFabric(fabric).then((value) {
      loadAllFabrics();
    });
  }
}

class FabricState {
  FabricState();
  factory FabricState._fabricData(List<Fabric> fabrics) = FabricDataState;
  factory FabricState._fabricLoading() = FabricLoadingState;
}

class FabricInitState extends FabricState{}

class FabricLoadingState extends FabricState {}

class FabricDataState extends FabricState{
  FabricDataState(this.fabrics);
  final List<Fabric> fabrics;
}