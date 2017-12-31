/*
    An ai pet has a pet inside of it, as well as a list of animations it can play. and an idea of when to play them.
    also has x/y rotation and scale
    Use cases:
        Trigger: Pet has nothing better to do
            Action: idle animation (flip between two similar bodies)
        Trigger: Pet wants to investigate an object that is not near by.
            Action: Walk animation to object's x/y coordinates. (flip between two similar bodies, change x coordinates)
        Trigger: Pet wants to investigate an object close by.
            Action: display chosen emoticon or text (age based), idle animation as well
        Trigger: Pet wants to attack an object close by.
            Action: figure out some attack animation. play that. item removed from playpen by jadeblood.

    Now, I also need to figure out how stats are going to effect AI. I might need to use the debug_rambling page
    for some solid ideas. But I can probably get the idle animation started for now.



 */
import 'dart:async';
import "../Pets/PetLib.dart";
import 'dart:html';
import 'dart:async';
import 'package:DollLibCorrect/DollRenderer.dart';


class AIPet {
    int x;
    int y;
    double _scaleX = 1.0;
    double _scaleY = 1.0;
    double rotation = 0.0;
    Grub grub;
    AnimationObject idleAnimation = new AnimationObject();
    //will usually be null
    Emotion currentEmotion;

    AIPet(Grub this.grub, {int this.x: 0, int this.y: 100}) {
    }

    //grub body 0 and grub body 1
    Future<Null> setUpIdleAnimation() async {
        HomestuckGrubDoll g = grub.doll;
        Random rand = new Random();
        rand.nextInt(10); //init
        if(rand.nextBool()) {
            g.body.imgNumber = 0;
            await grub.draw();
            idleAnimation.addAnimationFrame(grub.canvas);
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 1;
            await grub.draw();
            idleAnimation.addAnimationFrame(grub.canvas);
        }else { //so they don't all look the same
            g.body.imgNumber = 1;
            await grub.draw();
            idleAnimation.addAnimationFrame(grub.canvas);
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 0;
            await grub.draw();
            idleAnimation.addAnimationFrame(grub.canvas);
        }
    }

    //can set to null, too.
    //IMPORTANT. WHEN RENDERING IT SHOULD BOB, AND THEN AFTER A SECOND OR TWO VANISH WITH NEXT STATE CHANGE
    void setEmotion(Emotion e) {
        if(Emotion.HEART == null) {
            Emotion.initEmotions();
        }
        currentEmotion  = e;
    }

    Future<Null> draw(CanvasElement canvas) async {
        //TODO figure out more complex things than standing in one spot and twitching later.
        //TODO figure out how i want to do text, emoticons, scale and rotation.
        CanvasElement frame = idleAnimation.getNextFrame();
        print("frame is $frame and canvas is $canvas");
        CanvasElement emotionCanvas = null;
        if(currentEmotion != null) {
            emotionCanvas = await currentEmotion.draw(grub);
            print("emotion canvas is $emotionCanvas");
        }
        canvas.context2D.drawImage(frame,x,y);
        if(emotionCanvas != null) canvas.context2D.drawImage(emotionCanvas,x+3*frame.width/4,y);

    }


    void getPositiveEmotion() {
        //TODO
    }

    //some grubs get scared, others get angry
    void getNegativeEmotion() {
        //TODO
    }

    //given my stats, do i like things i've seen before?
    bool likesFamiliar() {
        throw "TODO";
    }

    //given my stats, do i like things similar to me?
    bool likesSimilar() {
        throw "TODO";
    }

    //can be positive or negative about an object
    bool judgeObject() {
        /*
            TODO: Take in an AIObject
            First it judges how similar the object is to me.
    Then it decides whether similarity is a good or bad thing.

    THEN it checks the grubs memory to see if it's seen that object before
        (item name or stat match, both work, so it means you like familiar things even if you
        haven't seen that exact thing before)

    Then it decides whether familiarity is a good or bad thing.

        */
    }


}


class AnimationObject {
    List<CanvasElement> animations = new List<CanvasElement>();
    int index = 0;

    void addAnimationFrame(CanvasElement canvas, [int index = -13]) {
        print("adding animation frame");
        if(index >= 0) {
            animations[index] = canvas;
        }else {
            animations.add(canvas);
        }
    }

    CanvasElement getNextFrame() {
        index ++;
        if(index >= animations.length) {
            index = 0;
        }
        print("next frame is $index, so that's ${animations[index]}");
        return animations[index];
    }



}

//an emotion has an icon and a list of text equivalents (to go in a text bubble?)
//kept as instances
class Emotion {

    static Emotion HEART;
    static Emotion DIAMOND;
    static Emotion CLUBS;
    static Emotion SPADE;

    static String folder = "images/Emoticons";
    String iconLocation;
    List<String> textChoices;
    CanvasElement cachedIconCanvas;
    Emotion(String this.iconLocation, List<String> this.textChoices);

    //this is such a dope robot thing to call.
    static void initEmotions() {
        HEART = new Emotion("heart",<String>["wuv you","wuv","luv you","luv"]);
        DIAMOND = new Emotion("diamond",<String>["u gud","pap u","sleep now","soft thing"]);
        CLUBS = new Emotion("clubs",<String>["bad!","why do?","stop!","no!"]);
        SPADE = new Emotion("spade",<String>["hate","u bad","i bite!","bite u"]);
    }

    Future<CanvasElement> draw(Grub grub) async {
        //grub decides if i pick text or if i pick icon 89 x 108
        bool iconmode = false; //TODO once done testing, check grub's age
        if(iconmode) {
            if (cachedIconCanvas == null) {
                CanvasElement iconCanvas = new CanvasElement(width: 89, height: 98);
                await Renderer.drawWhateverFuture(iconCanvas, "$folder/$iconLocation.png");
                cachedIconCanvas = iconCanvas;
            }
            return cachedIconCanvas;
        }else {
            Random rand = new Random();
            String text = rand.pickFrom(textChoices);
            int txtWidth = 400;
            int txtHeight = 98;
            int buffer = 10;
            CanvasElement textCanvas = new CanvasElement(width: txtWidth, height: txtHeight);
            int fontSize = 20;
            textCanvas.context2D.font = "${fontSize}px Strife";
            //no wider than it needs to be.
            txtWidth = textCanvas.context2D.measureText(text).width.ceil() + buffer;
            textCanvas.width = txtWidth;

            print ('going to display text $text');
            textCanvas.context2D.fillStyle = "#ffffff";
            textCanvas.context2D.strokeStyle = "#000000";
            textCanvas.context2D.fillRect(0, 0, txtWidth, txtHeight);
            textCanvas.context2D.strokeRect(0, 0, txtWidth, txtHeight);
           // Renderer.wrap_text(textCanvas.context2D,"HELLO WORLD",10,10,fontSize,400,"center");
            //TODO why is color wrong? it's black
            textCanvas.context2D.strokeStyle = "#00ff00";
            textCanvas.context2D.fillText(text, 100, fontSize*2);
            return textCanvas;
        }

    }
}