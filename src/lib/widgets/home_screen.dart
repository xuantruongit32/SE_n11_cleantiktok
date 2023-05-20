import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'addchannelform.dart';
import 'addcategory.dart';
import 'signin.dart';
import 'categorylist.dart';
import '../models/channel.dart';
import '../network/network.dart';
import 'show_video.dart';
import "../models/video.dart";
import 'dart:async';

class HomeScreen extends StatefulWidget {
  final int time;
  HomeScreen({required this.time});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  List<Channel> channels = [];
  Map<String,List<Video>> nullableVideos = {};
  late int countdownTime;
  late Timer countdownTimer;

  void startCountdown() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (countdownTime > 0) {
          countdownTime--;
        } else {
          timer.cancel();
          _handleLogout(context);
        }
      });
    });
  }
  @override
    void dispose() {
    countdownTimer.cancel();
    super.dispose();
  }
  Future<void> fetchData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        List<String> fetchedCategories =
            (userSnapshot.data() as Map<String, dynamic>?)?['categories']
                ?.cast<String>()
                ?.toList() ??
            [];
        for (var category in fetchedCategories){
            nullableVideos[category] = [];
        }
        if (userSnapshot.exists) {
          List<Map<String, dynamic>> fetchedChannels =
              (userSnapshot.data() as Map<String, dynamic>?)?['channels']
                  ?.cast<Map<String, dynamic>>()
                  ?.toList() ??
                  [];
          List<Channel> fetchedData = [];
          for (var channelData in fetchedChannels) {
            String category = channelData['category'] ?? '';
            String channelUid = channelData['channelUid'] ?? '';
            Channel channel = Channel(category: category, url: channelUid);
            ApiService api =ApiService(channel: channelUid);
            List<Video> videos = await api.fetchVideos();
            nullableVideos[category]!.addAll(videos);
            fetchedData.add(channel);
          }

          setState(() {
            channels = fetchedData;
            categories = fetchedCategories;
          });
        }
      }
    }
    print("NNNNNNNNNNNNNNNNNNNNNNNNN");
    print(channels.length);
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Channel'),
                onTap: () {
                  int saveTime = countdownTime;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddChannel(categories: categories, saveTime: saveTime,)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Category'),
                onTap: () {
                  int saveTime = countdownTime;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCategory(saveTime: saveTime)),
                  );
                },
              ),
           ],
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) {
      print("Signed Out");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  @override
  void initState() {
    countdownTime = widget.time;
    startCountdown();
    super.initState();
    fetchData();
  }


  @override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        color: Colors.black,
      ),
      primaryColor: Colors.deepPurple,
    ),
    home: Scaffold(
      appBar: AppBar(
        title: Text('Countdown: $countdownTime'),
        actions: [
          IconButton(
            onPressed: () {
              fetchData();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data != null) {
                  final userData = snapshot.data!.data() as Map<String, dynamic>?;
                  final nickname = userData?['nickname'] as String?;
                  final totalChannels = channels.length;
                  final totalCategories = categories.length;
                  return UserAccountsDrawerHeader(
                    accountName: Text(nickname ?? ''),
                    accountEmail: Text(''),
                    currentAccountPicture: CircleAvatar(
                      // Add your user profile picture here
                      backgroundImage: NetworkImage(
                        'https://avatars.githubusercontent.com/u/88026544?s=400&u=84cb671c683412051602361b38bcf147bcfe0285&v=4',
                      ),
                    ),
                  );
                }
                return Center(child: Text('Error'));
              },
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Total Channels: ${channels.length}'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Total Categories: ${categories.length}'),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
      body: CategoryList(
        categories: categories,
        channels: channels,
        map: nullableVideos,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddOptions(context),
      ),
    ),
  );
}


}

