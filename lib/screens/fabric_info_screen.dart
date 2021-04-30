import 'package:flutter/material.dart';

import 'widgets/show_no_yes_dialog.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    retailPriceController.dispose();
    purchasePriceController.dispose();
    super.dispose();
  }

  void init() {
    widget.fabric.title = widget.fabric.title ?? '';
    widget.fabric.retailPrice = widget.fabric.retailPrice ?? 0.0;
    widget.fabric.purchasePrice = widget.fabric.purchasePrice ?? 0.0;

    titleController.text = widget.fabric.title;
    retailPriceController.text = widget.fabric.retailPrice.toString();
    purchasePriceController.text = widget.fabric.purchasePrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    init();
    bool validateTitle = false,
        validateRetailPrice = false,
        validatePurchasePrice = false,
        validateFormat = false;
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (titleController.text != widget.fabric.title ||
                retailPriceController.text !=
                    widget.fabric.retailPrice.toString() ||
                purchasePriceController.text !=
                    widget.fabric.purchasePrice.toString()) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть карту материала?',
                noAnswer: () {
                  Navigator.pop(context);
                },
                yesAnswer: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            } else {
              Navigator.pop(context);
            }
          },
        ),
        action: [
          if (widget.fabric.id != null)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).focusColor,
              ),
              onPressed: () {
                showNoYesDialog(
                  context: context,
                  title: 'Удаление',
                  subtitle: 'Удалить материал?',
                  noAnswer: () {
                    Navigator.of(context).pop();
                  },
                  yesAnswer: () {
                    widget.bloc.deleteFabric(widget.fabric.id);
                    widget.bloc.loadAllFabrics();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              validateFormat = true;
              validateTitle = titleController.text.length > 0;
              validateRetailPrice = retailPriceController.text.length > 0;
              validatePurchasePrice = purchasePriceController.text.length > 0;
              String first = retailPriceController.text,
                  second = purchasePriceController.text;
              for (int i = 0; i < first.length; i++) {
                if (!'.0123456789'.contains(first[i])) {
                  validateFormat = false;
                  break;
                }
              }
              for (int i = 0; i < second.length; i++) {
                if (!'.0123456789'.contains(second[i])) {
                  validateFormat = false;
                  break;
                }
              }
              if (first.indexOf('.') != first.lastIndexOf('.') ||
                  second.indexOf('.') != second.lastIndexOf('.')) {
                validateFormat = false;
              }
              if (validateTitle &&
                  validateRetailPrice &&
                  validatePurchasePrice &&
                  validateFormat) {
                widget.fabric
                  ..title = titleController.text
                  ..retailPrice = double.parse(retailPriceController.text)
                  ..purchasePrice = double.parse(purchasePriceController.text);
                (widget.fabric.id == null)
                    ? widget.bloc.addFabric(widget.fabric)
                    : widget.bloc.updateFabric(widget.fabric);
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
                                validatePurchasePrice &&
                                validateFormat)
                            ? 'Сохранено!'
                            : (validateTitle &&
                                    validateRetailPrice &&
                                    validatePurchasePrice)
                                ? 'Неверный формат числа'
                                : 'Заполните поля со звездочкой',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      Icon(
                        (validateTitle &&
                                validateRetailPrice &&
                                validatePurchasePrice &&
                                validateFormat)
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
        titleController: titleController,
        retailPriceController: retailPriceController,
        purchasePriceController: purchasePriceController,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.fabric,
    @required this.titleController,
    @required this.retailPriceController,
    @required this.purchasePriceController,
  }) : super(key: key);

  final Fabric fabric;
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
                                    widget.fabric.purchasePrice)
                                .toStringAsFixed(2)
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
