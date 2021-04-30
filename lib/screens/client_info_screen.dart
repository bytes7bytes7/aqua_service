import 'dart:io';
import 'package:aqua_service/screens/global/show_info_snack_bar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../bloc/client_bloc.dart';
import '../screens/widgets/app_header.dart';
import 'global/next_page_route.dart';
import '../model/client.dart';
import 'widgets/show_no_yes_dialog.dart';

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
  Map<String, dynamic> changes = {};
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
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    middleNameController.dispose();
    cityController.dispose();
    addressController.dispose();
    phoneController.dispose();
    volumeController.dispose();
    super.dispose();
  }

  void init() {
    widget.client.name = widget.client.name ?? '';
    widget.client.surname = widget.client.surname ?? '';
    widget.client.middleName = widget.client.middleName ?? '';
    widget.client.city = widget.client.city ?? '';
    widget.client.address = widget.client.address ?? '';
    widget.client.phone = widget.client.phone ?? '';
    widget.client.volume = widget.client.volume ?? '';
    widget.client.images = widget.client.images ?? [];

    changes['avatarPath'] = widget.client.avatar;
    changes['imagesPath'] = List<String>.from(widget.client.images) ?? List<String>.from(null);

    nameController.text = widget.client.name;
    surnameController.text = widget.client.surname;
    middleNameController.text = widget.client.middleName;
    cityController.text = widget.client.city;
    addressController.text = widget.client.address;
    phoneController.text = widget.client.phone;
    volumeController.text = widget.client.volume;
  }

  @override
  Widget build(BuildContext context) {
    init();
    bool validateName = false, validateCity = false;
    return Scaffold(
      appBar: AppHeader(
        title: _title,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (nameController.text != widget.client.name ||
                surnameController.text != widget.client.surname ||
                middleNameController.text != widget.client.middleName ||
                cityController.text != widget.client.city ||
                addressController.text != widget.client.address ||
                phoneController.text != widget.client.phone ||
                volumeController.text != widget.client.volume ||
                changes['avatarPath'] != widget.client.avatar ||
                !ListEquality()
                    .equals(changes['imagesPath'], widget.client.images)) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть карту клиента?',
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
        action: (widget.bloc == null)
            ? [
                IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Theme.of(context).focusColor,
                  ),
                  tooltip: 'Режим чтения',
                  onPressed: () {},
                ),
              ]
            : [
                if (widget.client.id != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).focusColor,
                    ),
                    onPressed: () {
                      showNoYesDialog(
                        context: context,
                        title: 'Удаление',
                        subtitle: 'Удалить клиента?',
                        noAnswer: () {
                          Navigator.of(context).pop();
                        },
                        yesAnswer: () {
                          widget.bloc.deleteClient(widget.client.id);
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
                    validateName = nameController.text.length > 0;
                    validateCity = cityController.text.length > 0;
                    if (validateName && validateCity) {
                      widget.client
                        ..avatar = changes['avatarPath']
                        ..name = nameController.text
                        ..surname = surnameController.text
                        ..middleName = middleNameController.text
                        ..city = cityController.text
                        ..address = addressController.text
                        ..phone = phoneController.text
                        ..volume = volumeController.text
                        ..images = changes['imagesPath'];
                      if (widget.client.id == null) {
                        widget.bloc.addClient(widget.client);
                        setState(() {
                          _title = 'Клиент';
                        });
                      } else {
                        widget.bloc.updateClient(widget.client);
                      }
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
        readMode: widget.bloc == null,
        changes: changes,
        client: widget.client,
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
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.readMode,
    @required this.changes,
    @required this.client,
    @required this.nameController,
    @required this.surnameController,
    @required this.middleNameController,
    @required this.cityController,
    @required this.addressController,
    @required this.phoneController,
    @required this.volumeController,
  }) : super(key: key);

  final bool readMode;
  final Map<String, dynamic> changes;
  final Client client;
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
  Iterable<int> bytes;

  Future<void> getApplicationDirectoryPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDocPath = appDocDir.path;
  }

  @override
  void initState() {
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.changes['avatarPath'] != null) {
      var hasLocalImage = File(widget.changes['avatarPath']).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.changes['avatarPath']).readAsBytesSync();
      }
    }
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
                  child: ClipOval(
                    child: Material(
                      child: InkWell(
                        onTap: () async {
                          if (!widget.readMode) {
                            String path = await _getImage();
                            if (path != null) {
                              var hasLocalImage = File(path).existsSync();
                              if (hasLocalImage) {
                                bytes = File(path).readAsBytesSync();
                                widget.changes['avatarPath'] = path;
                              }
                              setState(() {});
                            }
                          } else
                            showInfoSnackBar(
                              context: context,
                              info: 'Режим чтения',
                              icon: Icons.warning_amber_outlined,
                            );
                        },
                        child: (widget.changes['avatarPath'] != null)
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: MemoryImage(bytes),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.image_search_outlined,
                                size: 30,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: widget.nameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
                  decoration: InputDecoration(
                    labelText: 'Имя *',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: widget.surnameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
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
                  enabled: !widget.readMode,
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
                  enabled: !widget.readMode,
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
                  enabled: !widget.readMode,
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
                  enabled: !widget.readMode,
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
                  enabled: !widget.readMode,
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
                        onPressed: () {
                          if (!widget.readMode) {
                            //TODO: do smth
                          } else
                            showInfoSnackBar(
                              context: context,
                              info: 'Режим чтения',
                              icon: Icons.warning_amber_outlined,
                            );
                        },
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
                        onPressed: () {
                          if (!widget.readMode) {
                            //TODO: do smth
                          } else
                            showInfoSnackBar(
                              context: context,
                              info: 'Режим чтения',
                              icon: Icons.warning_amber_outlined,
                            );
                        },
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
            items: List.generate(
              widget.changes['imagesPath'].length + 1,
              (index) {
                if (index == widget.changes['imagesPath'].length) {
                  return buildAddImage();
                } else {
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        child: Hero(
                          tag: widget.changes['imagesPath'][index],
                          child: Container(
                            width: double.infinity,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              border: Border.all(
                                  color: Theme.of(context).focusColor),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.memory(
                                    File(widget.changes['imagesPath'][index])
                                        .readAsBytesSync(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                if (!widget.readMode)
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
                                          showNoYesDialog(
                                            context: context,
                                            title: 'Удаление',
                                            subtitle: 'Удалить снимок?',
                                            noAnswer: () {
                                              Navigator.of(context).pop();
                                            },
                                            yesAnswer: () {
                                              widget.changes['imagesPath']
                                                  .removeAt(index);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          );
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
                                            initialPage: index,
                                            height: size.height,
                                            viewportFraction: 1.0,
                                            enlargeCenterPage: false,
                                            enableInfiniteScroll: false,
                                            // autoPlay: false,
                                          ),
                                          items: widget.changes['imagesPath']
                                              .map<Widget>(
                                                (item) => Center(
                                                  child: Image.memory(
                                                    File(item)
                                                        .readAsBytesSync(),
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
                                            color:
                                                Colors.black12.withOpacity(0.5),
                                          ),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back_ios_outlined,
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
                }
              },
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Future<String> _getImage() async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    _image = File(pickedFile.path);
    String filename =
        pickedFile.path.substring(pickedFile.path.lastIndexOf('/') + 1);
    await _image.copy('$appDocPath/$filename');
    String newPath = '$appDocPath/$filename';
    setState(() {});
    return newPath;
  }

  Widget buildAddImage() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (!widget.readMode) {
            String p = await _getImage() ?? '';
            var hasLocalImage = File(p).existsSync();
            if (hasLocalImage) {
              widget.changes['imagesPath'].add(p);
              setState(() {});
            }
          } else
            showInfoSnackBar(
              context: context,
              info: 'Режим чтения',
              icon: Icons.warning_amber_outlined,
            );
        },
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            border: Border.all(color: Theme.of(context).focusColor),
          ),
          child: Center(
            child: Icon(
              Icons.image_search_outlined,
              color: Theme.of(context).cardColor,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }
}
