import "AIPet.dart";
import "AIObject.dart";
import "AIItem.dart";

import 'dart:html';
import 'dart:async';
import "package:DollLibCorrect/DollRenderer.dart";
import "../Pets/PetLib.dart";
import "../GameShit/GameObject.dart";

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
    List<AIItem> items = new List<AIItem>();

    CanvasElement canvas = new CanvasElement(width: 1000, height: 400);
    String backgroundImage = "images/BroodingCaverns.png";

    PlayPen(Element divForCanvas, List<Pet> potentialGrubs) {
        setBackground(divForCanvas);
        divForCanvas.append(canvas);
        loadPets(potentialGrubs);
    }

    Future<Null> loadPets(List<Pet> potentialGrubs) async {
        int x = -50;
        Random rand = new Random();
        rand.nextInt(); //init
        for(Pet p in potentialGrubs) {
            if(p is Grub && pets.length < 6) {
                p.lastPlayed = new DateTime.now();
                print("$p last played with ${p.daysSincePlayed}");
                AIPet aip = new AIPet(p, x: x); //can't await it in the add
                if(rand.nextBool()) aip.turnWays = true;
                await aip.setUpIdleAnimation();
                await aip.setUpWalkAnimation();
                aip.currentAnimation = aip.idleAnimation;

                pets.add(aip);
                x += 150;
                //return; // this keeps it at one pet at a time.
            }
        }
        GameObject.instance.save();
    }

    Future<Null> addItem(AIItem item) async {
        await item.setUpIdleAnimation();

        //TODO eventually, only give them the item if they go up to it.
        for(AIPet p in pets) {
            p.giveObjectStats(item);
        }
        items.add(item);
    }

    //set the bg to the div so that the canvas can just clear itself instead of redrawing pixels
    Future<Null> setBackground(divForCanvas) async{
        ImageElement image = await Loader.getResource((backgroundImage));
        print("background image is $backgroundImage");
        divForCanvas.style.backgroundImage = "url(${image.src})";

    }

    //passes the current state of the world to every pet in it so they can make decisions
    void aiTick() {

        List<AIObject> objects = new List.from(pets);
        objects.addAll(items);
        for(AIPet p in pets) {
            p.reactToWorld(objects);
        }
    }



    Future<Null> draw() async {
        Renderer.clearCanvas(canvas);
       // print("drawing playpen");

        //in testing, pressing button too much makes it crash from concurrent mod
        List<AIItem> copyItems = new List.from(items);
        for(AIItem item in copyItems) {
            await item.draw(canvas); //async
        }

        for(AIPet pet in pets) {
           await pet.draw(canvas); //async
        }


    }

}