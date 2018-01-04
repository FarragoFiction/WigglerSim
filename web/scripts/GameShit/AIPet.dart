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
import "AIObject.dart";
import "GameObject.dart";
import "AIItem.dart";



class AIPet extends AIObject {

    //grubs are too big
    @override
    double scaleX = 0.5;
    @override
    double scaleY = 0.5;


    Grub grub;
    @override
    Stat get patience => grub.patience;
    @override
    Stat get energetic => grub.energetic;
    @override
    Stat get idealistic => grub.idealistic;
    @override
    Stat get curious => grub.curious;
    @override
    Stat get loyal => grub.loyal;
    @override
    Stat get external => grub.external;

    AnimationObject idleAnimation = new AnimationObject();
    //will usually be null
    Emotion currentEmotion;

    AIPet(Grub this.grub, {int x: 0, int y: 150}):super(x: x, y:y) {
    }

    //grub body 0 and grub body 1
    @override
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

    @override
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
        //canvas.context2D.drawImage(frame,x,y);
        CanvasElement petFrame = await drawPet(frame);
        canvas.context2D.drawImage(petFrame,x,y);

        if(emotionCanvas != null) canvas.context2D.drawImage(emotionCanvas,x+1.8*frame.width/4,4*y/4);

    }

    Future<CanvasElement> drawPet(CanvasElement canvas) async {
        CanvasElement ret = new CanvasElement(width: grub.doll.width, height: grub.doll.height);
        ret.context2D.translate(ret.width/2, ret.height/2);
        ret.context2D.rotate(rotation);

        if(turnWays) {
            ret.context2D.scale(-1*scaleX, scaleY);
        }else {
            ret.context2D.scale(scaleX, scaleY);
        }
        ret.context2D.drawImage(canvas, -ret.width/2, -ret.height/2);
        return ret;
    }



    //happy, love, or cool vaguely related to stats
    Emotion getPositiveEmotion() {
        //cool is patient, calm, accepting, free spirited
        int coolPoints = 0;
        //love is idealistic, loyal, energetic, external
        int lovePoints = 0;
        //happy is internal, realistic, curious, impatient
        int happyPoints = 0;

        if(grub.isPatient) coolPoints ++;
        if(grub.isCalm) coolPoints ++;
        if(grub.isAccepting) coolPoints ++;
        if(grub.isFreeSprited) coolPoints ++;

        if(grub.isIdealistic) lovePoints ++;
        if(grub.isLoyal) lovePoints ++;
        if(grub.isEnergetic) lovePoints ++;
        if(!grub.isExternal) lovePoints ++;

        if(grub.isInternal) happyPoints ++;
        if(grub.isRealistic) happyPoints ++;
        if(grub.isCurious) happyPoints ++;
        if(!grub.isImpatient) happyPoints ++;

        if(coolPoints > lovePoints && coolPoints > happyPoints) {
            return Emotion.COOL;
        }else if(lovePoints > happyPoints) {
            return Emotion.LOVE;
        }else {
            return Emotion.HAPPY;
        }
    }



    //angery, fear, sad,vaguely related to stats
    //some grubs get scared, others get angry
    Emotion getNegativeEmotion() {
        //TODO
        //internal, loyal, curious,energetic
        int fearPoints = 0;
        //realisitc, free-spirited, impatient, external
        int angeryPoints = 0;
        //accepting, calm, patient, idealistic
        int sadPoints = 0;

        if(grub.isInternal) fearPoints ++;
        if(grub.isLoyal) fearPoints ++;
        if(grub.isCurious) fearPoints ++;
        if(grub.isEnergetic) fearPoints ++;

        if(grub.isRealistic) angeryPoints ++;
        if(grub.isFreeSprited) angeryPoints ++;
        if(grub.isImpatient) angeryPoints ++;
        if(!grub.isExternal) angeryPoints ++;

        if(grub.isAccepting) sadPoints ++;
        if(grub.isCalm) sadPoints ++;
        if(grub.isPatient) sadPoints ++;
        if(!grub.isIdealistic) sadPoints ++;

        if(angeryPoints > fearPoints && angeryPoints > sadPoints) {
            return Emotion.ANGERY;
        }else if(fearPoints > sadPoints) {
            return Emotion.FEAR;
        }else {
            return Emotion.SAD;
        }
    }


    /*
        Stat patience;
    Stat energetic;
    Stat idealistic;
    Stat curious;
    Stat loyal;
    Stat external;
     */

    //sleep, bored, or meh are more randomly distributed
    Emotion getNeutralEmotion() {
        //patient, energetic, idealistic, internal
        int sleepPoints = 0;
        //calm, realistic, accepting, freespirited
        int boredPoints = 0;
        //curious, loyal, external, impatient
        int mehPoints = 0;

        if(grub.isPatient) sleepPoints ++;
        if(grub.isEnergetic) sleepPoints ++;
        if(grub.isIdealistic) sleepPoints ++;
        if(grub.isInternal) sleepPoints ++;

        if(grub.isCalm) boredPoints ++;
        if(grub.isRealistic) boredPoints ++;
        if(grub.isAccepting) boredPoints ++;
        if(!grub.isFreeSprited) boredPoints ++;

        if(grub.isCurious) mehPoints ++;
        if(grub.isLoyal) mehPoints ++;
        if(grub.isExternal) mehPoints ++;
        if(!grub.isImpatient) mehPoints ++;

        if(sleepPoints > boredPoints && sleepPoints > mehPoints) {
            return Emotion.SLEEP;
        }else if(boredPoints > mehPoints) {
            return Emotion.BORED;
        }else {
            return Emotion.MEH;
        }
    }

    //given my stats, do i like things i've seen before?
    bool likesFamiliar() {
        throw "TODO";
    }

    //given my stats, do i like things similar to me?
    bool likesSimilar() {
        throw "TODO";
    }

    void giveObject(AIItem item) {
        /*
        TODO:
            first, it judges the object. If it likes it, 2x points, if it does not, 0.5 times.
            then, apply objects stats to the grub.
            judging changes emotional state.

            so, just ask what your current emotional state is and apply the bonus.
            if it's somehow null, do nothing.
         */
        double multiplier = 1.0;
        judgeObject(item);
        if(currentEmotion != null) {
            if(currentEmotion.value > 0) multiplier = 2.0;
            if(currentEmotion.value<0) multiplier = 0.5;
        }

        //TODO for stat in item stats, apply that stat to the grub. (eh, i'll just do it by hand, only 6 of them)
        //SAVE.
        grub.patience.value += (item.patience.value * multiplier).round();
        grub.curious.value += (item.curious.value * multiplier).round();
        grub.external.value += (item.external.value * multiplier).round();
        grub.idealistic.value += (item.idealistic.value * multiplier).round();
        grub.energetic.value += (item.energetic.value * multiplier).round();
        grub.loyal.value += (item.loyal.value * multiplier).round();

        GameObject.instance.save();
    }

    //can be positive or negative about an object
    void judgeObject(AIItem item) {
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



//an emotion has an icon and a list of text equivalents (to go in a text bubble?)
//kept as instances
class Emotion {

    static Emotion HEART;
    static Emotion DIAMOND;
    static Emotion CLUBS;
    static Emotion SPADE;

    static Emotion HAPPY;
    static Emotion LOVE;
    static Emotion COOL;

    //meme misspelling
    static Emotion ANGERY;
    static Emotion FEAR;
    static Emotion SAD;

    static Emotion SLEEP;
    static Emotion BORED;
    static Emotion MEH;

    static Emotion SHOUTPOLE;
    static Emotion SURPRISENOODLE;

    static int GOOD = 1;
    static int NEUTRAL = 0;
    static int BAD = -1;

    static String folder = "images/Emoticons";
    String iconLocation;
    List<String> textChoices;
    CanvasElement cachedIconCanvas;

    int value;



    Emotion(int this.value, String this.iconLocation, List<String> this.textChoices);



    //this is such a dope robot thing to call.
    static void initEmotions() {
        //for grubs
        HEART = new Emotion(1,"heart",<String>["wuv you","wuv","luv you","luv"]);
        DIAMOND = new Emotion(1,"diamond",<String>["u gud","pap u","sleep now","soft thing"]);
        CLUBS = new Emotion(-1,"clubs",<String>["bad!","why do?","stop!","no!"]);
        SPADE = new Emotion(-1,"spade",<String>["hate","u bad","i bite!","bite u"]);

        SURPRISENOODLE = new Emotion(0,"surpriseNoodle",<String>["?"]);
        SHOUTPOLE = new Emotion(0,"shoutPole",<String>["!"]);


        //good:  happy, love, or cool
        HAPPY = new Emotion(1,"happy",<String>["gud thing","wike thing","is good","happy"]);
        LOVE = new Emotion(1,"love",<String>["best thing","wuv thing","is mine","my thing"]);
        COOL = new Emotion(1,"cool",<String>["coo thing","luk thing","ok thing","is coo"]);

        //neutral: sleep, bored, or meh
        SLEEP = new Emotion(0,"sleep",<String>["zzz","sweepy","yawn"]);
        MEH = new Emotion(0,"meh",<String>["oh","...","ok","is thing"]);
        BORED = new Emotion(0,"bored",<String>["bored","why","is ok"]);

        //bad: angery, fear, sad
        ANGERY = new Emotion(-1,"angery",<String>["i bite!","hate thing","angwy","fight thing", "*incoherent screeching*"]);
        FEAR = new Emotion(-1,"fear",<String>["i scare","go away","scawy","no","i hide", "*shivering*"]);
        SAD = new Emotion(-1,"sad",<String>["sad thing","sad","*incoherent crying*"]);

    }

    Future<CanvasElement> draw(Grub grub) async {
        //grub decides if i pick text or if i pick icon 89 x 108
        bool iconmode = grub.percentToChange < 0.5; //if eyes done, talk.
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
            int fontSize = 20;
            int buffer = 10;
            int txtHeight = fontSize + buffer;
            CanvasElement textCanvas = new CanvasElement(width: txtWidth, height: txtHeight);
            textCanvas.context2D.font = "${fontSize}px Strife";

            //no wider than it needs to be.
            txtWidth = textCanvas.context2D.measureText(text).width.ceil() + buffer;
            //textCanvas.width = txtWidth;

            print ('going to display text $text');
            textCanvas.context2D.fillStyle = "#ffffff";
            textCanvas.context2D.strokeStyle = "#000000";
            textCanvas.context2D.fillRect(0, 0, txtWidth, txtHeight);
            textCanvas.context2D.strokeRect(0, 0, txtWidth, txtHeight);
           // Renderer.wrap_text(textCanvas.context2D,"HELLO WORLD",10,10,fontSize,400,"center");
            //TODO why is color wrong? it's black
            HomestuckTrollDoll t = grub.doll as HomestuckTrollDoll;
            HomestuckPalette p = t.palette as HomestuckPalette;
            textCanvas.context2D.fillStyle = p.aspect_light.toStyleString();
            textCanvas.context2D.fillText(text, buffer/2, fontSize);
            return textCanvas;
        }

    }
}