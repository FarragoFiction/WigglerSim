import 'package:ImageLib/EffectStack.dart';

import "AIPet.dart";
import "AIObject.dart";
import "AIItem.dart";

import 'dart:html';
import 'dart:async';
import 'package:CommonLib/Random.dart';
import "package:DollLibCorrect/DollRenderer.dart";
import "../Pets/PetLib.dart";
import "../GameShit/GameObject.dart";
import 'package:LoaderLib/src/loader.dart';
import 'package:RenderingLib/src/Rendering/Renderer.dart';

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
    //can't interact with for reals, disappears when you get there
    List<AIItem> imaginaryItems = new List<AIItem>();

    bool readyToAnimate = false;

    CanvasElement canvas = new CanvasElement(width: 1000, height: 400);

    String backgroundImage = "images/PlaypenBackground.png";

    PlayPen(Element divForCanvas, List<Pet> potentialGrubs) {
        window.onMouseMove.listen((Event e){
            if(GameObject.instance.bgMusic.paused) {
                GameObject.instance.playMusic("Wiggling_Time");
            }
        });
        setBackground(divForCanvas);
        divForCanvas.append(canvas);
        loadPets(potentialGrubs);
    }

    Future<Null> loadPets(List<Pet> potentialGrubs) async {
        int x = -50;
        Random rand = new Random();
        rand.nextInt(); //init
        for(Pet p in potentialGrubs) {
            if(p is Grub && pets.length < 16) { //don't let infinite
                p.lastPlayed = new DateTime.now();
                //print("$p last played with ${p.daysSincePlayed}");
                AIPet aip = new AIPet(p, x: x); //can't await it in the add
                if(rand.nextBool()) aip.turnWays = true;
                await aip.setUpIdleAnimation();
                await aip.setUpWalkAnimation();
                aip.restoreDefaultBody(); //fucks up the doll otherwise
                aip.currentAnimation = aip.idleAnimation;

                pets.add(aip);
                x += 150;
                //return; // this keeps it at one pet at a time.
            }
        }
        readyToAnimate = true;
        GameObject.instance.save();
    }

    Future<Null> addItem(AIItem item) async {
        await item.setUpIdleAnimation();
        for(AIPet p in pets) {
            p.giveObjectStats(item);
            if(p.grub.isCurious) {
                //print("want to investigate $item");
                p.target = item; //they are interested in it.
            }else {
               // T("fuck that $item, my curiosity is ${p.curious.value}");
            }
        }
        items.add(item);
    }

    //set the bg to the div so that the canvas can just clear itself instead of redrawing pixels
    Future<Null> setBackground(divForCanvas) async{
        ImageElement image = await Loader.getResource((backgroundImage));
       // print("background image is $backgroundImage");
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

        for(AIItem item in imaginaryItems) {
            await item.draw(canvas); //async
        }

        //in testing, pressing button too much makes it crash from concurrent mod
        List<AIItem> copyItems = new List.from(items);
        for(AIItem item in copyItems) {
            await item.draw(canvas); //async
        }



        for(AIPet pet in pets) {
           await pet.draw(canvas); //async
        }


    }

    Future<Null> drawLoading() async {
        Renderer.clearCanvas(canvas);
        int fontSize = 200;
        canvas.context2D.font = "${fontSize}px Strife";
        canvas.context2D.fillStyle = "#ffffff";
        Random rand = new Random();
        int y = (canvas.height/2).round() + rand.nextInt(10)+50;
        int x = (canvas.width/2).round()+ rand.nextInt(10)-200;
        Renderer.wrap_text(canvas.context2D,"LOADING",x,y,fontSize,400,"center");
    }

}