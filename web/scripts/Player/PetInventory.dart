//just a list of pets that i have. making it more than just a list in case i need it to.
import '../Pets/CapsuleTIMEHOLE.dart';
import "../Pets/PetLib.dart";
import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import "../GameShit/Empress.dart";
import 'dart:math' as Math;
import "../GameShit/GameObject.dart";
import 'dart:convert';
import "../Controllers/navbar.dart";
import 'package:CommonLib/Utility.dart';



//TODO have a "from JSON" constructor
class PetInventory {
    static String PETSLIST = "petsList";
    static String FUCKPILE = "FUCKPILE";
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

    void addPet(Pet pet) {
        pets.add(pet);
    }

    //when i call this it will be a pet loaded from a capsule, not from the inventory
    void removePetDiffObjects(Pet pet) {
        Pet found;
        for(Pet p in pets) {
            if(p.name == pet.name) {
                for(int i =0; i<pet.stats.length; i++) {
                    if(pet.stats[i] != p.stats[i]) {
                        break;
                    }
                }
                found = p;
                break;
            }
        }
        pets.remove(found);
    }



    List<Troll> get last12Alumni {
        if(alumni.isEmpty) return alumni;
        List<Troll> reversedAlumni = new List.from(alumni.reversed);
        int length = Math.min(reversedAlumni.length-1, 12);
        return reversedAlumni.sublist(0, length);
    }

    String get mostCommonCaste {

    }

    List<String> get completedCastes {

    }

    PetInventory();

    PetInventory.fromJSON(Map<String,dynamic> json){
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

    List<Troll> alumniWithCaste(String caste) {
        // static Iterable<SBURBClass> get canon => _classes.values.where((SBURBClass c) => c.isCanon);
        Iterable<Troll> tmp = alumni.where((Troll t) {
            //sign is stored in doll.
            HomestuckTrollDoll d = t.doll as HomestuckTrollDoll;
            return d.bloodColorToWord((d.palette as HomestuckPalette).aspect_light) == caste;
        });
        return new List<Troll>.from(tmp);
    }

    String get favoriteCaste {
        int amount = 0;
        String fCaste = null;

        for(String caste in HomestuckTrollDoll.castes) {
            int casteAmount = alumniWithCaste(caste).length;
            //print("casteAmount is $casteAmount");
            if(casteAmount >= amount) {
                amount = casteAmount;
                fCaste = caste;
            }
        }
        return fCaste;
    }


    //for hatching eggs and shit
    void replacePet(Pet original, Pet replacement) {
        if(!pets.contains(original)) return;
        //print("replacing ${original.name} with ${replacement.name}");
        if(!original.name.contains("Egg")) replacement.name = original.name;
        replacement.corrupt = original.corrupt;
        replacement.purified = original.purified;
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
        //only assign sign AFTER transferring stats. omfg.
        if(replacement is Troll) (replacement as Troll).assignSign();
    }

    void loadFromJSON(Map<String,dynamic> json) {
       // print("In pet inventory, json is $json");
        loadPetsFromJSON(json[PETSLIST]);
        loadAlumniFromJSON(json[ALUMNI]);
        Map<String,dynamic> empressJson = json[EMPRESS];
        if(empressJson != null) {
            Pet p = Pet.loadPetFromJSON(empressJson);
            print("Empress loaded, ${p.name} with hatchmates ${p.hatchmatesString}.");
            rulingEmpress = new Empress(p);
        }

    }

    void loadPetsFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;
        List<dynamic> what = jsonDecode(idontevenKnow);
        //print("what json is $what");
        for(dynamic d in what) {
            pets.add(Pet.loadPetFromJSON(d));
        }
    }

    void graduate(Troll troll) {
        pets.remove(troll);
        alumni.add(troll);
        GameObject.instance.save();
    }

