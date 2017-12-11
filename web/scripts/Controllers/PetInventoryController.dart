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
  container.style.display = "inline-block";
  querySelector('#output').append(container);
  //TODO this is for testing, remove later.
  game.player.petInventory.addRandomGrub();
  game.player.petInventory.addRandomGrub();
  game.player.petInventory.addRandomGrub();

  game.drawPetInventory(container);
}