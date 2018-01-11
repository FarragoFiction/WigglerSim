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
        return total;
    }

    List<ItemAppearance> itemTypes;




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
        await pickImage();
        await pickName();
    }

    //makes sure the index exists
    int get versionIndex {
        int avgStats = averageStatsIgnoreZero;
        //print("getting version index. Average stats is ${avgStats} and itemTypes is ${itemTypes.length} long.");
        if(avgStats >= AIItem.VERY_HIGH && itemTypes.length > 3) {
            return 3;
        }else if(avgStats >= AIItem.HIGH && itemTypes.length > 2) {
            return 2;
        }else if(avgStats >= AIItem.MID && itemTypes.length > 1) {
            return 1;
        }else{
            return 0;
        }
    }

    Future<Null> pickImage() async {
        //version index takes care of making sure it is a valid location
        String chosen = itemTypes[versionIndex].imageLocation;
        //print("chosen image is $chosen");

        imageElement = await Loader.getResource(("$folder$chosen"));
    }

    Future<Null> pickName() async {
        name = itemTypes[versionIndex].name;
        print("chosen name is $name");
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

    void drawHtmlStats(Element destination) {
        Element container = new DivElement();
        container.classes.add("itemNameDiv");
        container.text = "${name}";
        destination.append(container);
        print("chosen name in html stats is $name");
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