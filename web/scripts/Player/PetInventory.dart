//just a list of pets that i have. making it more than just a list in case i need it to.
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';

//TODO have a "from JSON" constructor
class PetInventory {
    List<Pet> pets = new List<Pet>();

    void addRandomGrub() {
        pets.add(new Grub(new HomestuckGrubDoll()));
    }

    Future<Null> drawInventory(Element container) async{
        for(Pet p in pets) {
            SpanElement subContainer = new SpanElement();
            container.append(subContainer);
            drawPet(subContainer, p);
        }
    }

    Future<Null> drawPet(Element container, Pet p) async {
        CanvasElement canvas = await p.draw();
        container.append(canvas);
    }



}