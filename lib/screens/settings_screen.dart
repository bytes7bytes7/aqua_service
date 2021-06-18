import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/show_export_dialog.dart';
import '../widgets/rect_button.dart';
import '../widgets/show_info_snack_bar.dart';
import '../widgets/app_header.dart';
import '../widgets/show_no_yes_dialog.dart';
import '../bloc/bloc.dart';
import '../constants.dart';
import '../model/settings.dart';
import '../services/excel_helper.dart';

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
                Bloc.bloc.settingsBloc.updateSettings(widget.settings);
                showInfoSnackBar(
                  context: context,
                  info: 'Сохранено!',
                  icon: Icons.done_all_outlined,
                );
              } else {
                showInfoSnackBar(
                  context: context,
                  info: 'Введите название',
                  icon: Icons.warning_amber_outlined,
                );
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
  final ValueNotifier<String> appDocPath = ValueNotifier(null);
  Iterable<int> bytes;

  Future getApplicationDirectoryPath() async {
    Directory appDir = await ExcelHelper.getPhotosDirectory(context);
    appDocPath.value = appDir.path;
  }

  @override
  void initState() {
    if (appDocPath.value == null) getApplicationDirectoryPath();
    if (widget.settings.icon != null) {
      var hasLocalImage = File(widget.settings.icon).existsSync();
      if (hasLocalImage) {
        bytes = File(widget.settings.icon).readAsBytesSync();
      }
    }
    super.initState();
  }

  Future<String> _getImage() async {
    File _image;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    _image = File(pickedFile.path);
    String filename =
        pickedFile.path.substring(pickedFile.path.lastIndexOf('/') + 1);
    await _image.copy('${appDocPath.value}/$filename');
    String newPath = '${appDocPath.value}/$filename';
    return newPath;
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
            Stack(
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
                if (widget.settings.icon != null)
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
                            title: 'Удаление',
                            subtitle: 'Удалить иконку?',
                            noAnswer: () {
                              Navigator.of(context).pop();
                            },
                            yesAnswer: () {
                              widget.settings.icon = null;
                              Bloc.bloc.settingsBloc.updateSettings(widget.settings);
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
            SizedBox(height: 10),
            TextField(
              controller: widget.titleController,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Название *',
                labelStyle: Theme.of(context).textTheme.headline3,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            ValueListenableBuilder(
              valueListenable: appDocPath,
              builder: (context, _, __) {
                return TextField(
                  controller: TextEditingController(
                      text: appDocPath.value
                          ?.substring(0, appDocPath.value.lastIndexOf('/'))),
                  style: Theme.of(context).textTheme.bodyText1,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Папка приложения',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RectButton(
                    text: 'Импорт',
                    onPressed: () {
                      ExcelHelper.importFromExcel(context);
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: RectButton(
                    text: 'Экспорт',
                    onPressed: () {
                      showExportDialog(context: context);
                    },
                  ),
                ),
              ],
            ),
            Spacer(),
            RectButton(
              text: 'Удалить данные',
              onPressed: () {
                showNoYesDialog(
                  context: context,
                  title: 'Сброс базы данных',
                  subtitle: 'Удалить все данные?',
                  yesAnswer: () {
                    Bloc.bloc.settingsBloc.clearDatabase(['']);
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
