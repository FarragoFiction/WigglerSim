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
            subContainer.style.width = "${p.width}px";
            subContainer.classes.add("petInventorySlot");

            container.append(subContainer);
            drawPet(subContainer, p);
        }
    }

    Future<Null> drawPet(Element container, Pet p) async {
        DivElement canvasContainer = new DivElement();
        CanvasElement canvas = new CanvasElement(width: p.textWidth, height: p.textHeight);
        canvasContainer.append(canvas);

        canvasContainer.style.width = "${p.width}px";
        canvasContainer.classes.add("canvasContainer");
        container.append(canvasContainer);

        CanvasElement textCanvas = await p.drawStats();
        canvas.context2D.drawImage(textCanvas,0,0);

        //this is the thing we'll hang on. so do it last.
        CanvasElement grubCanvas = await p.draw();
        canvas.context2D.drawImage(grubCanvas,10,10);

    }



}