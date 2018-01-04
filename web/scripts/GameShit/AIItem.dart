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

    static int NORMAL_PLUS = 5;
    static int NORMAL_MINUS = -5;



    String folder = "images/Items/"; //theoretically can be changed
    List<String> imageLocations;
    CanvasElement canvas;
    //fuzzy friend, sleepy pal, etc. Weird memey shit.
    List<String> trollNames;

    ImageElement imageElement;
    //so wigglers know if they remember this or not.
    int id;




    //if you don't have a stat it's zero
    AIItem(this.id, this.trollNames, this.imageLocations, {int external_value: 0, int curious_value: 0, int loyal_value: 0, int patience_value: 0, int energetic_value: 0, int idealistic_value: 0} ) {
        makePatience(patience_value);
        makeEnergetic(energetic_value);
        makeIdealistic(idealistic_value);
        makeCurious(curious_value);
        makeLoyal(loyal_value);
        makeExternal(external_value);
    }

    //depending on my image size, i need to be rendered in different places to be on the ground.
    void placeOnGround(CanvasElement groundCanvas) {
        Random rand = new Random();
        x = rand.nextInt(groundCanvas.width);
        y = groundCanvas.height - canvas.height;
        if(rand.nextBool()) turnWays = true;
    }

    Future<Null> pickImage() async {
        Random rand = new Random();
        String chosen = rand.pickFrom(imageLocations);
        imageElement = await Loader.getResource(("$folder$chosen"));
    }

    @override
    Future<Null> draw(CanvasElement destination) async {
        //draw self with rotation and scaling
        if(imageElement == null) await pickImage();
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