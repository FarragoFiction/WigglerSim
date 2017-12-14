import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:async';
import 'dart:html';



class Troll extends Pet{

    @override
    int millisecondsToChange = 1*10*60* 1000;

    @override
    String type = Pet.TROLL;
    Troll(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        //turns grub into troll., later will calc sign
        this.doll = Doll.convertOneDollToAnother(doll, new HomestuckTrollDoll());
        print("doll for troll is $doll");

    }

    Troll.fromJSON(String json, [JsonObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        this.doll = Doll.convertOneDollToAnother(doll, new HomestuckTrollDoll());
        print("doll for troll is $doll");
        print ("loaded $name");
    }

    //returns where next thing should be
    int drawTimeStats(CanvasElement textCanvas, int x, int y, int fontSize,buffer) {
        Renderer.wrap_text(textCanvas.context2D,"I'm a motherfucking troll. Deal with it.",x,y,fontSize,400,"left");
        return y;
    }
}