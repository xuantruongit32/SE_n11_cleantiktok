import 'package:flutter/material.dart';
import 'package:test/widgets/home_screen.dart';

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

