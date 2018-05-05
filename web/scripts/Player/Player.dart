//a player has an inventory.
// a player has a doll.
//a player has a graduatesList.
import 'package:DollLibCorrect/DollRenderer.dart';
import "PetInventory.dart";
import "ItemInventory.dart";
import 'dart:html';
import "../Pets/JSONObject.dart";
import 'dart:async';
import 'dart:convert';
import "../Pets/Sign.dart";

class Player {
    static String DATASTRING = "dataString";
    static String LASTPLAYED = "lastPlayed";
    static String LASTALLOWENCE = "lastAllowence";
    static String MONEYJSON = "caegers";
    static String DOLLSAVEID = "WigglerCaretaker";
    static String PETINVENTORY = "PetInventory";
    static String ITEMINVENTORY = "ItemInventory";
    static String NAMEKEY = "name";
    static String UNIMPORTANT = "UNIMPORTANT";
    static String INCREASINGLY_IMPORTANT = "INCREASINGLY IMPORTANT";



    Doll doll;
    CanvasElement canvas;
    int width = 400;
    int height = 300;
    String name = UNIMPORTANT;

    PetInventory petInventory;
    ItemInventory itemInventory;

    DateTime lastPlayed;
    DateTime oldLastPlayed;

    int caegers = 0;
    DateTime lastGotAllowence;

    //TODO call this on empress
    int get timeBetweenAllowence => 24*60*60* 1000; //24 hours



    Player.fromJSON(String json){
        loadFromJSON(json);
    }



     void loadFromJSON(String json) {
        print("loading player from json");
        JSONObject jsonObj = new JSONObject.fromJSONString(json);
        //print("json object is ${jsonObj}");

        String dataString = jsonObj[DATASTRING];
        String lastPlayedString = jsonObj[LASTPLAYED];
        if(jsonObj[LASTALLOWENCE] != null) {
            String lastAllowenceString = jsonObj[LASTALLOWENCE];
            lastGotAllowence = new DateTime.fromMillisecondsSinceEpoch(int.parse(lastAllowenceString));
        }

        if(jsonObj[MONEYJSON] != null) {
            caegers = int.parse(jsonObj[MONEYJSON]);
        }

        doll = Doll.loadSpecificDoll(dataString);
        oldLastPlayed = new DateTime.fromMillisecondsSinceEpoch(int.parse(lastPlayedString));
        if(jsonObj[NAMEKEY] != null) {
            name = jsonObj[NAMEKEY];
         }
        //print("not loading pet inventory json, but if i did it would be ${jsonObj[PETINVENTORY]}");
        //petInventory = new PetInventory();
        petInventory = new PetInventory.fromJSON(jsonObj[PETINVENTORY]);
        itemInventory = new ItemInventory.fromJSON(jsonObj[ITEMINVENTORY]);

     }

    String get daysSincePlayed {
        DateTime now = new DateTime.now();
        Duration diff = now.difference(oldLastPlayed);
        //print("hatch date is $hatchDate and diff is $diff");
        if(diff.inDays > 0) {
            return "You last checked on the wigglers ${diff.inDays} days ago. Shit. I hope they are okay.";
        }else if (diff.inHours > 0) {
            return "You last checked on the wigglers ${diff.inHours} hours ago. You're pretty good at your job.";
        }else if (diff.inMinutes > 0) {
            return "You last checked on the wigglers ${diff.inMinutes} minutes ago. I guess it can't hurt to see what they are up to.";
        }else if (diff.inSeconds > 0) {
            return "You last checked on the wigglers ${diff.inSeconds} seconds ago. You know they'll be okay on their own, right?";
        }
        return "Welcome Back!";
    }

    Player(this.doll, [bool makeJade = true]) {
        lastPlayed = new DateTime.now();
        oldLastPlayed = new DateTime.now();
        if(makeJade && doll is HomestuckTrollDoll) {
            HomestuckTrollDoll troll = doll as HomestuckTrollDoll;
            Random rand = new Random();
            int signNumber = HomestuckTrollDoll.randomJadeSign;
            troll.canonSymbol.imgNumber = signNumber;
            troll.randomize(false);
            print("canon symbol set to ${troll.canonSymbol.imgNumber} which should be jade");
        }
        petInventory = new PetInventory();
        itemInventory = new ItemInventory();
    }


