import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'See Food',
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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _cameraController;
  bool isHotDog = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SEE FOOD'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ImageDetector(context),
        tooltip: 'Increment',
        child: Icon(Icons.camera),
      ),
      body: Column(
        children: <Widget>[
          AnimatedContainer(
            width: double.infinity,
            height: 100.0,
            color: isHotDog == null
                ? Colors.black
                : isHotDog == true ? Colors.green : Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Center(
                child: Text(
                  isHotDog == null
                      ? ""
                      : isHotDog == true ? "HOT DOG!" : "NOT HOT DOG!",
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
            ),
            duration: Duration(milliseconds: 400),
          ),
        ], // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future ImageDetector(BuildContext context) async {
    final path = await getTemporaryDirectory();
    print(path.path);
    await _cameraController.takePicture('/data/user/0/com.example.seafood/cache');
    final FirebaseVisionImage img = FirebaseVisionImage.fromFilePath(path.path);
    final ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    final List<ImageLabel> labels = await labeler.processImage(img);

    var i;
    for (i in labels) {
      if (i.toString() == 'Hot Dog')
        setState(
          () {
            isHotDog = true;
          },
        );
    }
  }
}
