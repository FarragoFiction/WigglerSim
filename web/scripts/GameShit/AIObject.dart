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
import 'package:CommonLib/Random.dart';
import 'package:ImageLib/EffectStack.dart';

import "../Pets/PetLib.dart";
import 'dart:html';
import 'dart:math' as Math;
import 'dart:async';
import 'package:DollLibCorrect/DollRenderer.dart';


abstract class AIObject {
    int id;
    int x;
    int y;
    bool turnWays = false;
    double scaleX = 1.0;
    double scaleY = 1.0;
    double rotation = 0.0;
    Stat patience;
    Stat energetic;
    Stat idealistic;
    Stat curious;
    Stat loyal;
    Stat external;
    bool corrupt = false;
    List<Stat> get stats => <Stat>[patience, energetic, idealistic, curious, loyal, external ];

    AnimationObject idleAnimation = new AnimationObject();



    AIObject({int this.x: -100013, int this.y: 100}) {
    }

    //https://codereview.stackexchange.com/questions/107635/checking-if-two-numbers-have-the-same-sign
    bool sameSign(int num1, int num2) {
       // print("similarity rating: does $num1 have the same sign as $num2? ${(num1 ^ num2) >= 0}");
        return (num1 ^ num2) >= 0;
    }

    @override
    String toString() {
        return "AiObject";
    }

    static int distance(int x1, int y1, int x2, int y2) {
        //int xs = (x1-x2)^2;
        //int ys = (y1-y2)^2;
        //print("xs $xs ys $ys");
        //return Math.sqrt((xs+ys).abs()).round();
        //DUNKASS, don't worry about y because that makes short items like carrots unatainable
        return (x1-x2).abs();

    }

    int distanceFromTarget(AIObject target) {
        return distance(target.x, target.y, x, y);
    }

    int similarityRating(AIObject obj) {
       // print("getting similarity rating between ${this} and ${obj}");

        int similarity = 0;
        //for each stat we have the same value for, add a point
        //for objects, assume stat of zero means neither way
        if(obj.patience.value != 0 && sameSign(patience.value, obj.patience.value)) {
            similarity ++;
        }else if(obj.patience.value != 0)  {
            similarity += -1;
        }
        if(obj.curious.value != 0 && sameSign(curious.value, obj.curious.value)){
            similarity ++;
        }else if(obj.curious.value != 0) {
            similarity += -1;
        }
        if(obj.energetic.value != 0 &&sameSign(energetic.value, obj.energetic.value)){
            similarity ++;
        }else if(obj.energetic.value != 0)  {
            similarity += -1;
        }
        if(obj.idealistic.value != 0 &&sameSign(idealistic.value, obj.idealistic.value)){
            similarity ++;
        }else if(obj.idealistic.value != 0)  {
            similarity += -1;
        }
        if(obj.loyal.value != 0 &&sameSign(loyal.value, obj.loyal.value)){ similarity ++;
        }else if(obj.loyal.value != 0)  {
            similarity += -1;
        }
        if(obj.external.value != 0 &&sameSign(external.value, obj.external.value)){
            similarity ++;
        }else if(obj.external.value != 0) {
            similarity += -1;
        }
      //  print("similarity rating between ${this} and ${obj} is $similarity");
        return similarity;
    }

    //grub body 0 and grub body 1
    Future<Null> setUpIdleAnimation() async
    {

    }


    Future<Null> draw(CanvasElement canvas) async {


    }




}



class AnimationObject {
    List<CanvasElement> animations = new List<CanvasElement>();
    int index = 0;

    void addAnimationFrame(CanvasElement canvas, AIObject obj, [int index = -13]) {
        print("adding animation frame");
        final EffectStack stack = new EffectStack(canvas);
        if(obj.corrupt) {

            if(obj.loyal.value < 0) {
                breathCorruptEffect(stack, obj);
            }
            if(obj.energetic.value < 0) {
                doomCorruptEffect(stack, obj);
            }

            //make sure void is last
            if(obj.curious.value < 0) {
                voidCorruptEffect(stack, obj);
            }else {
                lightCorruptEffect(stack,obj);
            }
        }

        canvas = stack.canvas;

        if(index >= 0) {
            animations[index] = canvas;
        }else {
            animations.add(canvas);
        }
    }

    void breathCorruptEffect(EffectStack stack, AIObject obj) {
        Random rand = new Random();
        final Mask testMask = new RectMask(50+rand.nextIntRange(10,100), 50+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100))..wrap=true;
        //they are color blind, not loyal
        stack.immediateEffect(new GreyscaleEffect()..addMask(testMask));
    }

    void voidCorruptEffect(EffectStack stack, AIObject obj) {
        Random rand = new Random();
        final Mask testMask = new RectMask(50+rand.nextIntRange(10,100), 50+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100))..wrap=true;
        stack.immediateEffect(
              new OpacityEffect(0.3 + rand.nextDoubleRange(0.1, 0.7))..addMask(testMask));
    }

    void lightCorruptEffect(EffectStack stack, AIObject obj) {
        Random rand = new Random();
        final Mask testMask = new RectMask(50+rand.nextIntRange(10,100), 50+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100), 100+rand.nextIntRange(10,100))..wrap=true;
        stack.immediateEffect(
            new InvertEffect()..addMask(testMask));
    }

    void doomCorruptEffect(EffectStack stack, AIObject obj) {
        Random rand = new Random();
        int size = 10 + rand.nextIntRange(0,10);
        stack
            ..immediateEffect(
                new PixellateEffect(size))

            ..immediateEffect(
                new ImpressionismEffect(size, alphaMultiplier: 0.5));
    }

    CanvasElement getNextFrame() {
        print("getting the next frame, animations are $animations");
        index ++;
        if(index >= animations.length) {
            index = 0;
        }
        //print("next frame is $index, so that's ${animations[index]}");
        return animations[index];
    }



}