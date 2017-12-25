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

class AIPet {
    int x;
    int y;
    double _scaleX = 1.0;
    double _scaleY = 1.0;
    double rotation = 0.0;
    Grub grub;
    AnimationObject idleAnimation = new AnimationObject();

    AIPet(Grub this.grub, {x: 0, y: 0}) {
        //TODO i need to give the grub 0 and render to a canvas, then give it 1 and render to a canvas.
        //add both to idle animation.
    }

    Future<Null> draw(CanvasElement canvas) async {
        /*
            TODO:
                Need to draw one of my idle animations at x,y scale and rotation

                also need to figure out how to add text or emoticon
         */
    }


}


class AnimationObject {
    List<CanvasElement> animations = new List<CanvasElement>();
    int index;

    void addAnimationFrame(CanvasElement canvas, [int index = -13]) {
        if(index >= 0) {
            animations[index] = canvas;
        }else {
            animations.add(canvas);
        }
    }



}