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
import 'dart:math' as Math;




class AIPet extends AIObject {

    //grubs are too big
    @override
    double scaleX = 0.5;
    @override
    double scaleY = 0.5;

    //i'm not getting it directly but right now it doesn't matter too much
    int assumedCanvasWidth = 1000;

    //how close to an object do you need to be to react to it.
    int giveRange = 10;



    //what am i moving towards?
    AIObject target;
    //don't fucking spam reacting to the same object over and over.
    AIObject lastSeen;
    int emotionalCoolDown = 40;
    int timeSinceLastEmotion = 0;


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
    AnimationObject walkAnimation = new AnimationObject();

    //will usually be null
    Emotion _currentEmotion;

    //so i don't set it directly like an ass and fuck shit up.
    Emotion get currentEmotion => _currentEmotion;

    //what should i use
    AnimationObject currentAnimation = new AnimationObject();


    //don't randomly pick a new word each frame, plz
    String currentEmotionPhrase;

    AIPet(Grub this.grub, {int x: 0, int y: 150}):super(x: x, y:y) {
        if(Emotion.HEART == null) {
            Emotion.initEmotions();
        }
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

    //grub body 3 and grub body 4
    @override
    Future<Null> setUpWalkAnimation() async {
        HomestuckGrubDoll g = grub.doll;
        Random rand = new Random();
        rand.nextInt(10); //init
        if(rand.nextBool()) {
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 3;
            await grub.draw();
            walkAnimation.addAnimationFrame(grub.canvas);
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 4;
            await grub.draw();
            walkAnimation.addAnimationFrame(grub.canvas);
        }else { //so they don't all look the same
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 4;
            await grub.draw();
            walkAnimation.addAnimationFrame(grub.canvas);
            grub.canvas = null; //means it will make a new one, so old reference is free
            g.body.imgNumber = 3;
            await grub.draw();
            walkAnimation.addAnimationFrame(grub.canvas);
        }
    }

    //can set to null, too.
    //IMPORTANT. WHEN RENDERING IT SHOULD BOB, AND THEN AFTER A SECOND OR TWO VANISH WITH NEXT STATE CHANGE
    void setEmotion(Emotion e) {
        if(Emotion.HEART == null) {
            Emotion.initEmotions();
        }
        _currentEmotion  = e;
        Random rand = new Random();
        currentEmotionPhrase = rand.pickFrom(currentEmotion.textChoices);
    }

    @override
    Future<Null> draw(CanvasElement canvas) async {
        //TODO figure out more complex things than standing in one spot and twitching later.
        //TODO figure out how i want to do text, emoticons, scale and rotation.
        CanvasElement frame = currentAnimation.getNextFrame();
        //print("frame is $frame and canvas is $canvas");
        CanvasElement emotionCanvas = null;
        if(currentEmotion != null) {
            emotionCanvas = await currentEmotion.draw(grub,currentEmotionPhrase);
            //print("emotion canvas is $emotionCanvas");
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
    Emotion getNegativeQuadrantEmotion() {
        int ashenPoints = 0;
        int pitchPoints = 0;

        if(grub.isPatient) pitchPoints ++;
        if(grub.isCalm) ashenPoints ++;
        if(grub.isAccepting) pitchPoints ++;
        if(grub.isFreeSprited) ashenPoints ++;

        if(grub.isIdealistic) pitchPoints ++;
        if(grub.isLoyal) pitchPoints ++;
        if(grub.isEnergetic) pitchPoints ++;
        if(!grub.isExternal) ashenPoints ++;

        if(grub.isInternal) pitchPoints ++;
        if(grub.isRealistic) ashenPoints ++;
        if(grub.isCurious) ashenPoints ++;
        if(!grub.isImpatient) ashenPoints ++;

        if(ashenPoints > pitchPoints) {
            return Emotion.CLUBS;
        }else {
            return Emotion.SPADE;
        }
    }


    //happy, love, or cool vaguely related to stats
    Emotion getPositiveQuadrantEmotion() {
        int flushedPoints = 0;
        int palePoints = 0;

        if(grub.isPatient) palePoints ++;
        if(grub.isCalm) palePoints ++;
        if(grub.isAccepting) palePoints ++;
        if(grub.isFreeSprited) palePoints ++;

        if(grub.isIdealistic) flushedPoints ++;
        if(grub.isLoyal) flushedPoints ++;
        if(grub.isEnergetic) flushedPoints ++;
        if(!grub.isExternal) palePoints ++;

        if(grub.isInternal) flushedPoints ++;
        if(grub.isRealistic) palePoints ++;
        if(grub.isCurious) flushedPoints ++;
        if(!grub.isImpatient) flushedPoints ++;
        if(palePoints > flushedPoints) {
            return Emotion.DIAMOND;
        }else {
            return Emotion.HEART;
        }
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
           // print ("sleep");
            return Emotion.SLEEP;
        }else if(boredPoints > mehPoints) {
            //print ("bored");
            return Emotion.BORED;
        }else {
            //print ("meh");
            return Emotion.MEH;
        }
    }

    //given my stats, do i like things i've seen before?
    int likesFamiliar() {
        int likesFamiliar = 0;
        if(grub.isPatient) likesFamiliar +=1;
        if(grub.isImpatient) likesFamiliar += -1;

        if(grub.isIdealistic) likesFamiliar  += -1;
        if(grub.isRealistic) likesFamiliar  += 1;

        if(grub.isEnergetic) likesFamiliar  += -1;
        if(grub.isCalm) likesFamiliar  += 1;

        if(grub.isCurious) likesFamiliar  +=  -1;
        if(!grub.isAccepting) likesFamiliar  +=1;

        if(grub.isLoyal) likesFamiliar  +=1;
        if(grub.isFreeSprited) likesFamiliar  +=-1;

        if(grub.isExternal) likesFamiliar  +=-1;
        if(!grub.isInternal) likesFamiliar  +=1;
        //you can't be neutral about familiar objects. you either are drawn to them or not.
        if(likesFamiliar == 0) likesFamiliar =1;
       // print("${grub.name} likes familiar is $likesFamiliar");

        return likesFamiliar;

    }

    //given my stats, do i like things similar to me?  postive for yes, negative for no.
    int likesSimilar() {
        int likesSimilar = 0;
        if(grub.isPatient) likesSimilar += -1;
        if(grub.isImpatient) likesSimilar += 1;

        if(grub.isIdealistic) likesSimilar  += 1;
        if(grub.isRealistic) likesSimilar  += -1;

        if(grub.isEnergetic) likesSimilar  += -1;
        if(grub.isCalm) likesSimilar  += 1;

        if(grub.isCurious) likesSimilar  +=  1;
        if(!grub.isAccepting) likesSimilar  +=-1;

        if(grub.isLoyal) likesSimilar  +=1;
        if(grub.isFreeSprited) likesSimilar  +=-1;

        if(grub.isExternal) likesSimilar  +=-1;
        if(!grub.isInternal) likesSimilar  +=1;
       // print("${grub.name} likes similar is $likesSimilar");
        //you can't be neutral about similar objects. you either are drawn to them or not.
        if(likesSimilar == 0) likesSimilar =1;
        return likesSimilar;
    }



    void walkTowardsTarget() {
        //if their x is less than me, face turnways.
        int direction = 1;
        if(target.x < x) {
            turnWays = true;
            direction = -1;
           // print("$this needs to go left., speed is $speed and direction is $direction");

        }else {
            turnWays = false;
        }
        x += speed  * direction;
    }

    int get speed {
        int unit = 10; //how much each 10 points in a stat should raise/lower it.
        int speed = 0;
        speed += (unit * 2 * energetic.value/10).round();
       // print ("after moding by energy of ${energetic.value}, range is $speed");
        speed += (unit * 1 * idealistic.value/10).round();
       // print ("after moding by external of ${idealistic.value}, range is $speed");
        return Math.max(speed,unit); //don't go negative asshole.
    }


    int get explorationRange {
        int unit = 50; //how much each 10 points in a stat should raise/lower it.
        int exploreRange = 0;
        exploreRange += (unit * 2 * curious.value/10).round();
       // print ("after moding by curiosity of ${curious.value}, range is $exploreRange");
        exploreRange += (unit * 1 * external.value/10).round();
       // print ("after moding by external of ${external.value}, range is $exploreRange");
        return exploreRange;
    }

    //give me an excuse to walk to other side of canvas.
    AIObject makeImaginaryObject() {
        //first, am i to the left or the right of the canvas
        bool left = true;
        if(x > assumedCanvasWidth/2) {
            left = false;
        }
        //then, make an AI object on the opposite side
        AIItem item = new AIItem(0,<String>["Imaginary Friend"],<String>["Smupet_Blu.png"]);

        int buffer = 200;
        if(left) {
            item.x = assumedCanvasWidth-buffer;
         //   print("bored ${grub.name} imagines there is a fun object on the right side of the canvas at ${item.x}");
        }else {
            item.x = 0;
          //  print("bored ${grub.name} imagines there is a fun object on the left side of the canvas at ${item.x}");
        }
        return item;

    }


    void pickTarget(List<AIObject> objects) {
        List<AIObject> copiedObjects = new List.from(objects);
        copiedObjects.remove(this);
        copiedObjects.remove(lastSeen);

        //if an object is within your explore range, add it to explore targets
        List<AIObject> exploreTargets = new List<AIObject>();
        int explorationRangeSaved = explorationRange;
        for(AIObject obj in copiedObjects) {
            if(distanceFromTarget(obj) <= explorationRangeSaved) {
                exploreTargets.add(obj);
            }
        }
        Random rand = new Random();

        if(exploreTargets.isEmpty) {
           // print("TARGET TEST: nobody close by to ${grub.name}");
            //small chance of exploring anyways, so uncurious grubs don't just sit there
            if(rand.nextDouble() > 0.1) {
                target = rand.pickFrom(copiedObjects);
                //print("TARGET TEST: ${grub.name} going to check someone at random");
            }
        }else {
           // print("TARGET TEST: ${grub.name} can see somebody clsoe by");
            target = rand.pickFrom(exploreTargets);
        }
        double boredomOdds = 0.0 + curious.value/Stat.HIGH; //might be way more negative or way more positive.
        boredomOdds +=  external.value/Stat.HIGH;
        //print("checking for boredom");
        if(boredomOdds > rand.nextDouble()) {
            setEmotion(Emotion.SURPRISENOODLE);
            //print("TARGET TEST: ${grub.name} is bored with current emotion ${currentEmotion} at value ${boredomOdds} with curious of ${curious.value} and external of ${external.value}, wants to explore.");
            target = makeImaginaryObject();
        }

    }

    void reactToCloseByThings(List<AIObject> objects) {
        //react to the closest thing that is within react radius.
        //if it's NOT your target random chance of forgetting what you were doing depending on loyalty
        //if it IS your target, definitely forget it (i.e. do something else)
        //if fickleness is too low they never leave whoever they first find.
        double ficklnessOdds = -0.5 - loyal.value/Stat.HIGH; //might be way more negative or way more positive.
        AIObject closestThing;
        int distanceToClosestThing = 1000;
        List<AIObject> copiedObjects = new List.from(objects);
        copiedObjects.remove(this);
        //imaginary objects will never get hit by this otherwise.
        if(target != null && !copiedObjects.contains(target)) copiedObjects.add(target);

        for(AIObject obj in copiedObjects) {
            if(distanceFromTarget(obj) <= giveRange) {
                int distance = distanceFromTarget(obj);
                if(distance < distanceToClosestThing) {
                    closestThing = obj;
                    distanceToClosestThing = distance;
                }
            }
        }
        Random rand = new Random();
        rand.nextInt(); //init
       // print("TARGET TEST: closest thing is $closestThing");
        if(closestThing != null) {
            //don't keep spamming reactions.
            if(lastSeen != closestThing) {
                giveObject(closestThing);
            }
                lastSeen = closestThing;
                if (closestThing == target) {
                    //print("TARGET TEST: ${grub.name} found target $target so removing");
                    target = null;
                } else if (ficklnessOdds > rand.nextDouble()) {
                  //  print("TARGET TEST: ${grub.name}was fickle to ${target} with loyalty of ${loyal.value} and fickleness odds of $ficklnessOdds");
                    target = null;
                }
        }
    }

    void reactToWorld(List<AIObject> objects) {
        //make a copy, remove self from it.
        if(target == null && currentEmotion == null) pickTarget(objects);
        reactToCloseByThings(objects);
        if(target != null) {
            currentAnimation = walkAnimation;
            walkTowardsTarget();
        }else {
            currentAnimation = idleAnimation;
            timeSinceLastEmotion ++;
            if(timeSinceLastEmotion >= emotionalCoolDown) {
                timeSinceLastEmotion = 0;
                _currentEmotion = null;
            }
        }

      // print("target for $this is $target");
    }

    void giveObject(AIObject obj) {
        if(obj is AIItem) return giveItem(obj);
        if(obj is AIPet) return giveGrubFriend(obj);

    }

    //hello new friend (don't need to recurse, if ou're close enough to see friend they can see you)
    void giveGrubFriend(AIPet friend) {
        judgeGrub(friend);
    }

    void giveItem(AIItem item) {
        judgeObject(item);
        //only get stats the first time it's placed in the world.
    }

    void giveObjectStats(AIItem item) {
        double multiplier = 1.0;
        judgeObject(item);

        if(currentEmotion != null) {
            if(currentEmotion.value > 0) multiplier = 2.0;
            if(currentEmotion.value<0) multiplier = 0.5;
        }

        //SAVE.
        grub.patience.value += (item.patience.value * multiplier).round();
        grub.curious.value += (item.curious.value * multiplier).round();
        grub.external.value += (item.external.value * multiplier).round();
        grub.idealistic.value += (item.idealistic.value * multiplier).round();
        grub.energetic.value += (item.energetic.value * multiplier).round();
        grub.loyal.value += (item.loyal.value * multiplier).round();
        grub.itemsRemembered.add(item.id);
       // print("after givign object, items rememberered is ${grub.itemsRemembered}");
        GameObject.instance.save();
    }

    @override
    String toString() {
        return "${grub.name}";
    }

    void judgeGrub(AIPet grub) {
        int reactionToSimilar = likesSimilar();
        //print("getting simulatity rating");
        int similarityRatingValue = similarityRating(grub) * reactionToSimilar;
       // print("judged similarity is ${similarityRatingValue}");
        if(similarityRatingValue > 0) {
            //print("judged positive");
            setEmotion(getPositiveQuadrantEmotion());
        }else if(similarityRatingValue < 0) {
            //print("judged negative");
            setEmotion(getNegativeQuadrantEmotion());
        }else {
            //print("judged neutral");
            setEmotion(Emotion.NEUTRALQUADRANT);
        }
        //print("judged ${grub.grub.name}, emotion is ${currentEmotion.iconLocation}");
    }

    //can be positive or negative about an object
    void judgeObject(AIItem item) {
        int reactionToSimilar = likesSimilar();
       // print("getting simulatity rating");
        int similarityRatingValue = similarityRating(item) * reactionToSimilar;

        int reactionToFamiliar = likesFamiliar();
        int familiarityRatingValue = isFamiliarItem(item) * reactionToFamiliar;

        //i might not like what it is, but be comforted by familarity, etc etc.
        int opinionOnItem = similarityRatingValue + familiarityRatingValue;
       // print("judged similarity is ${similarityRatingValue} and familar is ${familiarityRatingValue} and opinion is ${opinionOnItem}");

        if(opinionOnItem > 0) {
           // print("judged positive");
            setEmotion(getPositiveEmotion());
        }else if(opinionOnItem < 0) {
            //print("judged negative");
            setEmotion(getNegativeEmotion());
        }else {
            //print("judged neutral");
            setEmotion(getNeutralEmotion());
        }
       // print("judged ${item.trollNames}, emotion is ${currentEmotion.iconLocation}");
    }

    int isFamiliarItem(AIItem item) {
        if(grub.itemsRemembered.contains(item.id)) {
           // print("$item is familiar to $grub");
            return 1;
        }
        return 0;
    }


}



//an emotion has an icon and a list of text equivalents (to go in a text bubble?)
//kept as instances
class Emotion {

    static Emotion HEART;
    static Emotion DIAMOND;
    static Emotion CLUBS;
    static Emotion SPADE;
    static Emotion NEUTRALQUADRANT;


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
        HEART = new Emotion(1,"heart",<String>["wuv u","wuv","luv you","luv"]);
        DIAMOND = new Emotion(1,"diamond",<String>["u gud","pap u","sleep now","soft thing"]);
        CLUBS = new Emotion(-1,"clubs",<String>["bad!","why do?","stop!","no!"]);
        SPADE = new Emotion(-1,"spade",<String>["hate","u bad","i bite!","bite u"]);
        NEUTRALQUADRANT = new Emotion(0,"meh",<String>["oh","...","ok","is grub","u ok"]);


        SURPRISENOODLE = new Emotion(0,"surpriseNoodle",<String>["?","wat this","go see"]);
        SHOUTPOLE = new Emotion(0,"shoutPole",<String>["!","shock","suwpwise"]);


        //good:  happy, love, or cool
        HAPPY = new Emotion(1,"happy",<String>["gud thing","wike thing","is good","happy"]);
        LOVE = new Emotion(1,"love",<String>["best thing","wuv thing","is mine","my thing"]);
        COOL = new Emotion(1,"cool",<String>["coo thing","luk thing","ok thing","is coo"]);

        //neutral: sleep, bored, or meh
        SLEEP = new Emotion(0,"sleep",<String>["zzz","sweepy","yawn"]);
        MEH = new Emotion(0,"meh",<String>["oh","...","ok","is thing"]);
        BORED = new Emotion(0,"bored",<String>["bored","why","is ok"]);

        //bad: angery, fear, sad
        ANGERY = new Emotion(-1,"angery",<String>["i bite!","hate thing","angwy","fight thing", "*screech*"]);
        FEAR = new Emotion(-1,"fear",<String>["i scare","go away","scawy","no","i hide", "*shivering*"]);
        SAD = new Emotion(-1,"sad",<String>["sad thing","sad","*cry*",'heck',"dang"]);

    }

    @override
    String toString() {
        return "$textChoices";
    }

    Future<CanvasElement> draw(Grub grub, String chosenPhrase) async {
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
            int txtWidth = 400;
            int fontSize = 20;
            int buffer = 10;
            int txtHeight = fontSize + buffer;
            CanvasElement textCanvas = new CanvasElement(width: txtWidth, height: txtHeight);
            textCanvas.context2D.font = "${fontSize}px Strife";

            //no wider than it needs to be.
            txtWidth = textCanvas.context2D.measureText(chosenPhrase).width.ceil() + buffer;
            //textCanvas.width = txtWidth;

            //print ('going to display text $text');
            textCanvas.context2D.fillStyle = "#ffffff";
            textCanvas.context2D.strokeStyle = "#000000";
            textCanvas.context2D.fillRect(0, 0, txtWidth, txtHeight);
            textCanvas.context2D.strokeRect(0, 0, txtWidth, txtHeight);
           // Renderer.wrap_text(textCanvas.context2D,"HELLO WORLD",10,10,fontSize,400,"center");
            HomestuckTrollDoll t = grub.doll as HomestuckTrollDoll;
            HomestuckPalette p = t.palette as HomestuckPalette;
            textCanvas.context2D.fillStyle = p.aspect_light.toStyleString();
            textCanvas.context2D.fillText(chosenPhrase, buffer/2, fontSize);
            return textCanvas;
        }

    }
}