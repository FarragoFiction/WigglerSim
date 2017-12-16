import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import 'navbar.dart';

GameObject game;
void main() {
  loadNavbar();
  game = new GameObject();
  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  print("preload happened");
  Element container = new DivElement();
  container.style.display = "inline-block";
  querySelector('#output').append(container);
  if(game.player.petInventory.pets.isEmpty) {
    print("Starting your Wiggler Adventure");
    game.drawStarters(container);
    querySelector('#pkmnProf').style.display = "inline-block";
  }else {
    querySelector('#pkmnProf').style.display = "none";
    Element canvasContainer = new DivElement();
    querySelector('#you').append(canvasContainer);
    SpanElement playerSpield = new SpanElement();
    playerSpield.text = "...";
    playerSpield.classes.add("playerSpiel");
    querySelector('#you').append(playerSpield);
    game.drawPlayer(canvasContainer);

    game.drawPetInventory(container);

  }
}