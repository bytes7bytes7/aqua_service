import 'dart:io';

import 'package:aqua_service/bloc/bloc.dart';
import 'package:aqua_service/constants.dart';
import 'package:aqua_service/model/settings.dart';
import 'package:aqua_service/screens/widgets/rect_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/show_info_snack_bar.dart';
import 'widgets/app_header.dart';
import 'widgets/show_no_yes_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key key,
    @required this.settings,
  }) : super(key: key);

  final Settings settings;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController titleController;

  @override
  void initState() {
    titleController = TextEditingController(
        text: widget.settings.appTitle ?? ConstData.appTitle);
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppHeader(
        title: 'Настройки',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Theme.of(context).focusColor,
          ),
          onPressed: () {
            if (titleController.text != widget.settings.appTitle) {
              showNoYesDialog(
                context: context,
                title: 'Изменения будут утеряны',
                subtitle: 'Покинуть настройки?',
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
          IconButton(
            icon: Icon(
              Icons.done,
              color: Theme.of(context).focusColor,
            ),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              if (titleController.text.isNotEmpty) {
                widget.settings.appTitle = titleController.text;
                await Bloc.bloc.settingsBloc.updateSettings(widget.settings);
                Bloc.bloc.settingsBloc.loadAllSettings();
                showInfoSnackBar(
                    context: context,
                    info: 'Сохранено!',
                    icon: Icons.done_all_outlined);
              } else {
                showInfoSnackBar(
                    context: context,
                    info: 'Введите название',
                    icon: Icons.warning_amber_outlined);
              }
            },
          ),
        ],
      ),
      body: _Body(
        settings: widget.settings,
        titleController: titleController,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.settings,
    @required this.titleController,
  }) : super(key: key);

  final Settings settings;
  final TextEditingController titleController;

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

    return newPath;
  }

  @override
  void initState() {
    if (appDocPath == null) getApplicationDirectoryPath();
    if (widget.settings.icon != null) {
      var hasLocalImage = File(widget.settings.icon).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.settings.icon).readAsBytesSync();
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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0),
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 100, height: 100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    String path = await _getImage();
                    if (path != null) {
                      var hasLocalImage = File(path).existsSync();
                      if (hasLocalImage) {
                        bytes = File(path).readAsBytesSync();
                        widget.settings.icon = path;
                      }
                      setState(() {});
                    }
                  },
                  child: Container(
                    child: (widget.settings.icon != null && bytes != null)
                        ? Image.memory(bytes)
                        : Image.asset('assets/png/logo.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
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
            Spacer(),
            RectButton(
              text: 'Сбросить базу данных',
              onPressed: () {
                showNoYesDialog(
                  context: context,
                  title: 'Сброс базы данных',
                  subtitle: 'Удалить все данные?',
                  yesAnswer: () {
                    Bloc.bloc.settingsBloc.clearDatabase([
                      ConstDBData.clientTableName,
                      ConstDBData.fabricTableName,
                      ConstDBData.orderTableName,
                    ]);
                    Navigator.pop(context);
                  },
                  noAnswer: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            SizedBox(height: 5),
            RectButton(
              text: 'Сбросить иконку и название',
              onPressed: () {
                showNoYesDialog(
                  context: context,
                  title: 'Иконка и название',
                  subtitle: 'Поставить иконку и название по умолчанию?',
                  yesAnswer: () {
                    Bloc.bloc.settingsBloc.clearDatabase([ConstDBData.settingsTableName]);
                    widget.settings.icon = null;
                    widget.settings.appTitle = ConstData.appTitle;
                    bytes = null;
                    widget.titleController.text = ConstData.appTitle;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  noAnswer: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
