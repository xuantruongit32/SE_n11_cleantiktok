import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:clean_tiktok/widgets/addchannelform.dart';

void main() => runApp(Clean_TikTok());

class Clean_TikTok extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Clean Tiktok",
      home: Scaffold(
        persistentFooterButtons: <Widget>[
          FlatButton(
            child: Text("Visit Website"),
            onPressed: _launchURL,
          ),
        ],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          fixedColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Vote",
              icon: Icon(Icons.star),
            ),
            BottomNavigationBarItem(
              label: "Setting",
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        appBar: AppBar(
          title: Container(
            alignment: Alignment.center,
            child: Text(
              '  Clean TikTok',
            ),
          ),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 70),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Add channels',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(left: 70),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      'Add groups',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      print("You added groups");
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


