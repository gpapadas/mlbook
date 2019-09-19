import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  // List<Face> _faces;
  VisionText _visionText;

  @override
  void initState() {
    super.initState();
    // FirebaseApp.initializeApp(this);
  }

  // final File imageFile =
  // final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);

  // Future _getImage() async {
  //   var image = await ImagePicker.pickImage(source: ImageSource.camera);

  //   setState(() {
  //     _image = image;
  //   });
  // }

  void _getImage() async {
    
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final image = FirebaseVisionImage.fromFile(imageFile);

    //final faceDetector = FirebaseVision.instance.faceDetector();

    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    // final faceDetector =
    //     FirebaseVision.instance.faceDetector(FaceDetectorOptions(
    //   mode: FaceDetectorMode.accurate,
    // ));

    final faces = await textRecognizer.processImage(image);
    // final faces = await faceDetector.processImage(image);
    if (this.mounted) {
      setState(() {
        _image = imageFile;
        // _faces = faces;
        _visionText = faces;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

          //title: Text(widget.title),
          ),
      body: _image == null ? Text('No image selected.') : TextFromImage(imageFile: _image, visionText: _visionText,),// ImagesAndFaces(imageFile: _image, faces: _faces,),
      // Center(
      //   child: _image == null ? Text('No image selected.') : Image.file(_image),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class ImagesAndFaces extends StatelessWidget {
  ImagesAndFaces({this.imageFile, this.faces});

  final File imageFile;
  final List<Face> faces;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
              constraints: BoxConstraints.expand(),
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              )),
        ),
        Flexible(
          flex: 1,
          child: ListView(
            children: faces.map<Widget>((f) => FaceCoordinates(f)).toList(),
          ),
        ),
      ],
    );
  }
}

class TextFromImage extends StatelessWidget {
  TextFromImage({this.imageFile, this.visionText});

  final imageFile;
  final visionText;

  void _getText() {
    String text = visionText.text;
    for (TextBlock block in visionText.blocks) {
      final Rect boundingBox = block.boundingBox;
      final List<Offset> cornerPoints = block.cornerPoints;
      final String text = block.text;
      final List<RecognizedLanguage> languages = block.recognizedLanguages;

      for (TextLine line in block.lines) {
        // Same getters as TextBlock
        var t = text;
        for (TextElement element in line.elements) {
          // Same getters as TextBlock
          var x = element.text;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates(this.face);

  final Face face;

  

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(Top: ${pos.top}, Left: ${pos.left}), (Bottom: ${pos.bottom}, Right: ${pos.right})'),
    );
  }
}
