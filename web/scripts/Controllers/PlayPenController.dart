import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPenLib.dart';


import "navbar.dart";

GameObject game;
PlayPen playPen;
int frameRate = 100;

void main() {
    //loadNavbar();
    game = new GameObject();

    start();
}

Future<Null> start() async {
    await game.preloadManifest();
    DivElement container = new DivElement();
    querySelector("#output").append(container);
    playPen = new PlayPen(container, game.player.petInventory.pets);
    drawLoop();
}

Future<Null> drawLoop() async {
    print("draw loop");
    await playPen.draw();
    print("playpen returned");
    new Timer(new Duration(milliseconds: frameRate), () => drawLoop());
}