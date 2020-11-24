import 'package:flutter/material.dart';
import 'package:flutter_poetry_text/widget/vertical_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "唐诗",
      home: Scaffold(
        appBar: AppBar(title: Text("唐诗")),
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backgroundImage(),
        verticalText(),
      ],
    );
  }

  Container backgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/jys.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Align verticalText() {
    return Align(
      alignment: Alignment(-0.7, -0.7),
      child: Container(
        height: 300,
        child: PoetryText(
          text: TextSpan(
            text: "床前明月光，疑似地上霜，举头望明月，低头思故乡。",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
      ),
    );
  }
}
