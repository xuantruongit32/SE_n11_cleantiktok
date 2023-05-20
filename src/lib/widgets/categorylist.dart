import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/channel.dart';
import '../models/video.dart';
import 'show_video.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final List<Channel> channels;
  final Map<String, List<Video>> map;

  CategoryList({required this.categories, required this.channels, required this.map});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  List<bool> toggles = [];
  List<List<Channel>> categoryChannels = [];

  @override
  void initState() {
    super.initState();
    toggles = List<bool>.generate(widget.categories.length, (index) => false);

    // Initialize the categoryChannels list with empty lists for each category
    categoryChannels = List<List<Channel>>.generate(
      widget.categories.length,
      (index) => [],
    );

    // Sort the channels into their respective categories
    for (var channel in widget.channels) {
      for (var i = 0; i < widget.categories.length; i++) {
        if (channel.category == widget.categories[i]) {
          categoryChannels[i].add(channel);
          break;
        }
      }
    }
  }

  @override
  void didUpdateWidget(CategoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.categories.length != toggles.length) {
      setState(() {
        toggles = List<bool>.generate(widget.categories.length, (index) => false);
        categoryChannels = List<List<Channel>>.generate(
          widget.categories.length,
          (index) => [],
        );

        // Sort the channels into their respective categories
        for (var channel in widget.channels) {
          for (var i = 0; i < widget.categories.length; i++) {
            if (channel.category == widget.categories[i]) {
              categoryChannels[i].add(channel);
              break;
            }
          }
        }
      });
    }
  }

  void _removeCategory(int index) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      try {
        // Remove the category from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'categories': FieldValue.arrayRemove([widget.categories[index]])
        });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          // User document exists, update the channel data
          List<dynamic> channels = snapshot.data()?['channels'];
          channels.removeWhere((channel) => channel['category'] == widget.categories[index]);
          snapshot.reference.update({'channels': channels});
        }
      });

        // Remove the category from the local list
        setState(() {
          widget.categories.removeAt(index);
          toggles.removeAt(index);
          categoryChannels.removeAt(index);
        });
      } catch (error) {
        print('Error removing category: $error');
      }
    }
  }
  void _removeChannel(String channelUid, int categoryIndex) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    try {
      // Remove the channel from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((snapshot) {
        if (snapshot.exists) {
          // User document exists, update the channel data
          List<dynamic> channels = snapshot.data()?['channels'];
          channels.removeWhere((channel) => channel['channelUid'] == channelUid);
          snapshot.reference.update({'channels': channels});
        }
      });

      // Remove the channel from the local list
      setState(() {
        categoryChannels[categoryIndex].removeWhere((channel) => channel.url == channelUid);
      });
    } catch (error) {
      print('Error removing channel: $error');
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final currentCategoryChannels = categoryChannels[index];

        return Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  toggles[index] = !toggles[index];
                });
                print(widget.categories[index]);
              },
              title: Row(
                children: [
                  Icon(Icons.arrow_drop_down),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.categories[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                    IconButton(
                  icon: Icon(
                    Icons.play_arrow,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // Perform play action for the category
                      List<Video>? nullvideos = widget.map[widget.categories[index]];
                      List<Video> videos = nullvideos ?? [];
                      if (videos.length > 0)
                       Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VideoList(videos: videos)));

                  },
                ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _removeCategory(index);
                    },
                  ),
                ],
              ),
            ),
            if (toggles[index])
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: currentCategoryChannels.length,
                itemBuilder: (context, channelIndex) {
                  final channel = currentCategoryChannels[channelIndex];
                  return ListTile(
                    leading: Icon(Icons.play_arrow),
                    title: Text(channel.url ?? ''),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _removeChannel(channel.url!, index);
                      },
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

