import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/client_bloc.dart';
import '../database/client_database.dart';
import '../screens/widgets/app_header.dart';
import 'global/next_page_route.dart';
import '../model/client.dart';

class ClientInfoScreen extends StatefulWidget {
  ClientInfoScreen({
    @required this.title,
    @required this.client,
    @required this.bloc,
  });

  final String title;
  final Client client;
  final ClientBloc bloc;

  @override
  _ClientInfoScreenState createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
  TextEditingController nameController;
  TextEditingController surnameController;
  TextEditingController middleNameController;
  TextEditingController cityController;
  TextEditingController addressController;
  TextEditingController phoneController;
  TextEditingController volumeController;
  String _title;

  @override
  void initState() {
    _title = widget.title;
    nameController = TextEditingController();
    surnameController = TextEditingController();
    middleNameController = TextEditingController();
    cityController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    volumeController = TextEditingController();
    nameController.text = (widget.client != null) ? widget.client.name : '';
    surnameController.text =
        (widget.client != null) ? widget.client.surname : '';
    middleNameController.text =
        (widget.client != null) ? widget.client.middleName : '';
    cityController.text = (widget.client != null) ? widget.client.city : '';
    addressController.text =
        (widget.client != null) ? widget.client.address : '';
    phoneController.text = (widget.client != null) ? widget.client.phone : '';
    volumeController.text = (widget.client != null) ? widget.client.volume : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool validateName = false, validateCity = false;
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        action: [
          if (widget.client.id != null)
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).focusColor,
                ),
                onPressed: () {
                  _showDeleteDialog(context, widget.client);
                }),
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              validateName = nameController.text.length > 0;
              validateCity = cityController.text.length > 0;
              if (validateName && validateCity) {
                widget.client
                  ..name = nameController.text
                  ..surname = surnameController.text
                  ..middleName = middleNameController.text
                  ..city = cityController.text
                  ..address = addressController.text
                  ..phone = phoneController.text
                  ..volume = volumeController.text;
                (widget.title != 'Новый Клиент')
                    ? await ClientDatabase.db.updateClient(widget.client)
                    : await ClientDatabase.db.addClient(widget.client);
                widget.bloc.loadAllClients();
                setState(() {
                  _title = 'Клиент';
                });
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  duration: const Duration(seconds: 1),
                  content: Row(
                    children: [
                      Text(
                        (validateName && validateCity)
                            ? 'Сохранено!'
                            : 'Заполните поля со звездочкой',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      Icon(
                        (validateName && validateCity)
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
        client: widget.client,
        validateName: validateName,
        validateCity: validateCity,
        nameController: nameController,
        surnameController: surnameController,
        middleNameController: middleNameController,
        cityController: cityController,
        addressController: addressController,
        phoneController: phoneController,
        volumeController: volumeController,
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Client client) async {
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
                  'Удалить клиента?',
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
                ClientDatabase.db.deleteClient(client.id);
                widget.bloc.loadAllClients();
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
  _Body(
      {Key key,
      @required this.client,
      @required this.validateName,
      @required this.validateCity,
      @required this.nameController,
      @required this.surnameController,
      @required this.middleNameController,
      @required this.cityController,
      @required this.addressController,
      @required this.phoneController,
      @required this.volumeController})
      : super(key: key);

  final Client client;
  final bool validateName, validateCity;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController middleNameController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final TextEditingController volumeController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  String appDocPath;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
    print('got');
  }

  @override
  void initState() {
    if(appDocPath==null)
      getApplicationDirectoryPath();
    super.initState();
  }

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
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 100, height: 100),
                  child: ElevatedButton(
                    child: Icon(
                      Icons.image_search_outlined,
                      size: 30,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      primary: Theme.of(context).focusColor.withOpacity(0.9),
                      onPrimary: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: widget.nameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Имя *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    errorText: widget.validateName ? 'Заполните поле' : null,
                    errorStyle: Theme.of(context).textTheme.headline4,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.surnameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Фамилия',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.middleNameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Отчество',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.cityController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Город *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.addressController,
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Адрес',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.phoneController,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Телефон',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.volumeController,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Объем аквариума',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'Посл. чистка : ${(widget.client.previousDate != null) ? widget.client.previousDate : '-- -- --'}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        'След. чистка : ${(widget.client.nextDate != null) ? widget.client.nextDate : '-- -- --'}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today_outlined,
                          color: Theme.of(context).focusColor,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: false,
              pageSnapping: true,
              viewportFraction: 0.9,
            ),
            items: (widget.client.images == null)
                ? [buildAddImage()]
                : widget.client.images.map((element) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          child: Hero(
                            tag: element,
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      element,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.6),
                                      child: IconButton(
                                        padding: const EdgeInsets.all(0),
                                        icon: Icon(
                                          Icons.delete,
                                          size: 18,
                                        ),
                                        color: Theme.of(context).focusColor,
                                        onPressed: () {
                                          _showDeleteDialog(
                                              widget.client.images
                                                  .indexOf(element),
                                              widget.client.images);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () {
                            final Size size = MediaQuery.of(context).size;
                            Navigator.push(
                              context,
                              NextPageRoute(
                                nextPage: Scaffold(
                                  body: Stack(
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          return CarouselSlider(
                                            options: CarouselOptions(
                                              initialPage: widget.client.images
                                                  .indexOf(element),
                                              height: size.height,
                                              viewportFraction: 1.0,
                                              enlargeCenterPage: false,
                                              enableInfiniteScroll: false,
                                              // autoPlay: false,
                                            ),
                                            items: widget.client.images
                                                .map(
                                                  (item) => Center(
                                                    child: Image.asset(
                                                      item,
                                                      fit: BoxFit.contain,
                                                      height: size.height,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        top: 0,
                                        child: SafeArea(
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 60,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              color: Colors.black12
                                                  .withOpacity(0.5),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_back_ios_outlined,
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(int index, List<String> images) async {
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
                  'Удалить снимок?',
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
                setState(() {
                  images.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAddImage() {
    File _image;

    Future _getImage() async {
      final picker = ImagePicker();
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      _image = File(pickedFile.path);
      final fileName = 'background_image';
      final File localImage = await _image.copy('$appDocPath/$fileName');
      setState(() {});
    }

    Image image;
    var hasLocalImage = File('$appDocPath/background_image').existsSync();
    if (hasLocalImage) {
      var bytes = File('$appDocPath/background_image').readAsBytesSync();
      image = Image.memory(bytes);
    }
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: Theme.of(context).focusColor),
      ),
      child: (File('$appDocPath/background_image').existsSync())
          ? Center(child: image)
          : Center(
              child: IconButton(
                icon: Icon(
                  Icons.image_search_outlined,
                  color: Theme.of(context).cardColor,
                  size: 30.0,
                ),
                onPressed: () {
                  _getImage();
                  print(appDocPath);
                },
              ),
            ),
    );
  }
}
