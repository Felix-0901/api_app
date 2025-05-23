import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "API APP",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String res = "";

  Future <void> fetchgetData() async {
    final url = Uri.parse('http://172.20.10.3:5001/secure-data');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer my_secret_key',
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("收到資料：${data['message']}");
      setState(() {
        res = data['message'];
      });
    } else {
      print("錯誤：${response.statusCode}");
      setState(() {
        res = "error";
      });
    }
  }

  Future<void> fetchpostData() async {
    final url = Uri.parse('http://172.20.10.3:5001/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer my_secret_key',

      },
      body: jsonEncode({
        'username': 'flutter',
        'password': '123456',
      }),
    );

    setState(() {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("收到資料：${data['message']}");
        res = data['message'];
      } else {
        final err = jsonDecode(response.body);
        print("錯誤：${err['message']}");
        res = "錯誤：${err['message']}";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize:  MainAxisSize.min,
          children: [
            Text(
              "response: $res",
              style: TextStyle(
                fontSize: 24,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    fetchgetData();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "GET",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  )
                ), 

                SizedBox(
                  width: 30,
                ),

                ElevatedButton(
                  onPressed: () {
                    fetchpostData();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "POST",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}