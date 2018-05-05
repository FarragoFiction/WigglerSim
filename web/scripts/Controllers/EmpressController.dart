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
  if(Empress.instance.allowsGambling()) {
    AnchorElement a = new AnchorElement(href: "blackJack.html");
    a.text = "Challenge the Empress to a Game For More Funds?";
    querySelector('#output').append(a);

  }
  Element container = new DivElement();
  querySelector('#output').append(container);

  Empress.instance.drawDecrees(container);

}

