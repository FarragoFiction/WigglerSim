import "AIObject.dart";
import "../Pets/Stat.dart";
import 'dart:async';
import 'dart:html';
import "package:DollLibCorrect/DollRenderer.dart";

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

    static int LOW = 5;
    static int MID = 10;
    static int HIGH = 15;
    static int VERY_HIGH = 25;



    String folder = "images/Items/"; //theoretically can be changed
    CanvasElement canvas;


    //so i know which version of the item this is.
    ImageElement imageElement;
    String name;


    //so wigglers know if they remember this or not.
    int id;
    //for buying in store.
    int cost;

    List<ItemAppearance> itemTypes;




    //if you don't have a stat it's zero
    //troll names and image locations should be same length. probably should make it an object then.
    AIItem(this.id, this.cost, this.itemTypes, {int external_value: 0, int curious_value: 0, int loyal_value: 0, int patience_value: 0, int energetic_value: 0, int idealistic_value: 0} ) {
        makePatience(patience_value);
        makeEnergetic(energetic_value);
        makeIdealistic(idealistic_value);
        makeCurious(curious_value);
        makeLoyal(loyal_value);
        makeExternal(external_value);
    }

    @override
    String toString() {
        return "${itemTypes}";
    }

    //depending on my image size, i need to be rendered in different places to be on the ground.
    void placeOnGround(CanvasElement groundCanvas) {
        Random rand = new Random();
        x = rand.nextInt(groundCanvas.width);
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
        return (ret/count).round();
    }

    Future<Null> pickVersion() async {
        pickImage();
        pickName();
    }

    //makes sure the index exists
    int get versionIndex {
        int avgStats = averageStatsIgnoreZero;
        if(avgStats > AIItem.VERY_HIGH && itemTypes.length > 3) {
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

        imageElement = await Loader.getResource(("$folder$chosen"));
    }

    Future<Null> pickName() async {
        String chosen = itemTypes[versionIndex].name;
        imageElement = await Loader.getResource(("$folder$chosen"));
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

}

class ItemAppearance {
    String name; //weird troll memey shit
    String imageLocation;
    ItemAppearance(this.name, this.imageLocation);

    @override
    String toString() {
        return name;
    }
}