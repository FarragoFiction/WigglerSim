import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
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

  Element subContainer = new DivElement();
  querySelector('#output').append(subContainer);
  game.drawSaveLink(subContainer);

  Element canvasContainer = new DivElement();
  Element introContainer = new DivElement();
  container.append(canvasContainer);
  container.append(introContainer);
  game.drawPlayer(canvasContainer);
  game.drawPlayerIntroShit(introContainer);

}

