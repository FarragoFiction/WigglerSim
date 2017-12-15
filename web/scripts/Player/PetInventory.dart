//just a list of pets that i have. making it more than just a list in case i need it to.
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import 'package:json_object/json_object.dart';
import "../GameShit/GameObject.dart";
import 'dart:convert';



//TODO have a "from JSON" constructor
class PetInventory {
    static int MAXPETS = 6;
    static String PETSLIST = "petsList";
    static String ALUMNI = "alumni";

    List<Pet> pets = new List<Pet>();
    List<Troll> alumni = new List<Troll>();

    PetInventory();

    PetInventory.fromJSON(String json){
        print("loading pet inventory with json $json");
        loadFromJSON(json);
    }

    bool get hasRoom => (pets.length <= MAXPETS);


    //for hatching eggs and shit
    void replacePet(Pet original, Pet replacement) {
        if(!pets.contains(original)) return;
        print("replacing ${original.name} with ${replacement.name}");
        if(!original.name.contains("Egg")) replacement.name = original.name;
        int index = pets.indexOf(original);
        pets[index] = replacement;
    }

    void loadFromJSON(String json) {
        print("In pet inventory, json is $json");
        JsonObject jsonObj = new JsonObject.fromJsonString(json);
        String idontevenKnow = jsonObj[PETSLIST];
        loadPetsFromJSON(idontevenKnow);
        idontevenKnow = jsonObj[ALUMNI];
        loadAlumniFromJSON(idontevenKnow);

    }

    void loadPetsFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;
        List<dynamic> what = JSON.decode(idontevenKnow);
        print("what json is $what");
        for(dynamic d in what) {
            print("dynamic json thing is  $d");
            pets.add(Pet.loadPetFromJSON(null,d));
        }
    }

    void loadAlumniFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;
        List<dynamic> what = JSON.decode(idontevenKnow);
        print("what json is $what");
        for(dynamic d in what) {
            print("dynamic json thing is  $d");
            alumni.add(Pet.loadPetFromJSON(null,d) as Troll);
        }
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

            TextInputElement customName = new TextInputElement();
            customName.value = p.name;
            customName.size = 40;
            subContainer.append(customName);

            ButtonElement button = new ButtonElement();
            button.text = "Rename";
            subContainer.append(button);

            ButtonElement randomButton = new ButtonElement();
            randomButton.text = "Random Name";
            subContainer.append(randomButton);

            //only gets appended if it's a hatchable egg.
            ButtonElement hatchButton = new ButtonElement();
            hatchButton.text = "Hatch";

            if(p.percentToChange >= 1.0) {
                print("Pet is $p, percent is ${p.percentToChange}, time to change is ${p.millisecondsToChange/1000/60/60} hours,");
                if(p is Egg) {
                    subContainer.append(hatchButton);
                }else if(p is Grub) {
                    hatchButton.text = "Spin Cocoon";
                    subContainer.append(hatchButton);
                }else if(p is Cocoon) {
                    hatchButton.text = "Pupate";
                    subContainer.append(hatchButton);
                }
            }

            CanvasElement canvas = await drawPet(subContainer, p);


            button.onClick.listen((e) {
                p.name = customName.value;
                GameObject.instance.save();
                drawPet(subContainer,p, canvas);
            });

            hatchButton.onClick.listen((e) {
                if(p is Egg) {
                    print("3,2,1, POOF! Hatching an egg!");
                    Pet tmp = new Grub(p.doll);
                    changePetIntoOtherPet(p, tmp, subContainer, canvas, hatchButton);
                }else if(p is Grub) {
                    print("3,2,1, POOF! Spinning a cocoon!");
                    Pet tmp = new Cocoon(p.doll);
                    changePetIntoOtherPet(p, tmp, subContainer, canvas, hatchButton);
                }else if(p is Cocoon) {
                    print("3,2,1, POOF! Holy Fuck it's a Troll!");
                    Pet tmp = new Troll(p.doll);
                    changePetIntoOtherPet(p, tmp, subContainer, canvas, hatchButton);
                    window.location.href= "goodbye.html";
                }
            });



            randomButton.onClick.listen((e) {
                //add wiggler to inventory. save. refresh.
                p.name = p.randomAsFuckName();
                GameObject.instance.save();
                drawPet(subContainer,p, canvas);
                //window.location.reload();

            });

        }
    }


    //gets first troll i find.  returns null if none.
    Troll getGraduatingTroll() {
        for(Pet p in pets) {
            if(p is Troll) return p;
        }
    }

    void changePetIntoOtherPet(Pet p, Pet tmp, Element subContainer, CanvasElement canvas, ButtonElement hatchButton) {
        //replace egg with hatched grub
        GameObject.instance.save();
        replacePet(p, tmp);
        p = tmp;
        drawPet(subContainer,tmp, canvas);
        hatchButton.style.display = "none";
        GameObject.instance.save();
    }

    //todo can adopt a troll grub directly via importing string.
    Future<Null> drawAdoptables(Element container) async{
        List<Pet> starters = new List<Pet>();
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomBurgundySign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomBronzeSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomGoldSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomLimeSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomOliveSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomJadeSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomTealSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomCeruleanSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomIndigoSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomPurpleSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomVioletSign)));
        starters.add(new Egg(new HomestuckGrubDoll(HomestuckTrollDoll.randomFuchsiaSign)));
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
                pets.add(p);
                GameObject.instance.save();
                window.location.href= "petInventory.html";

            });
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
                pets.add(p);
                GameObject.instance.save();
                window.location.reload();

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

        jsonArray = new List<JsonObject>();
        for(Troll p in alumni) {
            print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[ALUMNI] = jsonArray.toString(); //will this work?

        print("pet inventory json is: ${json} and pets are ${pets.length}");
        return json;
    }

    Future<CanvasElement> drawPet(Element container, Pet p, [CanvasElement canvas]) async {
        print("drawing pet $p");
        DivElement canvasContainer = new DivElement();
        if(canvas == null) {
            canvas = new CanvasElement(width: p.textWidth, height: p.textHeight);
            canvasContainer.append(canvas);
        }

        canvasContainer.style.width = "${p.width}px";
        canvasContainer.classes.add("canvasContainer");
        container.append(canvasContainer);

        CanvasElement textCanvas = await p.drawStats();
        canvas.context2D.drawImage(textCanvas,0,0);

        //this is the thing we'll hang on. so do it last.
        CanvasElement grubCanvas = await p.draw();
        canvas.context2D.drawImage(grubCanvas,10,10);

        return canvas;

    }



}