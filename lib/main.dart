import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());
const MaterialColor yellow = MaterialColor(
  0xFFFFD195,
  <int, Color>{
    50: Color.fromRGBO(255, 209, 149, .1),
    100: Color.fromRGBO(255, 209, 149, .2),
    200: Color.fromRGBO(255, 209, 149, .3),
    300: Color.fromRGBO(255, 209, 149, .4),
    400: Color.fromRGBO(255, 209, 149, .5),
    500: Color.fromRGBO(255, 209, 149, .6),
    600: Color.fromRGBO(255, 209, 149, .7),
    700: Color.fromRGBO(255, 209, 149, .8),
    800: Color.fromRGBO(255, 209, 149, .9),
    900: Color.fromRGBO(255, 209, 149, 1),
  },
);
/*
MaterialColor yellowVintage = MaterialColor(0xFF880E4F,
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),

  50:Color.fromRGBO(255, 209, 149, .1),
  100:Color.fromRGBO(255, 209, 149, .2),
  200:Color.fromRGBO(255, 209, 149, .3),
  300:Color.fromRGBO(255, 209, 149, .4),
  400:Color.fromRGBO(255, 209, 149, .5),
  500:Color.fromRGBO(255, 209, 149, .6),
  600:Color.fromRGBO(255, 209, 149, .7),
  700:Color.fromRGBO(255, 209, 149, .8),
  800:Color.fromRGBO(255, 209, 149, .9),
  900:Color.fromRGBO(255, 209, 149, 1),


});

 */

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unverpackt',
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
        primarySwatch: yellow,
      ),
      home: MyHomePage(title: 'Unverpackt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String result = "Hey there !";

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  double screenHeight(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).height / dividedBy;
  }

  double screenWidth(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).width / dividedBy;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
        child: Material(
            child: CustomScrollView(
      slivers: <Widget>[
        const SliverAppBar(
          pinned: true,
          expandedHeight: 250,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('unverpackt'),
            background: Image(
              image: AssetImage('assets/pantry.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 250.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                color: Colors.lightBlue[100 * (index % 9)],
                padding: EdgeInsets.all(16.0),
                child: Card(
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      print('Card tapped.');
                    },
                    child: Container(
                      height: 200,
                      child: Image.asset('assets/unverpackt.jpeg',
                        scale: 0.5,
                        fit: BoxFit.fitWidth,)
                    ),
                  ),
                )
              );
            },
            childCount: 10,
          ),
        ),
      ],
    )));
  }
}
