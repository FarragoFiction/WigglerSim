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
  if(game.player.petInventory.pets.isEmpty) {
    print("Starting your Wiggler Adventure");
    game.drawStarters(container);
    querySelector('#pkmnProf').style.display = "inline-block";
  }else {
    game.drawPetInventory(container);
    querySelector('#pkmnProf').style.display = "none";

  }
}