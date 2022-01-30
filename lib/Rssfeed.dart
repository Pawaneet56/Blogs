
// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
 import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:progress_dialog/progress_dialog.dart';
class RssFeed extends StatefulWidget {
  const RssFeed({Key? key}) : super(key: key);

  @override
  _RssFeedState createState() => _RssFeedState();
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
class _RssFeedState extends State<RssFeed> {
  List _feeds=[];
  var heading;
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/medium.json');
    final data = await json.decode(response);
    setState((){
    _feeds=data["items"];
    heading=data["feed"];
    });
  }
  Future<void> openFeed(String url) async {
      try {
        //await launch(url);
        await FlutterWebBrowser.openWebPage(url: url);
         //WebBrowser( initialUrl: url,);
      }
      catch (e) {

      }

  }
  subtitle(subTitle) {
    return Text(
       subTitle,
       style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100,color: Colors.black),
       maxLines: 1,
       overflow: TextOverflow.ellipsis,
    );
   }
  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }
  thumbnail(url) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Image.network(url,width : 100.0,height : 200.0),
      // child: Image(image: AssetImage('assets/images/img.png'),
      //   height: 40,
      //   width: 50,
      //   alignment: Alignment.center,
      //   fit:BoxFit.fill,)
      //
    );
  }
  @override
  Widget build(BuildContext context) {
    readJson();
    String Title="Pawaneet";
    String subTitle="Wait while screen is loading";

    if(heading!=null){
      Title=heading["title"];
      subTitle=heading["description"];
    }
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      title: Title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(subTitle),
        ),
        body: ListView.builder(
          itemCount: _feeds.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_feeds[index]["title"]}'),
              subtitle: subtitle(_feeds[index]["pubDate"].toString()),
              leading: thumbnail(_feeds[index]["thumbnail"]),
                          trailing: rightIcon(),
           contentPadding: EdgeInsets.all(10.0),
          onTap: () {
             openFeed(_feeds[index]["guid"].toString());
          },

            );
          },
        ),
      ),
    );
  }
}
