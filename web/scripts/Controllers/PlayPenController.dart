import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPenLib.dart';


import "navbar.dart";

GameObject game;
int frameRate = 100;

bool stop = true;

void main() {
    loadNavbar();
    game = new GameObject(true);
    ButtonElement b = new ButtonElement();
    b.text = "toggle animation";
    querySelector("#output").append(b);
    b.onClick.listen((e) {
        toggle();
    });

    start();
}

Future<Null> start() async {
    await game.preloadManifest();
    DivElement container = new DivElement();
    querySelector("#output").append(container);
    DivElement shop = new DivElement();
    querySelector("#output").append(shop);
    game.playPen = new PlayPen(container, game.player.petInventory.pets);
    game.drawItemInventory(shop);
    drawLoop();
}

Future<Null> drawLoop() async {
    //print("draw loop");
    game.playPen.aiTick();
    await game.playPen.draw();
    //print("playpen returned");
    if(!stop) new Timer(new Duration(milliseconds: frameRate), () => drawLoop());
}

void toggle() {
    stop = !stop;
    if(!stop) drawLoop();
}