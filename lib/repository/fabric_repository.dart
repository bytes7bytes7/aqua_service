import '../test_data.dart';
import '../model/fabric.dart';

class FabricRepository{
  Future<List<Fabric>> getAllFabrics()async{
    await Future.delayed(const Duration(seconds: 1));
    return testFabrics;
  }
}