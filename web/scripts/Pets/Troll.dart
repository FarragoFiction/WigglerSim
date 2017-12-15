import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:async';
import 'dart:html';



class Troll extends Pet{

    @override
    int millisecondsToChange = 1*10*60* 1000;

    //what happened to the troll now that they go off on their own?
    String epilogue;

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

    @override
    Future<CanvasElement> drawStats() async {
        //never cache
        CanvasElement textCanvas = new CanvasElement(width: textWidth, height: textHeight);
        textCanvas.context2D.fillStyle = "#d2ac7c";
        textCanvas.context2D.strokeStyle = "#2c1900";
        textCanvas.context2D.lineWidth = 3;


        textCanvas.context2D.fillRect(0, 0, width, textHeight);
        textCanvas.context2D.strokeRect(0, 0, width, textHeight);

        textCanvas.context2D.fillStyle = "#2c1900";

        int fontSize = 20;
        textCanvas.context2D.font = "${fontSize}px Strife";
        int y = 330;
        int x = 10;
        Renderer.wrap_text(textCanvas.context2D,name,x,y,fontSize,400,"center");

        y = y + fontSize*2;
        fontSize = 12;

        int buffer = 10;

        y = drawTimeStats(textCanvas,x,y,fontSize,buffer);

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,"Testing",x,y,fontSize,400,"left");

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,"Boredom: $boredom",x,y,fontSize,400,"left");


        return textCanvas;
    }
}