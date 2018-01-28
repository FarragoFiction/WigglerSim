import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";

GameObject game;
void main() {
  loadNavbar();
  game = new GameObject(true);
  start();
}

Future<Null> start() async {
  await game.preloadManifest();

  Element container = new DivElement();
  container.style.display = "inline-block";
  querySelector('#output').append(container);
    game.drawSigns(container);
}