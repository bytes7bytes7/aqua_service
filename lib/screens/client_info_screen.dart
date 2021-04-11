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
                        'Посл. чистка: ${(widget.client != null) ? widget.client.previousDate : ''}',
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
                        'След. чистка: ${(widget.client != null) ? widget.client.nextDate : ''}',
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
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
