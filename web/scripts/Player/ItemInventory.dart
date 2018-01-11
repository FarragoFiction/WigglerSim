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
        List<AIItem> ret = new List<AIItem>();
        ret.addAll(defaultItems);
        return ret;
    }

    //even default items should have stat values influenced by value of last 12 grubs
    //should have enough items that all stats are possible
    static List<AIItem> get  defaultItems

    {
        List<AIItem> ret = new List<AIItem>();
        List<Troll> last12 = (GameObject.instance.last12Alumni);
        //default items are based on troll stats, but still have a set positive/negative leaning.
        ret.add(new AIItem(0,<ItemAppearance>[new ItemAppearance("Soft Friend","Smupet_Blu.png"),new ItemAppearance("Legal Friend","redscale.png"),new ItemAppearance("Squiddle Friend","eldritchplushie.png"),new ItemAppearance("Man Friend","goofs.png")], energetic_value: -1* Pet.averagePetEnergetic(last12).abs(), idealistic_value: Pet.averagePetIdealistic(last12).abs()));
        ret.add(new AIItem(1,<ItemAppearance>[new ItemAppearance("Occular Root","carrot.png"),new ItemAppearance("Leaf Sphere","cabbage.png"),new ItemAppearance("Mystery Fruit","bigpumpkin.png"),new ItemAppearance("Small Mystery Fruit","LilPumpkin.png")], energetic_value: Pet.averagePetEnergetic(last12).abs(), idealistic_value: -1*Pet.averagePetIdealistic(last12).abs()));
        ret.add(new AIItem(2,<ItemAppearance>[new ItemAppearance("Feather Beast","Crow1.png"),new ItemAppearance("Hop Beast","frogsilent.png"),new ItemAppearance("Seadwelling Hop Beast","frogcroak.png"),new ItemAppearance("My Little HoofBeast","maplehoof.png")],idealistic_value: 1,external_value: 1, curious_value:1, energetic_value:1, loyal_value: Pet.averagePetLoyal(last12).abs(), patience_value: Pet.averagePetPatience(last12).abs()));

        return ret;
    }
    static List<AIItem> mutantItems;
    static List<AIItem> calmEmpressItems;


    List<AIItem> myItems = new List<AIItem>();

    Future<Null> drawShop(Element container) async {
        await drawItems(allItems, container);
    }

    Future<Null> drawInventory(Element container) async {
        await drawItems(myItems, container);
    }

    //all shop does is tell items to render buy button instead of deploy button.
    Future<Null> drawItems(List<AIItem> chosenItems, Element container) async {
        for(AIItem item in chosenItems) {
            item.drawHTML(container);
        }
    }

}