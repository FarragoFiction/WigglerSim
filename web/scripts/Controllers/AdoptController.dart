import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
GameObject game;

Future<Null> main() async {
    loadNavbar();
    await Doll.loadFileData();

    game = new GameObject(true);

    querySelector("#npc").onClick.listen((e){

        window.location.href= "${window.location.href}?debug=eggs";
    });

    start();
}


Future<Null> start() async {
    await game.preloadManifest();
    Element container = new DivElement();
    container.style.display = "inline-block";
    querySelector('#output').append(container);
    if(game.player.petInventory.hasRoom) {
        game.drawAdoptables(container);
    }else {
        container.appendHtml("By Emperial Decree: You have no more room for wigglers! Let the ones you have already grow up first!");
    }
}