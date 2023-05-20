import 'package:flutter/material.dart';
import 'home_screen.dart';

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              'Time is money:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(time: 5*60),
                  ),
                );
                    },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Customize button color
                  ),
                  child: Text('5 min'),
                ),
                ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(time: 10*60),
                  ),
                );
                    },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow, // Customize button color
                  ),
                  child: Text('10 min'),
                ),
                ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(time: 15*60),
                  ),
                );
                    },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange, // Customize button color
                  ),
                  child: Text('15 min'),
                ),
                ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(time: 20*60),
                  ),
                );
                    },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Customize button color
                  ),
                  child: Text('20 min'),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}

