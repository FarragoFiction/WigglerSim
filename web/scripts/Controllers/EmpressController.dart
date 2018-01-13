import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/Empress.dart';
import "navbar.dart";

GameObject game;
void main() {
  loadNavbar();
  game = new GameObject(false);
  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  Element container = new DivElement();
  querySelector('#output').append(container);

  Empress.instance.drawDecrees(container);

}

