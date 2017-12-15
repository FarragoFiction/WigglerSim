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
  await game.preloadManifest();
  Element container = new DivElement();
  container.style.display = "inline-block";
  querySelector('#output').append(container);
  await game.drawAGraduatingTroll(container);

}

