import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';

GameObject game;
void main() {
  game = new GameObject();
  start();
}

Future<Null> start() async {
  Element container = new DivElement();
  querySelector('#output').append(container);

  Element canvasContainer = new DivElement();
  Element introContainer = new DivElement();
  container.append(canvasContainer);
  container.append(introContainer);
  game.drawPlayer(canvasContainer);
  game.drawPlayerIntroShit(introContainer);
  game.drawSaveLink(introContainer);
}