    String get introOld {
        String text = "Your name is $name. What IS important is that you are a JADE BLOOD assigned to the BROODING CAVERNS. You are new to your duties, but are SUDDENLY CERTAIN that you will be simply the best there is at RAISING WIGGLERS. ${daysSincePlayed}";
        if(!(doll is HomestuckTrollDoll)) text = "Your name is $name. What IS important is that you are a JA-. Huh. What ARE you, exactly? I guess they let aliens or whatever into the Caverns these days??? ${daysSincePlayed}";

        if((doll is HomestuckTrollDoll)) {
            HomestuckTrollDoll t = doll as HomestuckTrollDoll;
            HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
            String colorWord = t.bloodColorToWord(p.aspect_light);
            if(colorWord != HomestuckTrollDoll.JADE) {
                text = "Your name is $name. What IS important is that you are a JA-. Huh. You're NOT a Jade blood? Well. I GUESS there's no law saying a non Jade CAN'T raise grubs? ${daysSincePlayed}";
            }
        }
        if(petInventory.alumni.length > 1 && name == UNIMPORTANT) {
            text = "Your name is $name. What IS important is that you are starting to get the hang of these BROODING CAVERNS.  ${daysSincePlayed}";
        }else if(petInventory.alumni.length > 10) {
            if(name == UNIMPORTANT) name = INCREASINGLY_IMPORTANT;
            text = "Your name is $name. Your skill as an AUXILIATRIX is getting you noticed by those in power. ${daysSincePlayed}";
        }

        return text;
    }

    String get intro {
        return "$personalDetailsIntro $daysSincePlayed $favortiteCasteIntro $completedCastesIntro";
    }

    String get personalDetailsIntro {
        String whatIsImportant = "";
        if(name == UNIMPORTANT) whatIsImportant = "What IS important is that you are";
        return "Your name is $name. $whatIsImportant $speciesIntro $experienceIntro";
    }

    String get experienceIntro {
        if(petInventory.alumni.length == 0) {
            return "You are new to your duties, but are SUDDENLY CERTAIN that you will be simply the best there is at RAISING WIGGLERS.";
        }else if(petInventory.alumni.length <50) {
            return "You are starting to get the hang of these BROODING CAVERNS.";
        }else if(petInventory.alumni.length < 24*6) {
            if(name == UNIMPORTANT) {
                name = INCREASINGLY_IMPORTANT;
                save();
            }
            return "Your skill as an AUXILIATRIX is getting you noticed by those in power.";
        }else {
            return "You are going down in history has one of the most prollific AUXILIATRIXES of all time.";
        }
    }

    String get speciesIntro {
        if(!(doll is HomestuckTrollDoll) && !(doll is HiveswapDoll)) return nonTrollIntro;

        if((doll is HomestuckTrollDoll)) {
            HomestuckTrollDoll t = doll as HomestuckTrollDoll;
            HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
            String colorWord = t.bloodColorToWord(p.aspect_light);
            if(colorWord != HomestuckTrollDoll.JADE) {
                return nonJadeIntro;
            }else {
                return jadeIntro;
            }
        }

    }

    String get jadeIntro {
       return "a JADE BLOOD assigned to the BROODING CAVERNS.";
    }

    String get nonJadeIntro {
        String casteText = "";
        HomestuckTrollDoll t = doll as HomestuckTrollDoll;
        HomestuckTrollPalette p = t.palette as HomestuckTrollPalette;
        String colorWord = t.bloodColorToWord(p.aspect_light);
        if(colorWord == HomestuckTrollDoll.FUCHSIA) {
            casteText = "I guess raising grubs is less stressful than ruling an Empire?";
        }else if (colorWord == HomestuckTrollDoll.MUTANT) {
            casteText = "I guess it makes sense to hide in the caverns rather than risk culling.";
        }else if (colorWord == HomestuckTrollDoll.PURPLE) {
            casteText = "This is the EXACT opposite of subjuggulation, though.";
        }
        return " a JA-. Huh. You're NOT a Jade blood? You're a ${colorWord}? Well. I GUESS there's no law saying a non Jade CAN'T raise grubs? $casteText";
    }

    String get nonTrollIntro {
        return "a JA-. Huh. What ARE you, exactly? I guess they let aliens or whatever into the Caverns these days???";
    }

