import 'package:CommonLib/Utility.dart';

import "Pet.dart";
import 'package:CommonLib/Colours.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import 'package:RenderingLib/src/Rendering/Renderer.dart';

/*
   Cocoons are basically eggs that turn into trolls, not grubs.

 */
class Cocoon extends Pet{

    @override
    int millisecondsToChange = Pet.timeUnit;

    String get daysSinceSpun {
        return daysSinceDate(hatchDate, "Cocooned");
    }

    String folder = "images/Pets";
    String imageName = "Cocoon";
    @override
    String type = Pet.COCOON;
    Cocoon(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {

    }

    Cocoon.fromJSON(Map<String,dynamic> json) : super(null){
        loadFromJSON(json);
       // print ("loaded $name");
    }


    @override
    Future<CanvasElement> draw() async {
        //print ("trying to draw egg.");
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
        Renderer.wrap_text(textCanvas.context2D,daysSinceSpun,x,y,fontSize,275,"left");

        y = y + fontSize+buffer;
        return y;
    }

    }