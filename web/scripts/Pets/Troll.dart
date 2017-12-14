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
        window.alert("it's a motherfucking troll");
        doll = Doll.convertOneDollToAnother(doll, new HomestuckTrollDoll());

    }

    Troll.fromJSON(String json, [JsonObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        print ("loaded $name");
    }
}