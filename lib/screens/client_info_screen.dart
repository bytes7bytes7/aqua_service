import 'dart:io';
import 'package:aqua_service/services/excel_helper.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/show_info_snack_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/show_no_yes_dialog.dart';
import '../model/order.dart';
import '../model/client.dart';
import '../bloc/bloc.dart';
import 'global/next_page_route.dart';
import 'calendar_screen.dart';

class ClientInfoScreen extends StatefulWidget {
  ClientInfoScreen({
    required this.title,
    required this.client,
    this.readMode = false,
  });

  final String title;
  final Client client;
  final bool readMode;

  @override
  _ClientInfoScreenState createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController middleNameController;
  late TextEditingController cityController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController volumeController;
  late TextEditingController commentController;
  Map<String, dynamic> changes = {};
  late String _title;

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
    commentController = TextEditingController();

    widget.client.name = widget.client.name ?? '';
    widget.client.surname = widget.client.surname ?? '';
    widget.client.middleName = widget.client.middleName ?? '';
    widget.client.city = widget.client.city ?? '';
    widget.client.address = widget.client.address ?? '';
    widget.client.phone = widget.client.phone ?? '';
    widget.client.volume = widget.client.volume ?? '';
    widget.client.images = widget.client.images ?? [];
    widget.client.comment = widget.client.comment ?? '';

    changes['avatarPath'] = widget.client.avatar;
    changes['imagesPath'] =
        List<String>.from(widget.client.images!);

