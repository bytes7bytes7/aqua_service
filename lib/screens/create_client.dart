import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'global/next_page_route.dart';

class CreateClientScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _AppBar(),
      body: _Body(),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(60.0);

  const _AppBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 4.0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        'Новый Клиент',
        style: Theme.of(context).textTheme.headline2,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Theme.of(context).focusColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _Body extends StatefulWidget {
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
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
                  controller: TextEditingController(),
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
                SizedBox(height: 50.0),
              ],
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 300.0,
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
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Image.asset(
                          element,
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        NextPageRoute(
                          nextPage: Scaffold(
                            body: Builder(
                              builder: (context) {
                                final double height =
                                    MediaQuery.of(context).size.height;
                                return CarouselSlider(
                                  options: CarouselOptions(
                                    initialPage: images.indexOf(element),
                                    height: height,
                                    viewportFraction: 1.0,
                                    enlargeCenterPage: false,
                                    enableInfiniteScroll: false,
                                    // autoPlay: false,
                                  ),
                                  items: images
                                      .map(
                                        (item) => Container(
                                          child: Center(
                                            child: Image.asset(
                                              item,
                                              fit: BoxFit.cover,
                                              height: height,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                );
                              },
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
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
