import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";

GameObject game;
void main() {
  loadNavbar();
  game = new GameObject(true);

  querySelector("#npc").onClick.listen((e){

    window.location.href= "${window.location.href}?debug=signs";
  });

  if(getParameterByName("mode",null) == "edna") {
    ButtonElement button = new ButtonElement();
    button.text = ("Make Over Time!!!");
    button.onClick.listen((e)
    {
      game.makeOverAlumni();
      game.save();
      window.location.href = "${window.location.href}";
    });
    querySelector("#output").append(button);
  }

  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  Element container = new DivElement();
  container.style.display = "inline-block";
  querySelector('#output').append(container);
  if(game.player.petInventory.alumni.isEmpty) {
    container.setInnerHtml("You haven't raised any grubs, yet!");
  }else {
    game.drawAlumni(container);
  }
}