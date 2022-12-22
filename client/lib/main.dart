import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const YellowBird(),
    );
  }
}

class YellowBird extends StatefulWidget {
  const YellowBird({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  State<YellowBird> createState() => _YellowBirdState();
}

class _YellowBirdState extends State<YellowBird> {
  var responseLen = 0;
  var templist = [];
  List<TextEditingController> myController = [
    for (int i = 1; i < 1001; i++) TextEditingController()
  ];
  List<int> hours = [for (int i = 1; i < 1001; i++) 0];
  String? batchVal;

  Future<void> _submit() async {
    String dataurl = "http://127.0.0.1:8000/courses/";
    var finalList = [
      for (int i = 0; i < templist.length; i++)
        {"course_id": templist[i]['course_id'], "newhours": hours[i]}
    ];
    var encodedBody = json.encode(finalList);
    http.Response response = await http.post(Uri.parse(dataurl),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: encodedBody);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the YellowBird object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Faculty Load Creator"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            onPressed: () {
              _submit();
            },
          ),
        ],
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List>(
        future: getData1(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data![i]['course_id'],
                          ),
                          Text(
                            snapshot.data![i]['credit'],
                          ),
                          SizedBox(
                            width: 65.0,
                            child: TextField(
                              controller: myController[i],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                setState(() {
                                  myController[i].text;
                                  hours[i] = (int.parse(myController[i].text) *
                                      (int.parse(snapshot.data![i]['credit']
                                                  .split('-')[0]) *
                                              1 +
                                          int.parse(snapshot.data![i]['credit']
                                                  .split('-')[1]) *
                                              1 +
                                          int.parse(snapshot.data![i]['credit']
                                              .split('-')[2])));
                                });
                              },
                              decoration:
                                  const InputDecoration(labelText: 'Batches'),
                            ),
                          ),
                          Container(
                              width: 50.0,
                              height: 30.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    myController[i].text == ""
                                        ? '0'
                                        : (int.parse(myController[i].text) *
                                                (int.parse(snapshot.data![i]
                                                                ['credit']
                                                            .split('-')[0]) *
                                                        1 +
                                                    int.parse(snapshot.data![i]
                                                                ['credit']
                                                            .split('-')[1]) *
                                                        1 +
                                                    int.parse(snapshot.data![i]
                                                            ['credit']
                                                        .split('-')[2])))
                                            .toString(),
                                    textAlign: TextAlign.center,
                                    // style: TextStyle(background: _paint),
                                  ))),
                        ]),
                  );
                });
          } else {
            return const Center(
              child: Text('No DATA FOUND'),
            );
          }
        },
      ),
    );
  }

  Future<List> getData1() async {
    String url = "http://127.0.0.1:8000/course/?format=json";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          responseLen = jsonDecode(response.body).length;
          templist = jsonDecode(response.body);
        });

        return jsonDecode(response.body);
      } else {
        return Future.error('Server Error');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
}
