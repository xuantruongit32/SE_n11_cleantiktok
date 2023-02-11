import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(Clean_TikTok());


class Clean_TikTok extends StatelessWidget{
    @override
    Widget build(BuildContext context){
        return MaterialApp(
            title: "Clean Tiktok",
            home: Scaffold(
                drawer: Drawer(
                    child: ListView(
                        children: <Widget> [
                            DrawerHeader(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    shape: BoxShape.rectangle,
                                    color: Colors.white,
                                    ),
                                child: Center(
                                    child: Text(
                                        'Clean Tiktok',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            ),
                                        ),
                                    ),

                                ),
                            ListTile(
                                title: Text(
                                    'Home',
                                    ),
                                leading: Icon(Icons.home),

                                ),
                            ListTile(
                                title: Text(
                                    'Vote',
                                    ),
                                leading: Icon(Icons.star),
                                ),
                            ListTile(
                                title: Text(
                                    'Setting',
                                    ),
                                leading: Icon(Icons.settings),
                                ),
                        ],
                        ),
                    ),
                    persistentFooterButtons: <Widget> [
                        Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Expanded(
                                        child: Container(
                                        color: Colors.blue,
                                        child: ElevatedButton.icon(
                                            icon: Icon(
                                                Icons.add,
                                                color: Colors.white),
                                            label: Text('Add channels',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            ),),
                                            onPressed: () {
                                                print("You added channels");
                                            },
                                            ),
                                            ),
                                        ),
                                    Expanded(
                                        child: Container(
                                        color: Colors.blue,
                                        child: ElevatedButton.icon(
                                            icon: Icon(
                                                Icons.add,
                                                color: Colors.white),
                                            label: Text('Add groups',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            ),),
                                            onPressed: (){
                                                print("You added groups");
                                            },
                                            ),
                                            ),
                                    ),
                                ],
                                ),
                            ),
                    ],

                appBar: AppBar(
                    title: Container(
                        alignment: Alignment.center,
                        child: Text('Clean TikTok',),
                        ),
                    ),
                body: Center(
                    child: Text(''),
                    ),
                ),
                );
    }
}
