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


abstract class AIObject {
    int x;
    int y;
    double _scaleX = 1.0;
    double _scaleY = 1.0;
    double rotation = 0.0;
    AnimationObject idleAnimation = new AnimationObject();



    AIObject({int this.x: 0, int this.y: 100}) {
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