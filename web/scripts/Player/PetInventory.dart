//just a list of pets that i have. making it more than just a list in case i need it to.
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import 'package:json_object/json_object.dart';
import "../GameShit/GameObject.dart";


//TODO have a "from JSON" constructor
class PetInventory {
    static String PETSLIST = "petsList";
    List<Pet> pets = new List<Pet>();

    PetInventory();

    PetInventory.fromJSON(String json){
        print("loading pet inventory with json $json");
        loadFromJSON(json);
    }

    void loadFromJSON(String json) {
        print("In pet inventory, json is $json");
        JsonObject jsonObj = new JsonObject.fromJsonString(json);
        //okay. this SHOULD be an array or some shit. But JSON Arrays aren't things. bluh.
    }

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

    Future<Null> drawStarters(Element container) async{
        List<Pet> starters = new List<Pet>();
        starters.add(new Grub(new HomestuckGrubDoll()));
        starters.add(new Grub(new HomestuckGrubDoll()));
        starters.add(new Grub(new HomestuckGrubDoll()));

        for(Pet p in starters) {
            SpanElement subContainer = new SpanElement();
            subContainer.style.width = "${p.width}px";
            subContainer.classes.add("petInventorySlot");
            container.append(subContainer);
            drawPet(subContainer, p);
            ButtonElement button = new ButtonElement();
            button.text = "Choose";
            subContainer.append(button);
            button.onClick.listen((e) {
                //add wiggler to inventory. save. refresh.
                window.alert("TODO");
                pets.add(p);
                GameObject.instance.save();
                //window.location.reload();

            });
        }

    }

    JsonObject toJson() {
        JsonObject json = new JsonObject();
        List<JsonObject> jsonArray = new List<JsonObject>();
        for(Pet p in pets) {
            print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[PETSLIST] = jsonArray.toString(); //will this work?
        print("pet inventory json is: ${json} and pets are ${pets.length}");
        return json;
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