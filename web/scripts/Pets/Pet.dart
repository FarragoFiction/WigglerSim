
/*
    A wiggler is a type of pet. So is an egg, and a coccoon.
    maybe other things, in the future. consorts?

    A pet has stats (what stats? hunger at least)

    A pet has a name.

    A pet knows how to save and load itself.

    A pet has an id.

    Pet knows how to animate itself based on actions???

    TODO Pet knows how to convert to json (so it can be saved).

    A pet has a birthday.
    A pet has a "time last fed".
    A pet has a "time last played with".
    Pet should have a personality based on their stats. changes over time as their stats change?
        health
        boredom

    Pet has a symbol you can assign it at a certain life stage.


    How can you effect stats? Items you give wigglers to play with. Use items from fryamotifs.
    Each item has plus and minus.  Could go aspect route and have mobility/free will, min/max luck, etc.
    Or just straight up the aspect names.

    Activities you do with them can effect stats too?

    Better eggs cost more,come with better stats? Or at least more extreme.

    Assign symbol based on what aspect it is closest too at maturity?

    if stats above certain threshold, adult form has wings?



    Time/Space  Impatient/Patient
    Doom/Life Pessimistic/Optimistic
    Rage/Hope Realism/Idealism
    Void/Light Accepting/Curious
    Breath/Blood Free/Committed
    Heart/Mind Introversion/Extroversion

    TODO need to brainstorm wiggler actions that pair with all 12 things.

    So, use cases:  You are in the wiggler playpen. The are three wigglers total.

    Use Case 1: Caretaker puts down a thing.

    Extroversion: Do you even notice the thing in the first place, or were you lost in thoughts?
    Curiosity: Do you investigate the thing if it's not already near you?
    Commited: Once you are near it, is it something you already like? If commited and no, attack.
    Patientce: Do you immediately figure out how to use it? If impatient and no, attack.
    Idealism:  Is it as cool as you thought? If not. Attack.

    ((current thoughts: too many look the same from the outside. Also, idealism/realism is too close to optimism/pessimism for actions))

    start out communicating only with emoticons
    once eyes yellow out, can use simple words. baby talk. hewwo. webewwion.




 */
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import "JSONObject.dart";
import 'dart:async';
import 'Grub.dart';
import 'Egg.dart';
import 'Cocoon.dart';
import 'Troll.dart';
import "Stat.dart";



abstract class Pet {

    //all life stages should be centered around this.
    static int timeUnit = 30*60* 1000; //30 minutes
    //DEPRECATED, use the thing in the init instead /static int timeUnit = 3* 1000;


    int millisecondsToChange = Pet.timeUnit;

    //TODO procedural description of personality based on stats.
    int textHeight = 800;
    int textWidth = 420;
    //empresses are drawn slightly different. only alumni are empresses
    bool empress = false;

    static String HEALTHJSON = "healthJson";
    static String BOREDOMEJSON = "boredomJson";
    static String DOLLDATAURL = "dollDATAURL";
    static String LASTPLAYED = "lastPlayed";
    static String LASTFED = "lastFed";
    static String HATCHDATE = "hatchDate";
    static String NAMEJSON = "nameJSON";
    static String TYPE = "TYPE";
    static String GRUB = "GRUB";
    static String EGG = "EGG";
    static String COCOON = "COCOON";
    static String TROLL = "TROLL";
    static String PATIENCE = "patience";
    static String ENERGETIC = "energetic";
    static String IDEALISTIC = "idealistic";
    static String CURIOUS = "curious";
    static String LOYAL = "loyal";
    static String EXTERNAL = "external";
    static String ISEMPRESS = "isempress";
    static String REMEMBEREDITEMS = "remembered";



    Stat patience;
    Stat energetic;
    Stat idealistic;
    Stat curious;
    Stat loyal;
    Stat external;


    int health;
    String type;
    //some stats make it easier to get bored than others.
    int boredom;
    String name = "ZOOSMELL POOPLORD";
    //TODO have arrays of cached canvases for animations.
    CanvasElement canvas;
    int width = 400;
    int height = 300;
    Doll doll;
    DateTime hatchDate;
    DateTime lastFed;
    DateTime lastPlayed;
    //when make a new pet, give it an id that isn't currently in the player's inventory. just increment numbers till you find one.
    int id;
    List<Stat> get stats => <Stat>[patience, energetic, idealistic, curious, loyal, external ];
    Set<int> itemsRemembered = new Set<int>();

