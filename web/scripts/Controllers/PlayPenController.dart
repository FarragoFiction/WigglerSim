import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPen.dart';
import '../GameShit/AIPet.dart';


import "navbar.dart";

GameObject game;
PlayPen playPen;
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


    //button is just for testing, will be animation later
    ButtonElement b = new ButtonElement();
    b.text = "Draw";
    b.onClick.listen((e)
    {
        playPen.draw();
    });

    ButtonElement b2 = new ButtonElement();
    b2.text = "Emote";
    b2.onClick.listen((e)
    {
        //setEmotion
        List<Emotion> emotions = <Emotion>[Emotion.HEART, Emotion.SPADE, Emotion.DIAMOND, Emotion.CLUBS];
        Random rand = new Random();
        for(AIPet p in playPen.pets) {
            p.setEmotion(rand.pickFrom(emotions));
        }
        playPen.draw();
    });
    querySelector("#output").append(b);
    querySelector("#output").append(b2);


}