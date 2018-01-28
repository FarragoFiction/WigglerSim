//just a list of pets that i have. making it more than just a list in case i need it to.
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import "../GameShit/Empress.dart";
import 'dart:math' as Math;
import "../GameShit/GameObject.dart";
import 'dart:convert';



//TODO have a "from JSON" constructor
class PetInventory {
    static String PETSLIST = "petsList";
    static String ALUMNI = "alumni";
    static String EMPRESS = "empress";

    int pageNumber = 0;
    int alumniPerPage = 6;


    List<Pet> pets = new List<Pet>();
    //for now just for fun but later could be used for interesting things
    //like having life events and causes of death change based on current empress
    //if violent empress, odds of violent death go up
    //if non violent, odds go down, and mutants have no extra cause of death
    //how to determine if violent. extra non stat bool?
    //maybe also influences game features. option to cull grubs if you have a violent empress.
    Empress rulingEmpress;
    List<Troll> alumni = new List<Troll>();



    List<Troll> get last12Alumni {
        if(alumni.isEmpty) return alumni;
        List<Troll> reversedAlumni = new List.from(alumni.reversed);
        int length = Math.min(reversedAlumni.length-1, 12);
        return reversedAlumni.sublist(0, length);

    }

    PetInventory();

    PetInventory.fromJSON(String json){
        //print("loading pet inventory with json $json");
        loadFromJSON(json);
    }

    bool get hasRoom => (pets.length < Empress.instance.maxGrubs);

    List<Troll> alumniWithSign(int signNumber) {
       // static Iterable<SBURBClass> get canon => _classes.values.where((SBURBClass c) => c.isCanon);
        Iterable<Troll> tmp = alumni.where((Troll t) {
            //sign is stored in doll.
            HomestuckTrollDoll d = t.doll as HomestuckTrollDoll;
            return d.canonSymbol.imgNumber == signNumber;
        });
        return new List<Troll>.from(tmp);

    }


    //for hatching eggs and shit
    void replacePet(Pet original, Pet replacement) {
        if(!pets.contains(original)) return;
        //print("replacing ${original.name} with ${replacement.name}");
        if(!original.name.contains("Egg")) replacement.name = original.name;
        replacement.external = original.external;
        replacement.curious = original.curious;
        replacement.loyal = original.loyal;
        replacement.energetic = original.energetic;
        replacement.idealistic = original.idealistic;
        replacement.patience = original.patience;
        replacement.castesRemembered = original.castesRemembered;
        replacement.namesRemembered = original.namesRemembered;
        replacement.itemsRemembered = original.itemsRemembered;


        int index = pets.indexOf(original);
        pets[index] = replacement;
    }

    void loadFromJSON(String json) {
       // print("In pet inventory, json is $json");
        JSONObject jsonObj = new JSONObject.fromJSONString(json);
        String idontevenKnow = jsonObj[PETSLIST];
        loadPetsFromJSON(idontevenKnow);
        idontevenKnow = jsonObj[ALUMNI];
        loadAlumniFromJSON(idontevenKnow);
        String empressJson = jsonObj[EMPRESS];
        if(empressJson != null) {
            Pet p = Pet.loadPetFromJSON(null, new JSONObject.fromJSONString(empressJson));
            print("Empress loaded, ${p.name} with hatchmates ${p.hatchmatesString}.");
            rulingEmpress = new Empress(p);
        }

    }

