import 'package:meta/meta.dart';

class Fabric {
  Fabric({
    @required this.title,
    this.retailPrice,
    this.purchasePrice,
  });

  final String title;
  final double retailPrice;
  final double purchasePrice;
}
