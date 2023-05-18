import 'package:flutter/material.dart';
import 'package:test/widgets/home_screen.dart';

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
    _selectedCategory = widget.categories[0]; // Set initial value to the first category
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

    // Perform any additional logic or API calls with the channel UID and category
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  _selectedCategory = newValue!;
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
                _submitForm();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

