import "AIObject.dart";
import "../Pets/Stat.dart";
import 'dart:async';
import 'package:CommonLib/Utility.dart';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import "package:DollLibCorrect/DollRenderer.dart";
import 'dart:convert';
import '../GameShit/GameObject.dart';
import 'package:LoaderLib/Loader.dart';




/*
    has a list of strings that are possible image files, a string that is it's name (generic troll word)
    soft thing, living thing, food thing, hard thing
    stats.
    when a grub interacts with it, it's stats will determine if they like it or not.

    the item does not interact back

    when buying an item, only unique slots for items with unique stats.
    i.e. tildeath book and skull (hypothetically) both show in same slot, randomly???
 */
class AIItem extends AIObject {
    static String ITEMAPPERANCES = "itemAppearances";

    static String PATIENCE = "patience";
    static String ENERGETIC = "energetic";
    static String IDEALISTIC = "idealistic";
    static String CURIOUS = "curious";
    static String LOYAL = "loyal";
    static String ID = "id";
    static String EXTERNAL = "external";
    static int LOW = 5;
    static int MID = 10;
    static int HIGH = 15;
    static int VERY_HIGH = 25;



    String folder = "images/Items/"; //theoretically can be changed
    CanvasElement canvas;
    //for bored grubs
    bool imaginary = false;

    //so i know which version of the item this is.
    ImageElement imageElement;
    String name;

    //if false, render buy button, if true, render deploy button.
    bool belongsToPlayer = false;


    //so wigglers know if they remember this or not.
    int id;
    //for buying in store.
    //not standardized because of how items can change
    int get cost {
        int total = 0;
        for(Stat s in stats) {
            total += s.value.abs();
        }
        int numPets = GameObject.instance.player.petInventory.pets.length;
        return total*numPets+10; //costs more if you have more grubs, thems the breaks.
    }

    List<ItemAppearance> itemTypes = new List<ItemAppearance>();




    //if you don't have a stat it's zero
    //troll names and image locations should be same length. probably should make it an object then.
    AIItem(this.id,this.itemTypes, {int external_value: 0, int curious_value: 0, int loyal_value: 0, int patience_value: 0, int energetic_value: 0, int idealistic_value: 0} ) {
        makePatience(patience_value);
        makeEnergetic(energetic_value);
        makeIdealistic(idealistic_value);
        makeCurious(curious_value);
        makeLoyal(loyal_value);
        makeExternal(external_value);
    }

    AIItem.fromJSON(var json){
        //init
        print("an ai item from json $json");
        makePatience(0);
        makeEnergetic(0);
        makeIdealistic(0);
        makeCurious(0);
        makeLoyal(0);
        makeExternal(0);
        belongsToPlayer = true;
        loadFromJSON(json);
    }

    void loadFromJSON(var json) {
        id = int.parse(json[ID]);
        patience.value = int.parse(json[PATIENCE]);
        idealistic.value = int.parse(json[IDEALISTIC]);
        curious.value = int.parse(json[CURIOUS]);
        loyal.value = int.parse(json[LOYAL]);
        energetic.value = int.parse(json[ENERGETIC]);
        external.value = int.parse(json[EXTERNAL]);

        String idontevenKnow = json[ITEMAPPERANCES];
        loadItemVersionsFromJSON(idontevenKnow);
    }

    void loadItemVersionsFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;

