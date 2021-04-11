import '../test_data.dart';
import '../model/fabric.dart';
import 'repository.dart';

class FabricRepository extends Repository{
  Future<List<Fabric>> getAllFabrics()async{
    await Future.delayed(const Duration(seconds: 1));
    return testFabrics;
  }
}