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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList(videos: nullableVideos)));
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
    return Scaffold(
      appBar: AppBar(
        title: Text('CleanTiktok'),
        actions: [
            IconButton(onPressed: (){
                fetchData();
            }, icon: Icon(Icons.refresh)),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () => _handleLogout(context),
            ),
          ],
        ),
      ),
      body: CategoryList(
        categories: categories,
        channels: channels,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showAddOptions(context),
      ),
    );
  }
}

