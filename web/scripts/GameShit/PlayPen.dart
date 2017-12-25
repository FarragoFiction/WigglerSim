import "AIPet.dart";
import 'dart:html';
import 'dart:async';
import "package:DollLibCorrect/DollRenderer.dart";
/*
TODO:

a play pen has a canvas it renders to, a list of wigglers inside it and their positions.
it also has a list of items in it and their positions.

only grubs can be in a playpen, nothing else.

How do I want to handle animation? seems a waste to give it to the Grub itself....

I think I'll make a wrapper object that has the grub itself, and an array of animation frames?
so the playpen doesn't have a list of wigglers, but a list of AnimatedWigglers???
 */
class PlayPen {
    List<AIPet> pets = new List<AIPet>();
    CanvasElement canvas = new CanvasElement(width: 1000, height: 400);
    String backgroundImage = "images/BroodingCaverns.png";

    PlayPen(Element divForCanvas) {
        setBackground(divForCanvas);
        divForCanvas.append(canvas);
        //TODO need to havea  draw method that clears the canvas then loops on all AIPets and asks them to draw themselves
    }

    //set the bg to the div so that the canvas can just clear itself instead of redrawing pixels
    Future<Null> setBackground(divForCanvas) async{
        ImageElement image = await Loader.getResource((backgroundImage));
        print("background image is $backgroundImage");
        divForCanvas.style.backgroundImage = "url(${image.src})";

    }

    Future<Null> draw() async {
        Renderer.clearCanvas(canvas);
        for(AIPet pet in pets) {
            pet.draw(canvas); //async
        }
    }

}