
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

    //TODO procedural description of personality based on stats.
    int textHeight = 800;
    int textWidth = 420;

    int health;
    int boredom;
    String name = "ZOOSMELL POOPLORD";
    //TODO have arrays of cached canvases for animations.
    CanvasElement canvas;
    int width = 400;
    int height = 300;
    Doll doll;
    DateTime hatchDate;
    DateTime lastFed;
    DateTime lastPlayed;
    //when make a new pet, give it an id that isn't currently in the player's inventory. just increment numbers till you find one.
    int id;

    Pet(this.doll, {this.health: 100, this.boredom: 0}) {
        hatchDate = new DateTime.now();
        lastFed = new DateTime.now();
        lastPlayed = new DateTime.now();
        name = randomAsFuckName();
    }

    String get daysSinceHatch {
        DateTime now = new DateTime.now();
        Duration diff = now.difference(hatchDate);
        //print("hatch date is $hatchDate and diff is $diff");
        if(diff.inDays > 0) {
            return "Hatched: ${diff.inDays} days ago.";
        }else if (diff.inHours > 0) {
            return "Hatched: ${diff.inHours} hours ago.";
        }else if (diff.inMinutes > 0) {
            return "Hatched: ${diff.inMinutes} minutes ago.";
        }else if (diff.inSeconds > 0) {
            return "Hatched: ${diff.inSeconds} seconds ago.";
        }
        return "Just Hatched!";
    }

    String randomAsFuckName() {
        Random rand = new Random();
        List<String> titles = <String> ["Captain","Baron","The Esteemed","Mr.","Mrs.","Mdms.","Count","Countess","Clerk","President","Pounceler","Counciler","Minister","Ambassador","Admiral", "Rear Admiral","Commander","Dr.","Sir"];
        List<String> firstNames = <String>["Wiggly","Wiggler","Grubby","Zoosmell","Farmstink","Bubbles","Nic","Lil","Liv","Charles","Meowsers","Casey","Fred","Kid","Meowgon","Fluffy","Meredith","Bill","Ted","Frank","Flan","Squeezykins","Spot","Squeakems","Hissy","Scaley","Glubglub","Mutie","Clattersworth","Bonebone","Nibbles","Fossilbee","Skulligan","Jack","Nigel","Dazzle","Fancy","Pounce"];
        List<String> lastNames = <String>["Grub","Dumbface","Buttlass","Pooplord","Cage","Sebastion","Taylor","Dutton","von Wigglebottom","von Salamancer","Savage","Rock","Spangler","Fluffybutton","the Third, esquire.","S Preston","Logan","the Shippest","Clowder","Squeezykins","Boi","Oldington the Third","Malone","Ribs","Noir","Sandwich"];
        double randNum = rand.nextDouble();
        if(randNum > .6) {
            return "${rand.pickFrom(titles)} ${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}";

        }else if (randNum > .3) {
            return "${rand.pickFrom(titles)} ${rand.pickFrom(lastNames)}";
        }else {
            return "${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}";
        }
    }

    void displayStats(Element container) {
        Element nameDiv = new DivElement();
        nameDiv.text = "${name}";
        nameDiv.style.fontSize = "18px";
        container.append(nameDiv);
    }

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
        Renderer.wrap_text(textCanvas.context2D,daysSinceHatch,x,y,fontSize,400,"left");


        return textCanvas;
    }


    Future<CanvasElement> draw() async {
        //caches by default. if you want it to redraw, set canvas to null.
        if(canvas == null) {
            canvas = new CanvasElement(width: width, height: height);
            canvas.context2D.clearRect(0, 0, width, height);
            CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
            await Renderer.drawDoll(dollCanvas, doll);

            dollCanvas = Renderer.cropToVisible(dollCanvas);

            Renderer.drawToFitCentered(canvas, dollCanvas);
        }
        return canvas;
    }



}