    void loadAlumniFromJSON(List<Map<String,dynamic>> json) {
        if(json == null) return;
        //print("what json is $what");
        for(dynamic d in json) {
            alumni.add(Pet.loadPetFromJSON(d) as Troll);
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


            SpanElement nameElement = new SpanElement();
            subContainer.append(nameElement);

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
            renameButton(nameElement,canvas,p);

            renderHairDressingButton(subContainer, p, canvas);
            renderClothesStylistButton(subContainer, p, canvas);
            renderTIMEHOLEButton(subContainer,p,canvas);


            hatchButton.onClick.listen((e) {
                if(p is Egg) {
                    print("3,2,1, POOF! Hatching an egg!");
                    Pet tmp = new Grub(p.doll);
                    changePetIntoOtherPet(p, tmp, subContainer, canvas, hatchButton);
                    HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
                    bool force = getParameterByName("eyes",null) == "mutant"; // getParameterByName("eyes",null) == "mutant")
                    t.mutantEyes(force);
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
                    //print("HOLY FUCK TURN THIS BACK ON");
                    if(getParameterByName("cheater",null) == "jrbutitsforareallygoodpurpose") {

                    }else {
                        //window.alert("refresh again");
                         window.location.href= "goodbye.html";
                    }
                }
            });



            randomButton.onClick.listen((e) {
                //add wiggler to inventory. save. refresh.
                updateNameElement(subContainer, p, canvas);
                //window.location.reload();

            });

        }
    }

    void fuckButton(Element container, Troll p) {
        bool disabled = false;
        if(window.localStorage.containsKey(FUCKPILE) && window.localStorage[FUCKPILE].contains("${p.toJSON()}")) {
            disabled = true;
        }
        ButtonElement button = new ButtonElement();
        ImageElement bucket = new ImageElement(src: "images/buckit.png");
        ImageElement turtle = new ImageElement(src: "images/turtle.png");
        ImageElement tree = new ImageElement(src: "images/tree.png");
        button.append(bucket);
        button.append(turtle);
        button.append(tree);
        if(!disabled) {
            button.onClick.listen((Event e) {
                List<Map<String, dynamic>> jsonArray = new List<Map<String, dynamic>>();
                if (window.localStorage.containsKey(FUCKPILE)) {
                    String idontevenKnow = window.localStorage[FUCKPILE];
                    List<dynamic> what = jsonDecode(idontevenKnow);
                    //print("what json is $what");
                    for (dynamic d in what) {
                        //print("dynamic json thing is  $d");
                        JSONObject j = new JSONObject();
                        j.json = d;
                        jsonArray.add(j);
                    }
                }
                jsonArray.add(p.toJSON());
                window.localStorage[FUCKPILE] = jsonArray.toString();
                window.location.href = "viewAlumni.html?talking=turtle";
            });
        }else {
            button.classes.add("disabledButton");
        }


        container.append(button);
    }

    void renameButton(SpanElement subContainer, CanvasElement canvas, Pet p) {
      TextInputElement customName = new TextInputElement();
      customName.value = p.name;
      customName.size = 40;
      subContainer.append(customName);

      ButtonElement button = new ButtonElement();
      String warning = "";
      if(alumni.contains(p)) warning = "(Will not effect epitaph.)";
      button.text = "Rename $warning";
      subContainer.append(button);

      button.onClick.listen((e) {
          //otherwise they will get out of sync
          if(rulingEmpress != null && rulingEmpress.troll != null) {
              if (Doll.removeLabelFromString(
                  rulingEmpress.troll.doll.toDataBytesX()) ==
                  Doll.removeLabelFromString(p.doll.toDataBytesX())) {
                  rulingEmpress.troll.name = customName.value;
              }
          }
          p.name = customName.value;
          GameObject.instance.save();
          drawPet(subContainer,p, canvas);
      });
    }

    Future<Null> updateNameElement(Element subContainer, Pet p, CanvasElement canvas) async{
        p.randomAsFuckName();
        GameObject.instance.save();
        drawPet(subContainer,p, canvas);
    }

