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

  ButtonElement deleteButton = new ButtonElement();
  deleteButton.text = "Reset Game";
  container.append(deleteButton);
  deleteButton.onClick.listen((e) {
    if(window.confirm("Do you want to reset your game? If you don't have a back up, this is permanent.")) {
      game.reset();
    }
  });

}

