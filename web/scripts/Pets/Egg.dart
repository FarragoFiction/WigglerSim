import "Pet.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'package:json_object/json_object.dart';
import 'dart:html';
import 'dart:async';

/*
    Eggs don't render their associated doll (which is a grub).
    Instead they render a troll egg tinted their blood color.

    Older the egg is, the more saturated the tint gets.

    Eventually, egg hatches, which removes it from the inventory and replaces it with a new grub with same doll.
    maybe pet inventory handles this?
 */
class Egg extends Pet{

    static int millisecondsToHatch = 60* 1000;

    String folder = "images/Pets";
    String imageName = "GrubEgg";
    @override
    String type = Pet.EGG;
    Egg(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        HomestuckGrubDoll g = doll as HomestuckGrubDoll;
        HomestuckPalette p = g.palette as HomestuckPalette;
        name = " ${g.bloodColorToWord(p.aspect_light)} Egg";
    }

    Egg.fromJSON(String json, [JsonObject jsonObj]) : super(null){
        loadFromJSON(json, jsonObj);
        print ("loaded $name");
    }

    //can't go over 100%, how close to hatching are you?
    double get percentToHatched {
        DateTime now = new DateTime.now();
        Duration diff = now.difference(hatchDate);
        double ret = diff.inMilliseconds/millisecondsToHatch;
        if(ret > 1.0) ret = 1.0;
        return ret;
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
            double percent = percentToHatched;
            if(percent <.05) percent = .05;
            c.setHSV(p.aspect_light.hue, percent, p.aspect_light.value);
            Renderer.swapColors(dollCanvas, c);


            dollCanvas = Renderer.cropToVisible(dollCanvas);

            Renderer.drawToFitCentered(canvas, dollCanvas);
        }
        return canvas;
    }

    @override
    Future<CanvasElement> drawStats([bool shouldDrawTime = true] ) async {
        return super.drawStats(false);
    }

    }