    Pet(this.doll, {this.health: 100, this.boredom: 0}) {
        //never again will i accidentally leave shit in debug mode
        if(window.location.hostname.contains("localhost")) timeUnit = 3* 1000;
        hatchDate = new DateTime.now();
        lastFed = new DateTime.now();
        lastPlayed = new DateTime.now();
        name = randomAsFuckName();
        randomizeStats();
    }

    void randomizeStats() {
        makePatience(null);
        makeEnergetic(null);
        makeIdealistic(null);
        makeCurious(null);
        makeLoyal(null);
        makeExternal(null);
    }

    bool get isPatient {
        return patience.value > 0;
    }

    bool get isEnergetic {
        return energetic.value > 0;
    }

    bool get isIdealistic {
        return idealistic.value > 0;
    }

    bool get isCurious {
        return curious.value > 0;
    }

    bool get isLoyal {
        return loyal.value > 0;
    }

    bool get isExternal {
        return external.value > 0;
    }

    bool get isImpatient {
        return patience.value <= 0;
    }

    bool get isCalm {
        return energetic.value <= 0;
    }

    bool get isRealistic {
        return idealistic.value <= 0;
    }

    bool get isAccepting {
        return curious.value <= 0;
    }

    bool get isFreeSprited {
        return loyal.value <= 0;
    }

    bool get isInternal {
        return external.value <= 0;
    }


    void makePatience(int value) {
        patience = new Stat(value, "Patient","Impatient", Stat.patienceFlavor, Stat.impatienceFlavor);
    }

    void makeEnergetic(int value) {
        energetic = new Stat(value, "Calm","Energetic", Stat.calmFlavor, Stat.energeticFlavor);
    }
    void makeIdealistic(int value) {
        idealistic = new Stat(value, "Idealistic","Realistic", Stat.idealisticFlavor, Stat.realisticFlavor);
    }
    void makeCurious(int value) {
        curious = new Stat(value, "Curious","Accepting", Stat.curiousFlavor, Stat.acceptingFlavor);
    }
    void makeLoyal(int value) {
        loyal = new Stat(value, "Loyal","Free-Spirited", Stat.loyalFlavor, Stat.freeFlavor);
    }
    void makeExternal(int value) {
        external = new Stat(value, "External","Interal",Stat.externalFlavor, Stat.internalFlavor);
    }

    //can't go over 100%, how close to hatching are you?
    double get percentToChange {
        DateTime now = new DateTime.now();
        Duration diff = now.difference(hatchDate);
        double ret = diff.inMilliseconds/millisecondsToChange;
        if(ret > 1.0) ret = 1.0;
        return ret;
    }

    Pet.fromJSON(String json){
        loadFromJSON(json);
    }

    //it doesn't like treating the json object i got as a string for whatever reason.
    static Pet loadPetFromJSON(String json, [JSONObject jsonObj]) {
        //print("jsonObj is ${jsonObj}");
        if(jsonObj == null) jsonObj = new JSONObject.fromJSONString(json);
        //print("Loading abstract pet from json, obj is ${jsonObj}");
        if(jsonObj[TYPE] == GRUB) {
            return new Grub.fromJSON(null,jsonObj);
        }else if(jsonObj[TYPE] == EGG) {
            return new Egg.fromJSON(null,jsonObj);
        }else if(jsonObj[TYPE] == COCOON) {
            return new Cocoon.fromJSON(null,jsonObj);
        }else if(jsonObj[TYPE] == TROLL) {
            return new Troll.fromJSON(null,jsonObj);
        }
        print("UNKNOWN PET TYPE ${jsonObj[TYPE]}");
        throw "UNKNOWN PET TYPE ${jsonObj[TYPE]}";
    }

    //individual pet types don't have to
    void loadStatsFromJSON(JSONObject jsonObj) {
        int p = null;
        int cur = null;
        int lo = null;
        int ener = null;
        int idea = null;
        int ext = null;

        if(jsonObj.containsKey(PATIENCE)){
            p = int.parse(jsonObj[PATIENCE]);
        }

        if(jsonObj.containsKey(CURIOUS)){
            cur = int.parse(jsonObj[CURIOUS]);
        }

        if(jsonObj.containsKey(LOYAL)){
            lo = int.parse(jsonObj[LOYAL]);
        }

        if(jsonObj.containsKey(EXTERNAL)){
            ext = int.parse(jsonObj[EXTERNAL]);
        }

        if(jsonObj.containsKey(ENERGETIC)){
            ener = int.parse(jsonObj[ENERGETIC]);
        }

        if(jsonObj.containsKey(IDEALISTIC)){
            idea = int.parse(jsonObj[IDEALISTIC]);
        }

        makePatience(p);
        makeCurious(cur);
        makeLoyal(lo);
        makeEnergetic(ener);
        makeIdealistic(idea);
        makeExternal(ext);
    }

