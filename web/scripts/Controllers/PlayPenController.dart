import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPenLib.dart';


import "navbar.dart";

GameObject game;
int frameRate = 200; //300 looks so bad, 100 is too fast

bool stop = false;

Future<Null> main() async {
    loadNavbar();
    await Doll.loadFileData();
    game = new GameObject(true);
    ButtonElement b = new ButtonElement();
    b.text = "toggle animation";
    querySelector("#output").append(b);
    b.onClick.listen((e) {
        toggle();
    });


    ButtonElement b2 = new ButtonElement();
    b2.text = "Remove All Items";
    querySelector("#output").append(b2);
    b2.onClick.listen((e) {
        removeItems();
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
    if(game.playPen.readyToAnimate) {
        await game.playPen.draw();
    }else {
        await game.playPen.drawLoading();
    }
    //print("playpen returned");
    if(!stop) new Timer(new Duration(milliseconds: frameRate), () => drawLoop());
}

void toggle() {
    stop = !stop;
    if(!stop) drawLoop();
}

void removeItems() {
    game.playPen.items.clear();
}