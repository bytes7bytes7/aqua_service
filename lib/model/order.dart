import 'package:flutter/material.dart';

import '../model/client.dart';

class Order {
  Order({
    @required this.client,
    @required this.date,
    this.done = false,
    this.comment='',
  });

  final Client client;
  final String date;
  final bool done;
  final String comment;
}
