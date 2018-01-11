import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import "../GameShit/AIItem.dart";
import "../GameShit/GameObject.dart";
import 'dart:convert';

/*
 *Knows what current items the player has
 * and also has a static list of all possible items (for the shop)
 *
 * items in this list are dynamic, and built from a default list
 * list for different empress traits
 * and list for different castes in the 12 most recent trolls list (with stats from averages of these 12 trolls)
 *
 * TODO: instead of picking a random pic/name, pick one based on whether item is low, mid, high or very high stats.
 *
 * TODO: method to turn an array of trolls into stats for an item (ignoring any stats that are zero in the itme)
 *
 * TODO: render an item along with it's stats (put in AI Item).
 *
 * TODO: method to copy a static item to the specific inventory.
 */
class ItemInventory {

    static get allItems {

    }

    //even default items should have stat values influenced by value of last 12 grubs
    static List<AIItem> get  defaultItems

    {
        List<AIItem> ret = new List<AIItem>();
        //TODO game object needs to have a get for last 12 alumni
        //then set stat values based on asking those alumni what the average of stat x or y is.
        //static method on pet?
        List<Troll> last12 = (GameObject.instance.player.petInventory.last12Alumni);

        ret.add(new AIItem(0,1,<ItemAppearance>[new ItemAppearance("Level 1","Smupet_Blu.png"),new ItemAppearance("Level 2","redscale.png"),new ItemAppearance("Level 3","eldritchplushie.png")], curious_value: AIItem.LOW, idealistic_value: -1*AIItem.HIGH));
        ret.add(new AIItem(0,1,<ItemAppearance>[new ItemAppearance("Level 1","Smupet_Blu.png"),new ItemAppearance("Level 2","redscale.png"),new ItemAppearance("Level 3","eldritchplushie.png")], curious_value: AIItem.LOW, idealistic_value: -1*AIItem.HIGH));
        ret.add(new AIItem(0,1,<ItemAppearance>[new ItemAppearance("Level 1","Smupet_Blu.png"),new ItemAppearance("Level 2","redscale.png"),new ItemAppearance("Level 3","eldritchplushie.png")], curious_value: AIItem.LOW, idealistic_value: -1*AIItem.HIGH));
        return ret;
    }
    static List<AIItem> mutantItems;
    static List<AIItem> calmEmpressItems;


    List<AIItem> myItems = new List<AIItem>();



}