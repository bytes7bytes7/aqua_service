import '../database/database_helper.dart';
import '../model/fabric.dart';

class FabricRepository{
  Future<List<Fabric>> getAllFabrics()async{
    return await DatabaseHelper.db.getAllFabrics();
  }
}