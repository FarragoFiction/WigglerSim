import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
GameObject game;

Future<Null> main() async{
    loadNavbar();
    await Doll.loadFileData();

    game = new GameObject(true);
    start();
}


Future<Null> start() async {
    Element container = new DivElement();
    container.style.display = "inline-block";
    querySelector('#output').append(container);
    game.drawShop(container);
}