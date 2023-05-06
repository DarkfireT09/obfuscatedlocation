import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<String> getLocation(int x, int y) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return '(${position.latitude + x}, ${position.longitude + y})';
    } else {
      return 'permission denied';
    }
  }

  List _getDistance(String location) {
    int d = int.parse(location);
    int min = (d * (1/100)).floor();
    int max = d - min;
    int x = (Random().nextInt(max) + min);
    d = sqrt(d*d - x*x).floor();
    min = (d * (1/100)).floor();
    max = d - min;
    int y = (Random().nextInt(max) + min);
    setState(() {});
    if (Random().nextInt(2) == 0) {
      x = -x;
    }
    if (Random().nextInt(2) == 0) {
      y = -y;
    }
    return [x, y];
  }
  String location = "";
  int x = 0;
  int y = 0;
  double? distance;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text(
                'IPlogger',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )
              )
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your location:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    FutureBuilder<String>(
                        future: getLocation(0, 0),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "${snapshot.error}",
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Center(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter a radius',
                    ),
                    onChanged: (text) {
                      location = text;
                    },
                  ),
                ),
              ),
            ),
            if (location != "") Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Obfuscated location:',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    FutureBuilder<String>(
                        future: getLocation(x, y),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data!,
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          } else if (snapshot.hasError) {
                            return Text(
                              "${snapshot.error}",
                              style: Theme.of(context).textTheme.headlineMedium,
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                ),
              ),
            ),
            if (location != "") Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text(
                        'Distance:',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '$distance',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5, left: 30),
            child: FloatingActionButton(
              onPressed: () {
                location = "";
                controller.text = "";
                setState(() {});
              },
              tooltip: 'Clear',
              child: const Icon(Icons.clear),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: FloatingActionButton(
              onPressed: () {
                List l = _getDistance(location);
                x = l[0];
                y = l[1];
                print("${x} + ${y}");
                distance = sqrt(x*x + y*y);
                setState(() {});
              },
              tooltip: 'Location',
              child: const Icon(Icons.location_on),
            ),
          ),
        ],
      )
    );
  }
}
