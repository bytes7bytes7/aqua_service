import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../bloc/fabric_bloc.dart';
import '../screens/widgets/app_header.dart';
import '../model/fabric.dart';

class FabricInfoScreen extends StatefulWidget {
  const FabricInfoScreen({
    Key key,
    @required this.title,
    @required this.fabric,
    @required this.bloc,
  }) : super(key: key);

  final String title;
  final Fabric fabric;
  final FabricBloc bloc;

  @override
  _FabricInfoScreenState createState() => _FabricInfoScreenState();
}

class _FabricInfoScreenState extends State<FabricInfoScreen> {
  TextEditingController titleController;
  TextEditingController retailPriceController;
  TextEditingController purchasePriceController;
  String _title;

  @override
  void initState() {
    _title = widget.title;
    titleController = TextEditingController();
    retailPriceController = TextEditingController();
    purchasePriceController = TextEditingController();
    titleController.text = (widget.fabric != null) ? widget.fabric.title : '';
    retailPriceController.text =
        (widget.fabric.retailPrice != null) ? widget.fabric.retailPrice.toString() : '';
    purchasePriceController.text =
        (widget.fabric.purchasePrice != null) ? widget.fabric.purchasePrice.toString() : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool validateTitle = false,
        validateRetailPrice = false,
        validatePurchasePrice = false;
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        action: [
          if (widget.fabric.id != null)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () {
                  _showDeleteDialog(context, widget.fabric);
                }),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              validateTitle = titleController.text.length > 0;
              validateRetailPrice = retailPriceController.text.length > 0;
              validatePurchasePrice = purchasePriceController.text.length > 0;
              if (validateTitle &&
                  validateRetailPrice &&
                  validatePurchasePrice) {
                widget.fabric
                  ..title = titleController.text
                  ..retailPrice = double.parse(retailPriceController.text)
                  ..purchasePrice = double.parse(purchasePriceController.text);
                (widget.title != 'Новый Материал')
                    ? await DatabaseHelper.db.updateFabric(widget.fabric)
                    : await DatabaseHelper.db.addFabric(widget.fabric);
                widget.bloc.loadAllFabrics();
                setState(() {
                  _title = 'Материал';
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  duration: const Duration(seconds: 1),
                  content: Row(
                    children: [
                      Text(
                        (validateTitle &&
                                validateRetailPrice &&
                                validatePurchasePrice)
                            ? 'Сохранено!'
                            : 'Заполните поля со звездочкой',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      Icon(
                        (validateTitle &&
                                validateRetailPrice &&
                                validatePurchasePrice)
                            ? Icons.done_all_outlined
                            : Icons.warning_amber_outlined,
                        color: Theme.of(context).cardColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(
        fabric: widget.fabric,
        validateTitle: validateTitle,
        validateRetailPrice: validateRetailPrice,
        validatePurchasePrice: validatePurchasePrice,
        titleController: titleController,
        retailPriceController: retailPriceController,
        purchasePriceController: purchasePriceController,
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Fabric fabric) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Удаление',
            style: Theme.of(context).textTheme.headline2,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Удалить материал?',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Нет',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).cardColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Да',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(context).cardColor),
              ),
              onPressed: () {
                DatabaseHelper.db.deleteFabric(fabric.id);
                widget.bloc.loadAllFabrics();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _Body extends StatefulWidget {
  _Body({
    Key key,
    @required this.fabric,
    @required this.validateTitle,
    @required this.validateRetailPrice,
    @required this.validatePurchasePrice,
    @required this.titleController,
    @required this.retailPriceController,
    @required this.purchasePriceController,
  }) : super(key: key);

  final Fabric fabric;
  final bool validateTitle, validateRetailPrice, validatePurchasePrice;
  final TextEditingController titleController;
  final TextEditingController retailPriceController;
  final TextEditingController purchasePriceController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
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
                  controller: widget.titleController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Название *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    errorText: widget.validateTitle ? 'Заполните поле' : null,
                    errorStyle: Theme.of(context).textTheme.headline4,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.retailPriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Розничная цена *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    errorText: widget.validateRetailPrice ? 'Заполните поле' : null,
                    errorStyle: Theme.of(context).textTheme.headline4,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.purchasePriceController,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Закупочная цена *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    errorText: widget.validatePurchasePrice ? 'Заполните поле' : null,
                    errorStyle: Theme.of(context).textTheme.headline4,
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
                        ((widget.fabric != null &&
                                widget.fabric.retailPrice != null &&
                                widget.fabric.purchasePrice != null)
                            ? (widget.fabric.retailPrice -
                                    widget.fabric.purchasePrice).toStringAsFixed(2)
                                .toString()
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
