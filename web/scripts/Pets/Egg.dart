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

    String folder = "images/Pets";
    String imageName = "GrubEgg";
    @override
    String type = Pet.EGG;
    Egg(Doll doll, {health: 100, boredom: 0}) : super(doll, health: health, boredom: boredom) {
        name = "Egg";
    }

    Egg.fromJSON(String json, [JsonObject jsonObj]) : super(null){
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