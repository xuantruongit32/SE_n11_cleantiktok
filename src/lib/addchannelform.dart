import 'package:flutter/material.dart';

class AddChannelForm extends StatefulWidget {
  @override
  _AddChannelFormState createState() => _AddChannelFormState();
}

class _AddChannelFormState extends State<AddChannelForm> {
  final _formKey = GlobalKey<FormState>();
  String? _channelName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Channel"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Channel name",
                  hintText: "Enter the channel name",
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please enter the channel name";
                  }
                  return null;
                },
                onSaved: (value) {
                  _channelName = value;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    Navigator.pop(context, _channelName);
                  }
                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

