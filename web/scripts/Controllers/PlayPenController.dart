import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/PlayPenLib.dart';


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


    ButtonElement b3 = new ButtonElement();
    b3.text = "Deploy Item";
    b3.onClick.listen((e)
    {
       // AIItem item = new AIItem(0,<String>["Soft Friend","Nap Buddy","Plush Pal"],<String>["Smupet_Blu.png","redscale.png","eldritchplushie.png"], curious_value: AIItem.NORMAL_PLUS, idealistic_value: AIItem.NORMAL_MINUS);
        AIItem item = new AIItem(1,<String>["Soft Friend","Nap Buddy","Plush Pal"],<String>["Smupet_Blu.png","redscale.png","eldritchplushie.png"], curious_value: AIItem.NORMAL_MINUS, idealistic_value: AIItem.NORMAL_PLUS);

        playPen.addItem(item);
        playPen.draw();
    });


    querySelector("#output").append(b);
    querySelector("#output").append(b2);
    querySelector("#output").append(b3);



}