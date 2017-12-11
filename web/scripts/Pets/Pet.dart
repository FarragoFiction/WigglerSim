
/*
    A wiggler is a type of pet. So is an egg, and a coccoon.
    maybe other things, in the future. consorts?

    A pet has stats (what stats? hunger at least)

    A pet has a name.

    A pet knows how to save and load itself.

    A pet has an id.

    Pet knows how to animate itself based on actions???

    TODO Pet knows how to convert to json (so it can be saved).

    A pet has a birthday.
    A pet has a "time last fed".
    A pet has a "time last played with".
    Pet should have a personality based on their stats. changes over time as their stats change?
        health
        boredom

    Pet has a symbol you can assign it at a certain life stage.


    How can you effect stats? Items you give wigglers to play with. Use items from fryamotifs.
    Each item has plus and minus.  Could go aspect route and have mobility/free will, min/max luck, etc.
    Or just straight up the aspect names.

    Activities you do with them can effect stats too?

    Better eggs cost more,come with better stats? Or at least more extreme.

    Assign symbol based on what aspect it is closest too at maturity?

    if stats above certain threshold, adult form has wings?


 */
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
abstract class Pet {

    int health;
    int boredom;
    String name = "ZOOSMELL POOPLORD";
    CanvasElement canvas;
    int width = 400;
    int height = 300;
    Doll doll;
    //when make a new pet, give it an id that isn't currently in the player's inventory. just increment numbers till you find one.
    int id;

    Pet(this.doll, {this.health: 100, this.boredom: 0});


    Future<CanvasElement> draw() async {
        if(canvas == null) canvas = new CanvasElement(width: width, height: height);
        canvas.context2D.clearRect(0,0,width,height);
        CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
        await Renderer.drawDoll(dollCanvas, doll);

        dollCanvas = Renderer.cropToVisible(dollCanvas);

        Renderer.drawToFitCentered(canvas, dollCanvas);
        return canvas;
    }



}