    void loadFromJSON(String json, [JSONObject jsonObj]) {
        if(jsonObj == null) jsonObj = new JSONObject.fromJSONString(json);
        String dataString = jsonObj[DOLLDATAURL];
        String lastPlayedString = jsonObj[LASTPLAYED];
        String hatchString = jsonObj[HATCHDATE];
        String fedString = jsonObj[LASTFED];
        String empressString = jsonObj[ISEMPRESS];
        if(empressString != null) {
            if(empressString == "true") {
                empress = true;
            }else {
                empress = false;
            }
        }
        name = jsonObj[NAMEJSON];
        loadStatsFromJSON(jsonObj);
        itemsRemembered = JSONObject.jsonStringToIntSet(jsonObj[REMEMBEREDITEMS]);
        print("items remembered is $itemsRemembered and json as ${jsonObj[REMEMBEREDITEMS]}");
        lastPlayed = new DateTime.fromMillisecondsSinceEpoch(int.parse(lastPlayedString));
        hatchDate = new DateTime.fromMillisecondsSinceEpoch(int.parse(hatchString));
        lastFed = new DateTime.fromMillisecondsSinceEpoch(int.parse(fedString));
        boredom = int.parse(jsonObj[BOREDOMEJSON]);

        doll = Doll.loadSpecificDoll(dataString);
    }


    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json[LASTPLAYED] =  "${lastPlayed.millisecondsSinceEpoch}";
        json[ISEMPRESS] = empress.toString();
        json[HATCHDATE] =  "${hatchDate.millisecondsSinceEpoch}";
        json[LASTFED] =  "${lastFed.millisecondsSinceEpoch}";
        json[DOLLDATAURL] = doll.toDataBytesX();
        json[BOREDOMEJSON] =  "${boredom}";
        json[NAMEJSON] =  "${name}";
        json[HEALTHJSON] =  "${health}";
        json[TYPE] = type;
        json[PATIENCE] = "${patience.value}";
        json[IDEALISTIC] = "${idealistic.value}";
        json[CURIOUS] = "${curious.value}";
        json[LOYAL] = "${loyal.value}";
        json[ENERGETIC] = "${energetic.value}";
        json[EXTERNAL] = "${external.value}";
        json[REMEMBEREDITEMS] = itemsRemembered.toString();
        if(itemsRemembered.isNotEmpty) print(" saving $name, items remembered is $itemsRemembered and json is ${json[REMEMBEREDITEMS]} ");


