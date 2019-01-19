import "Pet.dart";
import 'package:CommonLib/Colours.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import "JSONObject.dart";
import 'dart:html';
import 'dart:async';
import 'package:RenderingLib/src/Rendering/Renderer.dart';

/*
    Eggs don't render their associated doll (which is a grub).
    Instead they render a troll egg tinted their blood color.

    Older the egg is, the more saturated the tint gets.

    Eventually, egg hatches, which removes it from the inventory and replaces it with a new grub with same doll.
    maybe pet inventory handles this?

 */
class Egg extends Pet{

    @override
    int millisecondsToChange = Pet.timeUnit;

    String get daysSinceLaid {
        return daysSinceDate(hatchDate, "Laid");
    }

    String folder = "images/Pets";
    String imageName = "GrubEgg";
    @override
    String type = Pet.EGG;
    Egg(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        HomestuckGrubDoll g = doll as HomestuckGrubDoll;
        HomestuckPalette p = g.palette as HomestuckPalette;
        name = " ${g.bloodColorToWord(p.aspect_light)} Egg";
    }

    Egg.fromJSON(String json, [JSONObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        //print ("loaded $name");
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
        Renderer.wrap_text(textCanvas.context2D,daysSinceLaid,x,y,fontSize,275,"left");

        y = y + fontSize+buffer;
        return y;
    }

    }