    nameController.text = widget.client.name!;
    surnameController.text = widget.client.surname!;
    middleNameController.text = widget.client.middleName!;
    cityController.text = widget.client.city!;
    addressController.text = widget.client.address!;
    phoneController.text = widget.client.phone!;
    volumeController.text = widget.client.volume!;
    commentController.text = widget.client.comment!;
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
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                commentController.text != widget.client.comment ||
                changes['avatarPath'] != widget.client.avatar ||
                !ListEquality()
                    .equals(changes['imagesPath'], widget.client.images)) {
              showNoYesDialog(
                context: context,
                title: '?????????????????? ?????????? ??????????????',
                subtitle: '???????????????? ?????????? ???????????????',
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
          if (widget.client.id != null && !widget.readMode)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).focusColor,
              ),
              onPressed: () {
                showNoYesDialog(
                  context: context,
                  title: '????????????????',
                  subtitle: '?????????????? ???????????????',
                  noAnswer: () {
                    Navigator.of(context).pop();
                  },
                  yesAnswer: () {
                    Bloc.bloc.clientBloc.deleteClient(widget.client.id!);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          if (!widget.readMode)
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
                    ..avatar = changes['avatarPath']
                    ..name = nameController.text
                    ..surname = surnameController.text
                    ..middleName = middleNameController.text
                    ..city = cityController.text
                    ..address = addressController.text
                    ..phone = phoneController.text
                    ..volume = volumeController.text
                    ..images = changes['imagesPath']
                    ..comment = commentController.text;
                  if (widget.client.id == null) {
                    await Bloc.bloc.clientBloc.addClient(widget.client);
                    setState(() {
                      _title = '????????????';
                    });
                  } else {
                    Bloc.bloc.clientBloc.updateClient(widget.client);
                  }
                }
                if (validateName && validateCity)
                  showInfoSnackBar(
                      context: context,
                      info: '??????????????????!',
                      icon: Icons.done_all_outlined);
                else
                  showInfoSnackBar(
                      context: context,
                      info: '?????????????????? ???????? ???? ????????????????????',
                      icon: Icons.warning_amber_outlined);
              },
            ),
        ],
      ),
      body: _Body(
        readMode: widget.readMode,
        changes: changes,
        client: widget.client,
        nameController: nameController,
        surnameController: surnameController,
        middleNameController: middleNameController,
        cityController: cityController,
        addressController: addressController,
        phoneController: phoneController,
        volumeController: volumeController,
        commentController: commentController,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key? key,
    required this.readMode,
    required this.changes,
    required this.client,
    required this.nameController,
    required this.surnameController,
    required this.middleNameController,
    required this.cityController,
    required this.addressController,
    required this.phoneController,
    required this.volumeController,
    required this.commentController,
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
  final TextEditingController commentController;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final DateFormat dateTimeFormat = DateFormat("dd.MM.yyyy");
  String? appDocPath;
  Iterable<int>? bytes;
  ValueNotifier<List<Order>?> orders = ValueNotifier(null);

  Future<void> getApplicationDirectoryPath() async {
    Directory? appDir = await ExcelHelper.getPhotosDirectory(context);
    if(appDir != null) {
      appDocPath = appDir.path;
    }
  }

  @override
  void initState() {
    getDates();
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.changes['avatarPath'] != null) {
      var hasLocalImage = File(widget.changes['avatarPath']).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.changes['avatarPath']).readAsBytesSync();
      }
    }
    super.initState();
  }

  Future<ValueNotifier> getDates() async {
    if (widget.client.id == null) return ValueNotifier(null);
    if (orders.value == null)
      orders.value = await widget.client.getDates(widget.client.id!);
    return orders;
  }

  _updateDateTime(DateTime dateTime) async {
    Order last = orders.value![0];
    Order next = orders.value![1];
    next.date = dateTimeFormat.format(dateTime);
    orders.value = [];
    orders.value = [last, next];
    Navigator.pop(context);
    Bloc.bloc.orderBloc.updateOrder(orders.value![1]);
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
                Stack(
                  children: [
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 100, height: 100),
                      child: ClipOval(
                        child: Material(
                          child: InkWell(
                            onTap: () async {
                              if (!widget.readMode) {
                                String? path = await _getImage();
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
                                    info: '?????????? ????????????',
                                    icon: Icons.warning_amber_outlined);
                            },
                            child: (widget.changes['avatarPath'] != null)
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: (File(widget.changes['avatarPath'])
                                            .existsSync())
                                        ? Image.memory(
                                            File(widget.changes['avatarPath'])
                                                .readAsBytesSync(),
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Theme.of(context)
                                                .errorColor
                                                .withOpacity(0.5),
                                            child: Center(
                                              child: Icon(
                                                Icons.error_outline_outlined,
                                                color: Theme.of(context)
                                                    .errorColor,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                  )
                                : Icon(
                                    Icons.image_search_outlined,
                                    size: 30,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    if (!widget.readMode &&
                        widget.changes['avatarPath'] != null)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              Theme.of(context).cardColor.withOpacity(0.6),
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
                                title: '????????????????',
                                subtitle: '?????????????? ?????????',
                                noAnswer: () {
                                  Navigator.of(context).pop();
                                },
                                yesAnswer: () {
                                  widget.changes['avatarPath'] = null;
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
                SizedBox(height: 20.0),
                TextField(
                  controller: widget.nameController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
                  decoration: InputDecoration(
                    labelText: '?????? *',
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
                    labelText: '??????????????',
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
                    labelText: '????????????????',
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
                    labelText: '?????????? *',
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
                    labelText: '??????????',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.phoneController,
                        style: Theme.of(context).textTheme.bodyText1,
                        enabled: !widget.readMode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '??????????????',
                          labelStyle: Theme.of(context).textTheme.headline3,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).disabledColor),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.phone,
                        color: Theme.of(context).focusColor,
                      ),
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (widget.phoneController.text != '')
                          launch("tel:${widget.phoneController.text}");
                        else
                          showInfoSnackBar(
                            context: context,
                            info: '?????????????????? ????????',
                            icon: Icons.warning_amber_outlined,
                          );
                      },
                    ),
                  ],
                ),
                TextField(
                  controller: widget.volumeController,
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: !widget.readMode,
                  decoration: InputDecoration(
                    labelText: '?????????? ??????????????????',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                ValueListenableBuilder(
                  valueListenable: orders,
                  builder: (context, dynamic snapshot, child) {
                    if (orders.value != null) {
                      widget.client.previousDate = orders.value![0].date;
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: double.infinity,
                      child: Text(
                        '????????. ???????????? : ${(widget.client.previousDate != null) ? widget.client.previousDate : '-- -- --'}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    );
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: orders,
                  builder: (context, dynamic snapshot, child) {
                    if (orders.value != null) {
                      widget.client.nextDate = orders.value![1].date;
                    }
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Text(
                            '????????. ???????????? : ${(widget.client.nextDate != null) ? widget.client.nextDate : '-- -- --'}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          Spacer(),
                          (orders.value != null && orders.value![1].id != null)
                              ? IconButton(
                            icon: Icon(
                              Icons.calendar_today_outlined,
                              color: Theme.of(context).focusColor,
                            ),
                            onPressed: () {
                              if (!widget.readMode) {
                                Navigator.push(
                                  context,
                                  NextPageRoute(
                                    nextPage: CalendarScreen(
                                        updateDate: _updateDateTime),
                                  ),
                                );
                              } else {
                                showInfoSnackBar(
                                    context: context,
                                    info: '?????????? ????????????',
                                    icon: Icons.warning_amber_outlined);
                              }
                            },
                          )
                              : SizedBox.shrink(),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 0.4 * MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                        width: 2.0, color: Theme.of(context).focusColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            controller: widget.commentController,
                            enabled: !widget.readMode,
                            decoration: InputDecoration(
                              hintText: "?????? ??????????????????????",
                              hintStyle: Theme.of(context).textTheme.headline3,
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.bodyText1,
                            scrollPadding: EdgeInsets.all(20.0),
                            keyboardType: TextInputType.multiline,
                            maxLines: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
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
                                  child:
                                      (File(widget.changes['imagesPath'][index])
                                              .existsSync())
                                          ? Image.memory(
                                              File(widget.changes['imagesPath']
                                                      [index])
                                                  .readAsBytesSync(),
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Theme.of(context)
                                                  .errorColor
                                                  .withOpacity(0.5),
                                              child: Center(
                                                child: Text(
                                                  '???? ??????????????',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                ),
                                              ),
                                            ),
                                ),
                                if (!widget.readMode)
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      radius: 18,
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
                                            title: '????????????????',
                                            subtitle: '?????????????? ?????????????',
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
                          if (File(widget.changes['imagesPath'][index])
                              .existsSync()) {
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
                                                .map<Widget>((item) {
                                              return Center(
                                                child: Image.memory(
                                                  File(item).readAsBytesSync(),
                                                  fit: BoxFit.contain,
                                                  height: size.height,
                                                ),
                                              );
                                            }).toList(),
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
                          } else {
                            showInfoSnackBar(
                              context: context,
                              info: '???????? ???? ??????????????',
                              icon: Icons.warning_amber_outlined,
                            );
                          }
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

  Future<String?> _getImage() async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    _image = File(pickedFile.path);
    String filename =
        pickedFile.path.substring(pickedFile.path.lastIndexOf('/') + 1);
    if (appDocPath != null) {
      String newPath = '$appDocPath/$filename';
      await _image.copy(newPath);
      setState(() {});
      return newPath;
    }
    return null;
  }

  Widget buildAddImage() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (!widget.readMode)
            ? () async {
                String p = await _getImage() ?? '';
                var hasLocalImage = File(p).existsSync();
                if (hasLocalImage) {
                  widget.changes['imagesPath'].add(p);
                  setState(() {});
                }
              }
            : () {
                showInfoSnackBar(
                    context: context,
                    info: '?????????? ????????????',
                    icon: Icons.warning_amber_outlined);
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