    String get favortiteCasteIntro {
        String favorite = petInventory.favoriteCaste;
        String comment = "";
        if(favorite == HomestuckTrollDoll.JADE) comment = "Need more help in the caverns?";
        if(favorite == HomestuckTrollDoll.FUCHSIA) comment = "Trying to replace your boss?";
        if(favorite == HomestuckTrollDoll.MUTANT) comment = "Uh. Huh. What is even the point of mutants?";
        if(favorite == HomestuckTrollDoll.BURGUNDY ||favorite == HomestuckTrollDoll.BRONZE ) comment = "You're not a rebel, are you?";
        if(favorite == HomestuckTrollDoll.GOLD) comment = "Banking on space travel picking up soon?";
        if(favorite == HomestuckTrollDoll.OLIVE || favorite == HomestuckTrollDoll.TEAL) comment = "Middle managment types are always needed.";
        if(favorite == HomestuckTrollDoll.LIME) comment = "Hrm...I feel like this might be a bad idea, but I don't know why.";
        if(favorite == HomestuckTrollDoll.CERULEAN || favorite == HomestuckTrollDoll.INDIGO) comment = "High bloods will come in handy keeping the lower bloods down.";
        if(favorite == HomestuckTrollDoll.PURPLE) comment = "Do you follow the Mirthful Messiahs?";
        if(favorite == HomestuckTrollDoll.VIOLET) comment = "Are you trying to start a civil war?";
        if(favorite == null) return "You haven't raised enough grubs to have a favorite caste, yet.";
        return "You are especially skilled at raising $favorite bloods. $comment";
    }

    String get completedCastesIntro {
        List<String> completed = Sign.completedCastes;
        if(completed.isEmpty) {
            return "You haven't completed any single caste, yet.";
        }else if(completed.length == 1) {
            return "You've managed to complete one caste!";
        }else if(completed.length == 12) {
            return "You've managed to complete all the castes!";
        }else {
            return "You've managed to complete ${completed.length} caste!";
        }
    }


    void displayloadBoxAndText(Element div)
    {
        Element container = new DivElement();

        DivElement introElement = new DivElement();
        introElement.text = intro;
        Element container2 = new DivElement();
        String text2 = "<br><Br>Or are you? Maybe you are someone else? ";
        AnchorElement link = new AnchorElement();
        link.href = "http://www.farragofiction.com/DollSim/index.html?type=2";
        link.text = " Anybody in mind?";
        link.style.padding = "padding:10px";

        LabelElement labelElement = new LabelElement();
        labelElement.text = "Actually, the Empress wants to know, what is your name?";
        TextInputElement nameElement = new TextInputElement();
        ButtonElement nameButton = new ButtonElement();
        nameButton.text = "Say Your Name";
        nameButton.onClick.listen((Event e) {
            name = nameElement.value;
            print("new name is $name, intro is $intro");
            introElement.text = intro;
            save();
        });

        Element container3 = new DivElement();
        TextAreaElement dollLoader = new TextAreaElement();
        dollLoader.cols = 30;
        dollLoader.rows = 9;
        dollLoader.text = doll.toDataBytesX();
        dollLoader.style.padding = "padding:10px";
        container3.append(dollLoader);
        Element container4 = new DivElement();
        ButtonElement button = new ButtonElement();
        button.text = "Load Doll";
        button.onClick.listen((Event e) {
            print("current doll is $doll");
            doll = Doll.loadSpecificDoll(dollLoader.value);
            print("new doll is $doll");
            save();
            draw();
        });

        container4.append(button);


        container.append(introElement);
        container2.appendHtml(text2);
        container.append(labelElement);
        container.append(nameElement);
        container.append(nameButton);

        container2.append(link);
        div.append(container);
        div.append(container2);
        div.append(container3);
        div.append(container4);

    }


    //TODO convert self to json (including pet inventory) to save in this localStorage
    void save() {
        String json = toJson().toString();
        //print("saving player ${json}. Pet inventory has ${petInventory.pets.length} in it.");
        window.localStorage[DOLLSAVEID] = json;
    }


    //TODO probably need to spend time thining of what needs to happen here. should i cache canvas?
    Future<CanvasElement> draw() async {
        if(canvas == null) canvas = new CanvasElement(width: width, height: height);
        canvas.context2D.clearRect(0,0,width,height);
        CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
        await DollRenderer.drawDoll(dollCanvas, doll);

        dollCanvas = Renderer.cropToVisible(dollCanvas);

        Renderer.drawToFitCentered(canvas, dollCanvas);
        return canvas;
    }

    JSONObject toJson() {
        lastPlayed = new DateTime.now();
        JSONObject json = new JSONObject();
        json[DATASTRING] = doll.toDataBytesX();
        json[NAMEKEY] = name;
        json[LASTPLAYED] = "${lastPlayed.millisecondsSinceEpoch}";
        json[PETINVENTORY] = petInventory.toJson().toString();
        json[ITEMINVENTORY] = itemInventory.toJson().toString();
        json[MONEYJSON] = "$caegers";
        if(lastGotAllowence != null) json[LASTALLOWENCE] = "${lastGotAllowence.millisecondsSinceEpoch}";
        return json;
    }
}