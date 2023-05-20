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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> categories = [];
  List<Channel> channels = [];
  Map<String,List<Video>> nullableVideos = {};


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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddChannel(categories: categories)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Category'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCategory()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.pause),
                title: Text('Play video'),
                onTap: (){
                    List<Video>? categoryVideo = nullableVideos["Food"];
                    List<Video> nonNullCategoryVideo = categoryVideo ?? [];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(videos: nonNullCategoryVideo)));
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
        title: Text('Home'),
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
                        'https://example.com/profile_picture.jpg',
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

