import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../screens/widgets/app_header.dart';
import 'global/next_page_route.dart';
import '../model/client.dart';

class ClientInfoScreen extends StatelessWidget {
  ClientInfoScreen({
    @required this.title,
    this.client,
  });

  final String title;
  final Client client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: title,
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
      body: _Body(client: client),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({Key key, this.client}) : super(key: key);

  final Client client;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  final images = [
    'assets/jpg/nature1.jpeg',
    'assets/jpg/nature2.jpg',
    'assets/jpg/nature3.jpg',
    'assets/jpg/nature4.jpg',
    'assets/jpg/nature5.jpg',
  ];

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
                CircleAvatar(
                  child: Icon(
                    Icons.image_search_outlined,
                    size: 30.0,
                  ),
                  radius: 50.0,
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: TextEditingController(
                      text: (widget.client != null) ? widget.client.name : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Имя',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                      text:
                          (widget.client != null) ? widget.client.surname : ''),
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
                  controller: TextEditingController(
                      text: (widget.client != null)
                          ? widget.client.middleName
                          : ''),
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
                  controller: TextEditingController(
                      text: (widget.client != null) ? widget.client.city : ''),
                  style: Theme.of(context).textTheme.bodyText1,
                  decoration: InputDecoration(
                    labelText: 'Город',
                    labelStyle: Theme.of(context).textTheme.headline3,
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).disabledColor),
                    ),
                  ),
                ),
                TextField(
                  controller: TextEditingController(
                      text:
                          (widget.client != null) ? widget.client.address : ''),
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
                  controller: TextEditingController(
                      text: (widget.client != null) ? widget.client.phone : ''),
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
                  controller: TextEditingController(
                      text:
                          (widget.client != null) ? widget.client.volume : ''),
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
                        'Посл. чистка : ${(widget.client != null) ? widget.client.previousDate : '-- -- --'}',
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
                        'След. чистка : ${(widget.client != null) ? widget.client.nextDate : '-- -- --'}',
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
            items: images.map((element) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    child: Hero(
                      tag: element,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                                backgroundColor: Theme.of(context).cardColor.withOpacity(0.6),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.delete,
                                    size: 18,
                                  ),
                                  color: Theme.of(context).focusColor,
                                  onPressed: () {
                                    _showDeleteDialog(images.indexOf(element), images);
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
                                        initialPage: images.indexOf(element),
                                        height: size.height,
                                        viewportFraction: 1.0,
                                        enlargeCenterPage: false,
                                        enableInfiniteScroll: false,
                                        // autoPlay: false,
                                      ),
                                      items: images
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
                                        color: Colors.black12.withOpacity(0.5),
                                      ),
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios_outlined,
                                              color:
                                                  Theme.of(context).focusColor,
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
                style: Theme.of(context).textTheme.bodyText1.copyWith(color:  Theme.of(context).cardColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Да',
                style: Theme.of(context).textTheme.bodyText1.copyWith(color:  Theme.of(context).cardColor),
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
}