        List<dynamic> what = jsonDecode(idontevenKnow);
        //print("what json is $what");
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            itemTypes.add(new ItemAppearance.fromJSON(null,j));
        }

    }

    AIItem copyItemForInventory() {
        AIItem copiedItem = new AIItem(id, new List<ItemAppearance>.from(itemTypes))
            ..belongsToPlayer = true
            ..patience.value = patience.value
            ..loyal.value = loyal.value
            ..external.value = external.value
            ..energetic.value = energetic.value
            ..curious.value = curious.value
            ..idealistic.value = idealistic.value;
        return copiedItem;
    }

    @override
    String toString() {
        return "${itemTypes}";
    }

    //depending on my image size, i need to be rendered in different places to be on the ground.
    void placeOnGround(CanvasElement groundCanvas) {
        Random rand = new Random();
        x = rand.nextInt(groundCanvas.width)-200;
        y = groundCanvas.height - canvas.height;
        if(rand.nextBool()) turnWays = true;
    }

    //if the stats are zero they don't exist.
    int get averageStatsIgnoreZero{
        int ret = 0;
        int count = 0;
        for(Stat s in stats) {
            if(s.value != 0) {
                //don't care if positive or negative, just care about magnitude
                ret += s.normalizedValue;
                count ++;
            }
        }
        if(count == 0) return 0;
        return (ret/count).round();
    }

    Future<Null> pickVersion() async {
        await pickImage();
        await pickName();
    }

    //makes sure the index exists
    int get versionIndex {
        int avgStats = averageStatsIgnoreZero;
        //print("getting version index. Average stats is ${avgStats} and itemTypes is ${itemTypes.length} long.");
        if(avgStats >= AIItem.VERY_HIGH && itemTypes.length > 3) {
            return 3;
        }else if(avgStats > AIItem.HIGH && itemTypes.length > 2) {
            return 2;
        }else if(avgStats > AIItem.MID && itemTypes.length > 1) {
            return 1;
        }else{
            return 0;
        }
    }

    Future<Null> pickImage() async {
        //version index takes care of making sure it is a valid location
        String chosen = itemTypes[versionIndex].imageLocation;
       // print("chosen image is $chosen");

        imageElement = await Loader.getResource(("$folder$chosen"));
        imageElement = imageElement.clone(false);
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json[ID] = "${id}";
        json[PATIENCE] = "${patience.roundedCappedStat}";
        json[IDEALISTIC] = "${idealistic.roundedCappedStat}";
        json[CURIOUS] = "${curious.roundedCappedStat}";
        json[LOYAL] = "${loyal.roundedCappedStat}";
        json[ENERGETIC] = "${energetic.roundedCappedStat}";
        json[EXTERNAL] = "${external.roundedCappedStat}";

        List<JSONObject> jsonArray = new List<JSONObject>();
        for(ItemAppearance p in itemTypes) {
            // print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[ITEMAPPERANCES] = jsonArray.toString(); //will this work?


        return json;
    }


    Future<Null> pickName() async {
        name = itemTypes[versionIndex].name;
        //print("chosen name is $name");
    }

    @override
    Future<Null> draw(CanvasElement destination) async {
        //draw self with rotation and scaling
        if(imageElement == null) await pickVersion();
        if(canvas == null) {
            //draw image to canvas
            canvas = new CanvasElement(width: imageElement.width, height: imageElement.height);
            canvas.context2D.drawImage(imageElement, 0, 0);
            placeOnGround(destination);
        }
        //draw canvas to destination with rotation and scaling
        CanvasElement ret = new CanvasElement(width: imageElement.width, height: imageElement.height);
        ///ret.context2D.fillRect(0,0, ret.width, ret.height);
        ret.context2D.translate(ret.width/2, ret.height/2);
        ret.context2D.rotate(rotation);

        if(turnWays) {
            ret.context2D.scale(-1*scaleX, scaleY);
        }else {
            ret.context2D.scale(scaleX, scaleY);
        }
        ret.context2D.drawImage(canvas, -ret.width/2, -ret.height/2);

        destination.context2D.drawImage(ret,x,y);

    }

    //includes list of stats and buttons for buying or deploying myself (depending on if i belong to player or not)
    Future<Null> drawHTML(Element destination) async {
        if(imageElement == null) await pickVersion();
        imageElement.classes.add("itemImageSrc");

        DivElement container = new DivElement();
        drawButton(container);

        container.classes.add("itemElement");
        DivElement image = new DivElement();
        image.classes.add("itemImage");
        DivElement stats = new DivElement();
        stats.classes.add("itemStats");
        drawHtmlStats(stats);

        container.append(image);
        container.append(stats);

        destination.append(container);

        image.append(imageElement);
    }

    void drawButton(Element destination) {
        ButtonElement button = new ButtonElement();
        if(belongsToPlayer) {
            button.text = "Deploy";
            button.onClick.listen((e) {
                //print("adding item ${name} with calm of ${energetic.value} and realisitic of ${idealistic.value}. and curious of ${curious.value}");
                GameObject.instance.playPen.addItem(this);
                GameObject.instance.player.itemInventory.removeItem(this);
                destination.remove();
                //GameObject.instance.infoElement.text = "Bought $name! Own: ${GameObject.instance.player.itemInventory.numberOf(this)}";
            });
        }else {
            button.text = "Buy For ${cost} cg";
            if(cost <= GameObject.instance.player.caegers) {
                button.onClick.listen((e) {
                    //inner if because you might go to negative money when you buy shit here.
                    if(cost <= GameObject.instance.player.caegers) {
                        if(GameObject.instance.player.itemInventory.numItems > 50) {
                            GameObject.instance.infoElement.text = "Too many items. Use some before getting any more.";
                            return;
                        }
                        GameObject.instance.player.itemInventory.addItem(this,false);
                        GameObject.instance.infoElement.text = "Bought $name! Own: ${GameObject.instance.player.itemInventory.numberOf(this)}";
                    }else {
                        button.disabled;
                        button.classes.add("invertButton");
                        button.text = "Cannot Afford to Buy ${cost}";
                    }
                });
            }else {
                button.disabled;
                button.classes.add("invertButton");
                button.text = "Cannot Afford to Buy ${cost}";
            }
        }
        destination.append(button);

    }

    void drawHtmlStats(Element destination) {
        Element container = new DivElement();
        container.classes.add("itemNameDiv");
        container.text = "${name}";
        destination.append(container);
        for(Stat s in stats) {
            if(s.value != 0) {
                Element container = new DivElement();
                container.classes.add("statDiv");
                container.text = "${s.toString()}";
                destination.append(container);
            }
        }
    }

    void makePatience(int value) {
        patience = new Stat(value, "Patient","Impatient", Stat.patienceFlavor, Stat.impatienceFlavor);
    }

    void makeEnergetic(int value) {
        energetic = new Stat(value, "Energetic","Calm", Stat.calmFlavor, Stat.energeticFlavor);
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
        external = new Stat(value, "External","Internal",Stat.externalFlavor, Stat.internalFlavor);
    }

}

class ItemAppearance {
    static String NAMEJSON = "name";
    static String IMAGELOCJSON = "imageLoc";

    String name; //weird troll memey shit
    String imageLocation;
    ItemAppearance(this.name, this.imageLocation);

    ItemAppearance.fromJSON(String json, [JSONObject jsonObj]){
        loadFromJSON(json,jsonObj);
    }

    @override
    String toString() {
        return name;
    }

    void loadFromJSON(String json, [JSONObject jsonObj]) {
        if(jsonObj == null) jsonObj = new JSONObject.fromJSONString(json);
        name = jsonObj[NAMEJSON];
        imageLocation = jsonObj[IMAGELOCJSON];
    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        json[IMAGELOCJSON] = "${imageLocation}";
        json[NAMEJSON] = "${name}";
        return json;
    }
}