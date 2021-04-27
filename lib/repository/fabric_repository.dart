import '../database/database_helper.dart';
import '../model/fabric.dart';

class FabricRepository{
  Future<List<Fabric>> getAllFabrics()async{
    return await DatabaseHelper.db.getAllFabrics();
  }

  Future deleteFabric(int id) async{
    await DatabaseHelper.db.deleteFabric(id);
  }

  Future updateFabric(Fabric fabric)async{
    await DatabaseHelper.db.updateFabric(fabric);
  }

  Future addFabric(Fabric fabric)async{
    await DatabaseHelper.db.addFabric(fabric);
  }
}