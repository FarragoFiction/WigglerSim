import "AIObject.dart";
import "../Pets/Stat.dart";
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
    List<String> imageLocations;
    //fuzzy friend, sleepy pal, etc. Weird memey shit.
    List<String> trollNames;



    //if you don't have a stat it's zero
    AIItem(this.trollNames, this.imageLocations, {int external_value: 0, int curious_value: 0, int loyal_value: 0, int patience_value: 0, int energetic_value: 0, int idealistic_value: 0} ) {
        makePatience(patience_value);
        makeEnergetic(energetic_value);
        makeIdealistic(idealistic_value);
        makeCurious(curious_value);
        makeLoyal(loyal_value);
        makeExternal(external_value);
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