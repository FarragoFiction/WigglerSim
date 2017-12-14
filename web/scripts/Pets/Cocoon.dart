import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:html';
import 'dart:async';

/*
   Cocoons are basically eggs that turn into trolls, not grubs.

 */
class Cocoon extends Pet{

    @override
    int millisecondsToChange = 1*10*60* 1000;

    String get daysSinceSpun {
        return daysSinceDate(hatchDate, "Cocooned");
    }

    String folder = "images/Pets";
    String imageName = "Cocoon";
    @override
    String type = Pet.COCOON;
    Cocoon(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        /*
                TODO: makes a new troll doll out of the grub doll, matches all existing features.
         */
    }

    Cocoon.fromJSON(String json, [JsonObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        print ("loaded $name");
    }


    @override
    Future<CanvasElement> draw() async {
        print ("trying to draw egg.");
        //caches by default. if you want it to redraw, set canvas to null.
        if(canvas == null) {

            canvas = new CanvasElement(width: width, height: height);
            canvas.context2D.clearRect(0, 0, width, height);
            CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
            await Renderer.drawWhateverFuture(dollCanvas, "$folder/$imageName.png");
            HomestuckPalette p = doll.palette as HomestuckPalette;
            Colour c = new Colour.from(p.aspect_light);
            double percent = percentToChange;
            if(percent <.05) percent = .05;
            c.setHSV(p.aspect_light.hue, percent, p.aspect_light.value);
            Renderer.swapColors(dollCanvas, c);


            dollCanvas = Renderer.cropToVisible(dollCanvas);

            Renderer.drawToFitCentered(canvas, dollCanvas);
        }
        return canvas;
    }


    //returns where next thing should be
    int drawTimeStats(CanvasElement textCanvas, int x, int y, int fontSize,buffer) {
        Renderer.wrap_text(textCanvas.context2D,daysSinceSpun,x,y,fontSize,400,"left");

        y = y + fontSize+buffer;
        return y;
    }

    }