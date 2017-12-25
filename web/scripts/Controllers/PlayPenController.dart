import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPen.dart';

import "navbar.dart";

GameObject game;
PlayPen playPen;
void main() {
    //loadNavbar();
    game = new GameObject();
    DivElement container = new DivElement();
    querySelector("#output").append(container);
    playPen = new PlayPen(container);
    start();
}

Future<Null> start() async {
    //button is just for testing, will be animation later
    ButtonElement b = new ButtonElement();
    b.text = "Draw";
    b.onClick.listen((e)
    {
        playPen.draw();
    });
    querySelector("#output").append(b);

}