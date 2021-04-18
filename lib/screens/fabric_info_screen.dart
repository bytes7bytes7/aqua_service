import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';
import '../model/fabric.dart';

class FabricInfoScreen extends StatefulWidget {
  const FabricInfoScreen({
    Key key,
    @required this.title,
    this.fabric,
  }) : super(key: key);

  final String title;
  final Fabric fabric;

  @override
  _FabricInfoScreenState createState() => _FabricInfoScreenState();
}

class _FabricInfoScreenState extends State<FabricInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: widget.title,
        action: [
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: _Body(fabric: widget.fabric),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({
    Key key,
    @required this.fabric,
  }) : super(key: key);

  final Fabric fabric;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
            child: Column(
              children: [
                TextField(
                  controller: TextEditingController(
                      text: (fabric != null && fabric.title != null)
                          ? fabric.title
                          : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Название',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                      BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                      text: (fabric != null && fabric.retailPrice != null)
                          ? fabric.retailPrice.toString()
                          : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Розничная цена',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                      text: (fabric != null && fabric.purchasePrice != null)
                          ? fabric.purchasePrice.toString()
                          : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Закупочная цена',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Прибыль : ',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        ((fabric != null &&
                                fabric.retailPrice != null &&
                                fabric.purchasePrice != null)
                            ? (fabric.retailPrice - fabric.purchasePrice).toString()
                            : ''),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
               SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