    void drawPaginationControls(Element container, List<Troll> trolls) {
        DivElement subContainer = new DivElement();

        SpanElement totalElement = new SpanElement();
        totalElement.text = "Number Alumni: ${trolls.length}";
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
                drawAlumni(container,trolls);
            });
        }


        for(int i = 0; i< trolls.length/alumniPerPage; i++) {
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
                drawAlumni(container,trolls);
            });
        }

        container.append(subContainer);
        container.append(subContainer2);
        container.append(subContainer3);
    }

    void drawLifeSimButton(Element container, Troll troll) {
        if(Empress.instance.allowsSpeculation()) {
            ButtonElement button = new ButtonElement()
                ..text = "I wonder what their life was like???";
            container.append(button);
            //TODO store this troll in a special data slot
            button.onClick.listen((Event e) {
                window.localStorage["SELECTEDALUMNI"] = troll.toJSON().toString();
                //window.location.href = "../LifeSim/alumniLife.html";
                window.open("../LifeSim/alumniLife.html", "_blank");
            });
        }
    }


    //pass in subset of alumni if that's what you want
    Future<Null> drawAlumni(Element container, [List<Troll> trolls]) async{
        if(trolls == null) trolls = alumni;
        print ("Alumni is of type ${trolls.runtimeType}");
        drawPaginationControls(container, trolls);

        List<Troll> reversedAlumni = new List<Troll>.from(trolls.reversed);
        for(int i = (pageNumber*alumniPerPage); i<(Math.min((pageNumber*alumniPerPage) + alumniPerPage, trolls.length)); i++) {
            Troll p = reversedAlumni[i];
            SpanElement subContainer = new SpanElement();
            subContainer.style.width = "${p.width}px";
            subContainer.classes.add("petInventorySlot");
            SpanElement nameElement = new SpanElement();
            subContainer.append(nameElement);
            subContainer.append(p.makeDollLoader());

            container.append(subContainer);


            CanvasElement c = await drawPet(subContainer, p);
            renameButton(nameElement,c,p);
            fuckButton(nameElement,p);

            renderHairDressingButton(subContainer, p, c);
            renderClothesStylistButton(subContainer, p, c);
            drawLifeSimButton(subContainer, p);



        }
    }

    //pass in subset of alumni if that's what you want
    void makeOverAlumni([List<Troll> trolls]){
        if(trolls == null) trolls = alumni;
        List<Troll> reversedAlumni = new List<Troll>.from(trolls.reversed);
        for(int i = (pageNumber*alumniPerPage); i<(Math.min((pageNumber*alumniPerPage) + alumniPerPage, trolls.length)); i++) {
            Troll p = reversedAlumni[i];
            p.makeOver();
        }
    }

    Future<Null> drawSigns(Element container) async{
        DivElement d = new DivElement();
        d.text = "Click obtained Signs to view Alumni with that Sign.";
        container.append(d);
        //first, get all signs
        if(Sign.allSigns.isEmpty) Sign.initAllSigns();
        DivElement subContainer = new DivElement();
        DivElement subContainerAlumni = new DivElement();
        container.append(subContainer);
        container.append(subContainerAlumni);
        for(Sign s in Sign.allSigns) {
            await s.draw(subContainer,subContainerAlumni);
        }


    }

    //gets first troll i find.  returns null if none.
    Troll getGraduatingTroll() {
        for(Pet p in pets) {
            if(p is Troll) return p;
        }
    }

    Future<Null> changePetIntoOtherPet(Pet p, Pet tmp, Element subContainer, CanvasElement canvas, ButtonElement hatchButton) async{
        //replace egg with hatched grub
        replacePet(p, tmp);
        p = tmp;


        hatchButton.style.display = "none";
        if(p is Troll) {

            HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
            int newBody = new Random().nextInt(t.extendedBody.maxImageNumber+1);
            if(p.name.contains("Nidhogg")) {
                //TODO make lamia
                p.doll = Doll.convertOneDollToAnother(p.doll, new HomestuckLamiaDoll());
                t = p.doll as HomestuckTrollDoll;
                newBody = new Random().nextInt(t.extendedBody.maxImageNumber+1);

            }
            //if i don't do this grubs will be stuck with one of two bodies
            t.extendedBody.imgNumber = newBody;
            print("new body is $newBody");
            t.body.imgNumber = newBody;
            bool force = getParameterByName("wings",null) == "mutant"; // getParameterByName("eyes",null) == "mutant")
            t.mutantWings(force);


        }else if(p is Grub) {
            HomestuckTrollDoll t = p.doll as HomestuckTrollDoll;
            bool force = getParameterByName("eyes",null) == "mutant"; // getParameterByName("eyes",null) == "mutant")
            t.mutantEyes(force);
        }
        if(p.corrupt) tmp.corrupt;
        await drawPet(subContainer,tmp, canvas);
        //wait to save till after so that if the name gets set there it gets saved
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

       // print("Am I confused? Random jade sign is ${HomestuckTrollDoll.randomJadeSign} and the sign i picked is ${(starters[5].doll as HomestuckGrubDoll).canonSymbol.imgNumber} ");
        for(Pet p in starters) {
            SpanElement subContainer = new SpanElement();
            subContainer.style.width = "${p.width}px";
            subContainer.style.border = "solid black 1px";
            subContainer.classes.add("petInventorySlot");
            container.append(subContainer);
           // print("making button for egg with sign of ${(p.doll as HomestuckGrubDoll).canonSymbol.imgNumber}");
            ButtonElement button = new ButtonElement();
            int price = Empress.instance.priceOfTroll(p);
            button.text = "Choose ${p.name} ${price}";
            subContainer.append(button);
            drawPet(subContainer, p);

            if(price <= GameObject.instance.player.caegers) {
                button.onClick.listen((e) {
                    //add wiggler to inventory. save. refresh.
                    if(getParameterByName("debug",null) == "eggs") {
                        //not even with a cheat can you go over max
                        for(int i = 0; i < ( Empress.instance.maxGrubs-pets.length); i++) {
                            GameObject.instance.player.caegers += -1* price; //not free.
                            HomestuckGrubDoll newDoll = new HomestuckGrubDoll();
                            newDoll.copyPalette(p.doll.palette);
                            pets.add(new Egg(newDoll));
                        }
                    }
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

    Map<String, dynamic> toJSON() {
        Map<String, dynamic> ret = new Map<String, dynamic>();
        if(rulingEmpress != null) ret[EMPRESS] = rulingEmpress.troll.toJSON();

        List<Map<String, dynamic>> alumniJSON = new List<Map<String,dynamic>>();
        alumni.forEach((Troll troll)=> alumniJSON.add(troll.toJSON()));
        ret[ALUMNI] = alumniJSON;

        List<Map<String, dynamic>> petJSON = new List<Map<String,dynamic>>();
        pets.forEach((Pet pet)=> petJSON.add(pet.toJSON()));
        print("hey pet json is $petJSON");
        ret[PETSLIST] = petJSON;
        return ret;
    }


    void renderHairDressingButton(Element subcontainer,Pet p, CanvasElement canvas) {

    //remember that tiem every fucking pet got overridden to look like edna mode. yup.pepperridge farm remembers
        if(getParameterByName("mode",null) == "edna" || Empress.instance.allowHairDressing() ) {
            ButtonElement hairCutButton = new ButtonElement();
            hairCutButton.text = "Royal Hair Makeover!!!";
            subcontainer.append(hairCutButton);
            hairCutButton.onClick.listen((Event e) {
                p.makeOver();
                GameObject.instance.save();
                p.canvas = null;
                drawPet(subcontainer, p, canvas);
            });
        }
    }

    void renderTIMEHOLEButton(Element subcontainer,Pet p, CanvasElement canvas) {

        //remember that tiem every fucking pet got overridden to look like edna mode. yup.pepperridge farm remembers
        if(getParameterByName("trade",null) == "wonder" || Empress.instance.allowTIMEHOLE() ) {
            ButtonElement hairCutButton = new ButtonElement();
            hairCutButton.text = "Trade with TIMEHOLE???";
            subcontainer.append(hairCutButton);
            hairCutButton.onClick.listen((Event e) {
                window.localStorage["TIMEHOLE"] = new CapsuleTIMEHOLE(p, GameObject.instance.player.name).toJson().toString();
                window.location.href = "TIMEHOLE.html";
            });
        }

        if(getParameterByName("trade",null) == "wonder" || Empress.instance.allowsAbdicatingWigglersToTIMEHOLE() ) {
            ButtonElement hairCutButton = new ButtonElement();
            hairCutButton.text = "Abandon into TIMEHOLE???";
            subcontainer.append(hairCutButton);
            hairCutButton.onClick.listen((Event e) {
                window.localStorage["TIMEHOLE"] = new CapsuleTIMEHOLE(p, GameObject.instance.player.name).toJson().toString();
                window.location.href = "TIMEHOLE.html?abandon=youmonster";
            });
        }
    }

    //meenah decided how all of alternia was going to dress, so can you.
    void renderClothesStylistButton(Element subcontainer,Pet p, CanvasElement canvas) {
        //remember that tiem every fucking pet got overridden to look like edna mode. yup.pepperridge farm remembers
        if((getParameterByName("mode",null) == "edna" || Empress.instance.allowClothesStyling()) && p is Troll) {
            ButtonElement hairCutButton = new ButtonElement();
            hairCutButton.text = "Royal Clothes Makeover!!!";
            subcontainer.append(hairCutButton);
            hairCutButton.onClick.listen((Event e) {
                p.clothesMakeOver();
                GameObject.instance.save();
                p.canvas = null;
                drawPet(subcontainer, p, canvas);
            });
        }
    }


    Future<CanvasElement> drawPet(Element container, Pet p, [CanvasElement canvas]) async {
        //print("drawing pet $p");
        if(p.doll != null && p.name == p.doll.name) { //still is the dfeault name
           await  p.randomAsFuckName();
        }
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