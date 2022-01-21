
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' ;
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_browser/flutter_web_browser.dart';
class RSSFeed extends StatefulWidget {
  const RSSFeed({key}) : super(key: key);

  @override
  _RSSFeedState createState() => _RSSFeedState();
}

class _RSSFeedState extends State<RSSFeed> {
    String feed_url = "https://medium.com/feed/@cepstrumeeeiitg";
   String loadingfieldmsg = "LOADING FEED wait";
  String errormsg = "ERROR LOADING FEED wait";
  late GlobalKey<RefreshIndicatorState> _refreshKey;
  late RssFeed _feed;
  late String _title;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed)  {
    setState(() {
       _feed = feed;

    });
  }

  Future<void> openFeed(String url) async {
      try {
        //await launch(url);
        await FlutterWebBrowser.openWebPage(url: url);
         //WebBrowser( initialUrl: url,);
      }
      catch (e) {
        updateTitle("Error opening feed");
      }

  }
  load() async {
    updateTitle(loadingfieldmsg);
     loadFeed().then((result) {
      if (null == result || result
          .toString()
          .isEmpty) {
        updateTitle(errormsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client =  http.Client();
      final response = await client.get(Uri.parse(feed_url));

      return  RssFeed.parse(response.body);
    } catch (e) {

    }

  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100,color: Colors.black),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(url) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: Image(image: AssetImage('images/img.png'),
        height: 40,
        width: 50,
        alignment: Alignment.center,
        fit:BoxFit.fill,)
      // CachedNetworkImage(
      //     placeholder: (context, url) => Image.asset('images/img.png'),
      //     imageUrl: url,
      //     height: 40,
      //     width: 50,
      //     alignment: Alignment.center,
      //     fit: BoxFit.fill
      //
      // ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed.items!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items![index];
        return ListTile(
          title: title(item.title),
          subtitle: subtitle(item.pubDate.toString()),
          leading: thumbnail("pawaneet"),
          trailing: rightIcon(),
          contentPadding: EdgeInsets.all(10.0),
          onTap: () {
            openFeed(item.guid.toString());
          },
        );
      },
    );
  }

  isFeedEmpty() {
    return (_feed==null || _feed.items == null);
  }

  body() {
    return isFeedEmpty() ? Center(
      child: CircularProgressIndicator(),
    ) : RefreshIndicator(
        key: _refreshKey, child: list(), onRefresh: () => load().whenComplete((){
          setState(() {

          });
    }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle("blog app");
      load();
    }
    @override
    Widget build(BuildContext context) {
    print(_feed);
      return Scaffold(
        appBar: AppBar(title: Text(_title),),
        body: body(),
      );
    }
  }