        return json;
    }

    Element makeDollLoader() {
        Element ret = new DivElement();
        //no spoilers!
        if(this is Cocoon || this is Egg) return ret;
        ret.setInnerHtml("Doll URL: ");
        TextAreaElement dollArea = new TextAreaElement();
        dollArea.value = doll.toDataBytesX();
        ret.append(dollArea);

        ButtonElement copyButton = new ButtonElement();
        copyButton.text = "Copy";
        ret.append(copyButton);
        copyButton.onClick.listen((Event e) {
            dollArea.select();
            document.execCommand('copy');
        });

        DivElement anchorContainer = new DivElement();
        ret.append(anchorContainer);
        AnchorElement a = new AnchorElement();
        a.href = "http://farragofiction.com/DollSim/index.html?${doll.toDataBytesX()}";
        a.target = "_blank";
        a.text = "Edit Doll Link";
        anchorContainer.append(a);
        return ret;
    }

    String daysSinceDate(DateTime date, String label) {
        DateTime now = new DateTime.now();
        Duration diff = now.difference(date);
        //print("hatch date is $hatchDate and diff is $diff");
        String s = "";
        if(diff.inDays > 0) {
            if(diff.inDays >1) s = "s";
            return "$label: ${diff.inDays} day$s ago.";
        }else if (diff.inHours > 0) {
            if(diff.inHours >1) s = "s";
            return "$label: ${diff.inHours} hour$s ago.";
        }else if (diff.inMinutes > 0) {
            if(diff.inMinutes >1) s = "s";
            return "$label: ${diff.inMinutes} minute$s ago.";
        }else if (diff.inSeconds > 0) {
            if(diff.inSeconds >1) s = "s";
            return "$label: ${diff.inSeconds} second$s ago.";
        }
        return "Just $label!";
    }

    String get daysSinceHatch {
        return daysSinceDate(hatchDate, "Hatched");
    }

    String get daysSinceFed {
        return daysSinceDate(lastFed, "Fed");
    }

    String get daysSincePlayed {
        return daysSinceDate(lastPlayed,"Played With");
    }

    String randomAsFuckName() {
        Random rand = new Random();
        List<String> titles = <String>["Citizen", "Engineer", "Captain", "Commodore", "Private", "Sergeant", "Lieutenant", "Senior", "Senpai", "Psychicboi", "Hotboi", "Viceroy", "Lord", "Shogun", "Captain", "Baron","Prophesied", "Demon","Destroyer","Darling" "The Esteemed", "Mr.", "Mrs.", "Mdms.", "Count", "Countess", "Darth", "Clerk", "President", "Pounceler", "Counciler", "Minister", "Ambassador", "Admiral", "Rear Admiral", "Commander", "Dr.", "Sir", "Senator", "Contessa"];
        //these titles thanks to duckking
        titles.addAll(<String>["Duke", "Earl", "Duchess", "Marquess", "Marchioness", "Lord", "Viscount", "Viscountess", "Baroness", "Chief", "Chieftain", "Saint", "Bishop", "Archbishop", "Cardinal", "Chorbishop", "Dean", "Vice", "Pope", "Supreme", "Bishop", "Assistant", "Researcher", "Vice President", "Archdeacon", "Sensei", "Archpriest", "Abbot", "Abbess", "Monk", "Novice", "Sister", "Brother", "Father", "Mother", "Elder", "Judge", "Executioner", "Patriarch", "Reverend", "Pastor", "Rabbi", "Cleric", "Master", "King", "Queen", "Druid", "Knight", "Seer", "Bard", "Heir", "Maid", "Rogue", "Thief", "Page", "Sylph", "Witch", "Prince", "Princess", "Mage", "Monsignor", "TV's", "Sherrif", "Professor", "Vice-Chancellor"]);
        List<String> firstNames = <String>["Chuck", "Jerry", "Capybara", "Bibbles", "Jiggy", "Jibbly", "Wiggly", "Wiggler", "Grubby", "Zoosmell", "Farmstink", "Bubbles", "Nic", "Lil", "Liv", "Charles", "Meowsers", "Casey","Candy", "Sterling", "Fred", "Kid", "Meowgon", "Fluffy", "Meredith", "Bill", "Ted", "Ash", "Frank", "Flan", "Quill", "Squeezykins", "Spot", "Squeakems", "Stephen", "Edward", "Hissy", "Scaley", "Glubglub", "Mutie", "Donnie", "Clattersworth", "Bonebone", "Nibbles", "Fossilbee", "Skulligan", "Jack", "Nigel", "Dazzle", "Fancy", "Pounce"];
        firstNames.addAll(<String>["Cheddar", "Bob", "Winston", "Lobster", "Snookems", "Squeezy Face", "Cutie", "Sugar", "Sweetie", "Squishy","Katana","Sakura", "Snuffles", "Sniffles", "John", "Rose", "Dave", "Jade","Brock", "Dirk", "Roxy", "Jane", "Jake", "Sneezy", "Bubbly", "Bubbles", "Licky", "Fido", "Spot", "Grub", "Elizabeth", "Malory", "Elenora", "Vic", "Jason", "Christmas", "Hershey", "Mario"]);
        List<String> lastNames = <String>["Lickface", "McProblems", "Pooper", "von Wigglesmith", "von Horn", "Grub", "Dumbface", "Buttlass", "Pooplord", "Cage", "Sebastion", "Taylor", "Dutton", "von Wigglebottom","Kazoo", "von Salamancer", "Savage", "Rock", "Spangler", "Fluffybutton", "Wigglesona", "S Preston", "Logan", "Juice", "Clowder", "Squeezykins", "Boi", "Oldington the Third", "Malone", "Ribs", "Noir", "Sandwich"];
        lastNames.addAll(<String>["Lobster", "Butter", "Pie", "Poofykins", "Snugglepuff", "Diabetes", "Face", "Puffers", "Dorkbutt", "Butt","Katanta","Sakura", "Legs", "Poppenfresh", "Stubblies", "Licker","Kilobyte","Samson","Terabyte","Gigabyte","Megabyte", "Puker", "Grub", "Edington", "Rockerfeller", "Archer", "Addington", "Ainsworth", "Gladestone", "Valentine", "Heart", "Love", "Sniffles"]);
        //these last names from duckking
        lastNames.addAll(<String>["Ross", "Churchill", "Washington", "Adams", "Jefferson", "Madison", "Monroe", "Jackson", "Van Buren", "Harrison", "Knox", "Polk", "Taylor", "Fillmore", "T Robot", "Servo", "Wonder", "Pierce", "Buchanan", "Grant", "Hayes", "Garfield", "Arthur", "Cleveland", "Ketchum", "Williams", "Quill", "Weave", "Myers", "Voorhees", "Kramer", "Seinfeld", "Dent", "Nigma", "Cobblepot", "Strange", "Universe", "Darko"]);
        lastNames.addAll(<String>["McKinley", "Roosevelt", "Taft", "Harding", "Wilson", "Coolidge", "Hoover", "Truman", "Eisenhower", "Kennedy", "Johnson", "Wilson", "Carter", "Arbuckle", "Rodgers", "T", "G", "Henson", "Newton", "Tesla", "Edison", "Valentine", "Claus", "Hershey", "Freeman", "Nietzsche"]);
        List<String> endings = <String>[", the Third",", esq",", MD", ", Ph.D.", ", Junior", ", Senior",", CPA"," the Shippest", " III"," IV"," V"," VI"," VII"," VIII"," IX"," X", "-chan", "-kun","-san","-sama"];

        List<String> templates = <String>["${rand.pickFrom(titles)} ${rand.pickFrom(firstNames)}${rand.pickFrom(endings)}","${rand.pickFrom(titles)}${rand.pickFrom(endings)}","${rand.pickFrom(titles)} ${rand.pickFrom(firstNames)}","${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}${rand.pickFrom(endings)}","${rand.pickFrom(firstNames)} ${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}","${rand.pickFrom(firstNames)} ${rand.pickFrom(firstNames)}","${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}", "${rand.pickFrom(titles)} ${rand.pickFrom(firstNames)} ${rand.pickFrom(lastNames)}", "${rand.pickFrom(titles)} ${rand.pickFrom(lastNames)}"];
        return rand.pickFrom(templates);
    }

    void displayStats(Element container) {
        Element nameDiv = new DivElement();
        nameDiv.text = "${name}";
        nameDiv.style.fontSize = "18px";
        container.append(nameDiv);
    }

    //returns where next thing should be
    int drawTimeStats(CanvasElement textCanvas, int x, int y, int fontSize,buffer) {
        Renderer.wrap_text(textCanvas.context2D,daysSinceHatch,x,y,fontSize+buffer,400,"left");

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,daysSinceFed,x,y,fontSize+buffer,400,"left");

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,daysSincePlayed,x,y,fontSize+buffer,400,"left");

        return y;
    }

    Future<CanvasElement> drawStats() async {
        //never cache
        CanvasElement textCanvas = new CanvasElement(width: textWidth, height: textHeight);
        if(empress) {
            textCanvas.context2D.fillStyle = "#d27cc9";
            textCanvas.context2D.strokeStyle = "#2c002a";
        }else {
            textCanvas.context2D.fillStyle = "#d2ac7c";
            textCanvas.context2D.strokeStyle = "#2c1900";
        }

        textCanvas.context2D.lineWidth = 3;


        textCanvas.context2D.fillRect(0, 0, width, textHeight);
        textCanvas.context2D.strokeRect(0, 0, width, textHeight);

        textCanvas.context2D.fillStyle = "#2c1900";

        int fontSize = 20;
        textCanvas.context2D.font = "${fontSize}px Strife";
        int y = 330;
        int x = 10;
        Renderer.wrap_text(textCanvas.context2D,name,x,y,fontSize,400,"center");

        y = y + fontSize*2;
        fontSize = 12;

        int buffer = 10;

        y = drawTimeStats(textCanvas,x,y,fontSize,buffer);

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,"HP: $health",x,y,fontSize+buffer,275,"left");

        y = y + fontSize+buffer;
        Renderer.wrap_text(textCanvas.context2D,"Boredom: $boredom",x,y,fontSize+buffer,275,"left");

        for(Stat s in stats) {
            y = y + fontSize+buffer;
            Renderer.wrap_text(textCanvas.context2D,s.toString(),x,y,fontSize+buffer,275,"left");
        }


        return textCanvas;
    }


    Future<CanvasElement> draw() async {
        //caches by default. if you want it to redraw, set canvas to null.
        if(canvas == null) {
            canvas = new CanvasElement(width: width, height: height);
            canvas.context2D.clearRect(0, 0, width, height);
            CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
            await Renderer.drawDoll(dollCanvas, doll);

            dollCanvas = Renderer.cropToVisible(dollCanvas);

            Renderer.drawToFitCentered(canvas, dollCanvas);
        }
        return canvas;
    }



}