    void loadPetsFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;
        List<dynamic> what = JSON.decode(idontevenKnow);
        //print("what json is $what");
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            pets.add(Pet.loadPetFromJSON(null,j));
        }
    }

    void graduate(Troll troll) {
        pets.remove(troll);
        alumni.add(troll);
        GameObject.instance.save();
    }

    void loadAlumniFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;
        List<dynamic> what = JSON.decode(idontevenKnow);
        //print("what json is $what");
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            alumni.add(Pet.loadPetFromJSON(null,j) as Troll);
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
                //print("Pet is $p, percent is ${p.percentToChange}, time to change is ${p.millisecondsToChange/1000/60/60} hours,");
                if(p is Egg) {
                    subContainer.append(hatchButton);
                }else if(p is Grub) {
                    hatchButton.text = "Spin Cocoon";
                    subContainer.append(hatchButton);
                }else if(p is Cocoon) {
                    hatchButton.text = "Pupate (Get ${Empress.instance.priceOfTroll(p)})";
                    subContainer.append(hatchButton);
                }
            }

            CanvasElement canvas = await drawPet(subContainer, p);
            subContainer.append(p.makeDollLoader());



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
                    HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
                    t.mutantEyes();
                    GameObject.instance.save();
                }else if(p is Grub) {
                    print("3,2,1, POOF! Spinning a cocoon!");
                    Pet tmp = new Cocoon(p.doll);
                    changePetIntoOtherPet(p, tmp, subContainer, canvas, hatchButton);
                }else if(p is Cocoon) {
                    print("3,2,1, POOF! Holy Fuck it's a Troll!");
                    Pet tmp = new Troll(p.doll);
                    GameObject.instance.player.caegers += Empress.instance.priceOfTroll(p);
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

    void drawPaginationControls(Element container) {
        DivElement subContainer = new DivElement();

        SpanElement totalElement = new SpanElement();
        totalElement.text = "Number Alumni: ${alumni.length}";
        totalElement.style.textAlign = "left";
        subContainer.append(totalElement);

        DivElement subContainer2 = new DivElement();
        subContainer2.style.textAlign = "right";
        SpanElement explanation = new SpanElement();
        subContainer2.text = "Number Alumni per Page: ";
        subContainer2.append(explanation);

        DivElement subContainer3 = new DivElement();
        subContainer3.style.textAlign = "right";
        SpanElement explanation3 = new SpanElement();
        subContainer3.text = "Page: ";
        subContainer3.append(explanation3);

        for(int i = 0; i< 5; i++) {
            AnchorElement tmp = new AnchorElement();
            tmp.href = "#";
            tmp.style.paddingLeft = "10px";
            int baseNumPerPage = 6;
            int myNumber = baseNumPerPage * Math.pow(2,i);
            if(myNumber == alumniPerPage) tmp.style.color = "white";

            tmp.text = "${myNumber}";
            subContainer2.append(tmp);

            tmp.onClick.listen((e) {
                for(Element e in container.children) {
                    e.remove();
                }
                alumniPerPage = myNumber;
                drawAlumni(container);
            });
        }


        for(int i = 0; i< alumni.length/alumniPerPage; i++) {
            AnchorElement tmp = new AnchorElement();
            tmp.href = "#";
            tmp.style.paddingLeft = "10px";
            int baseNumPerPage = 6;
            int myNumber = i;
            if(myNumber == pageNumber) tmp.style.color = "white";

            tmp.text = "${myNumber}";
            subContainer3.append(tmp);

            tmp.onClick.listen((e) {
                for(Element e in container.children) {
                    e.remove();
                }
                pageNumber = myNumber;
                drawAlumni(container);
            });
        }

        container.append(subContainer);
        container.append(subContainer2);
        container.append(subContainer3);
    }


    Future<Null> drawAlumni(Element container) async{
        drawPaginationControls(container);


        List<Troll> reversedAlumni = new List<Troll>.from(alumni.reversed);
        for(int i = (pageNumber*alumniPerPage); i<(Math.min((pageNumber*alumniPerPage) + alumniPerPage, alumni.length)); i++) {
            Troll p = reversedAlumni[i];
            SpanElement subContainer = new SpanElement();
            subContainer.style.width = "${p.width}px";
            subContainer.classes.add("petInventorySlot");

            subContainer.append(p.makeDollLoader());

            container.append(subContainer);


            await drawPet(subContainer, p);

        }
    }

    Future<Null> drawSigns(Element container) async{
        //first, get all signs
        if(Sign.allSigns.isEmpty) Sign.initAllSigns();
        DivElement subContainer = new DivElement();
        for(Sign s in Sign.allSigns) {
            await s.draw(subContainer);
        }
        container.append(subContainer);
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
        if(p is Troll) {
            HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
            t.mutantWings();
        }else if(p is Grub) {
            HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
            t.mutantEyes();
        }
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
            int price = Empress.instance.priceOfTroll(p);
            button.text = "Choose ${price}";
            subContainer.append(button);
            if(price <= GameObject.instance.player.caegers) {
                button.onClick.listen((e) {
                    //add wiggler to inventory. save. refresh.
                    pets.add(p);
                    GameObject.instance.player.caegers += -1* price;
                    GameObject.instance.save();
                    //subContainer.remove();
                    window.location.href= "petInventory.html";
                });
            }else {
                button.disabled;
                button.classes.add("invertButton");
                button.text = "Cannot Afford to Choose ${price}";
            }

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

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(Pet p in pets) {
           // print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[PETSLIST] = jsonArray.toString(); //will this work?
        if(rulingEmpress != null) json[EMPRESS] = rulingEmpress.troll.toJson().toString();

        jsonArray = new List<JSONObject>();
        for(Troll p in alumni) {
            //print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[ALUMNI] = jsonArray.toString(); //will this work?

        //print("pet inventory json is: ${json} and pets are ${pets.length}");
        return json;
    }

    Future<CanvasElement> drawPet(Element container, Pet p, [CanvasElement canvas]) async {
        //print("drawing pet $p");
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