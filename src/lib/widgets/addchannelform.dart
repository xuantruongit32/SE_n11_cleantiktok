import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class AddChannel extends StatefulWidget {
  final List<String> categories;

  AddChannel({required this.categories});

  @override
  _AddChannelState createState() => _AddChannelState();
}

class _AddChannelState extends State<AddChannel> {
  dynamic _selectedCategory;

  final TextEditingController _channelUidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.isNotEmpty ? widget.categories[0] : null;
  }

  @override
  void dispose() {
    _channelUidController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final String channelUid = _channelUidController.text;
    print('Channel UID: $channelUid');
    print('Selected Category: $_selectedCategory');

    // Get the current user's ID
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;

      // Update the user's document in Firestore
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      userRef.get().then((snapshot) {
        if (snapshot.exists) {
          // User document exists, update the channel data
          userRef.update({
            'channels': FieldValue.arrayUnion([
              {
                'channelUid': channelUid,
                'category': _selectedCategory,
              }
            ]),
          }).then((_) {
            print('Channel added successfully for user: $userId');
          }).catchError((error) {
            print('Failed to add channel for user: $userId, Error: $error');
          });
        } else {
          // User document doesn't exist, create a new one
          userRef.set({
            'channels': [
              {
                'channelUid': channelUid,
                'category': _selectedCategory,
              }
            ],
          }).then((_) {
            print('Channel added successfully for user: $userId');
          }).catchError((error) {
            print('Failed to add channel for user: $userId, Error: $error');
          });
        }
      }).catchError((error) {
        print('Failed to access user document for user: $userId, Error: $error');
      });
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
Widget build(BuildContext context) {
  return Theme(
    data: ThemeData.dark(),
    child: Scaffold(
      appBar: AppBar(
        title: Text('Add Channel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _channelUidController,
              decoration: InputDecoration(
                labelText: 'Channel UID',
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: widget.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Category',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                if (_selectedCategory != null) {
                  _submitForm();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}

}

