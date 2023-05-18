import 'package:flutter/material.dart';
import 'package:test/widgets/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _categoryNameController = TextEditingController();

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final String categoryName = _categoryNameController.text;
    print('Category Name: $categoryName');

    // Perform any additional logic or API calls with the category name
    // ...
     // Add category to the list
  List<String> categoryList = []; // Replace this with your existing list or retrieve it from Firebase
  categoryList.add(categoryName);
 // Get the current user's ID
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    String userId = user.uid;

    // Update the user's document in Firestore
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    userRef.get().then((snapshot) {
      if (snapshot.exists) {
        // User document exists, update the category list
        userRef.update({
          'categories': FieldValue.arrayUnion([categoryName]),
        }).then((_) {
          print('Category added successfully for user: $userId');
        }).catchError((error) {
          print('Failed to add category for user: $userId, Error: $error');
        });
      } else {
        // User document doesn't exist, create a new one
        userRef.set({
          'categories': [categoryName],
        }).then((_) {
          print('Category added successfully for user: $userId');
        }).catchError((error) {
          print('Failed to add category for user: $userId, Error: $error');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: (){
                  _submitForm();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

