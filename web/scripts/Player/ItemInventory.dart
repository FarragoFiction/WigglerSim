import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import "../GameShit/AIItem.dart";
import "../GameShit/GameObject.dart";
import 'dart:convert';
import 'dart:math' as Math;


/*
 *Knows what current items the player has
 * and also has a static list of all possible items (for the shop)
 *
 * items in this list are dynamic, and built from a default list
 * list for different empress traits
 * and list for different castes in the 12 most recent trolls list (with stats from averages of these 12 trolls)
*/
class ItemInventory {

    static String ITEMLIST = "itemList";


    static get allItems {
        List<AIItem> ret = new List<AIItem>();
        ret.addAll(defaultItems);
        return ret;
    }

    static List<Pet> last12 = (GameObject.instance.last12Alumni);

    //the abs have pos and negative because they force a sign.
    static get calmABS {
        int value = Pet.averagePetEnergeticABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get realisticABS {
        int value = Pet.averagePetIdealisticABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);

    }

    static get acceptingABS {
        int value = Pet.averagePetCuriousABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get internalABS {
        int value = Pet.averagePetEnergeticABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get freeABS {
        int value = Pet.averagePetLoyalABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get impatientABS {
        int value = Pet.averagePetPatienceABS(last12);
        return -1* Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get energeticABS {
        int value = Pet.averagePetEnergeticABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get idealisticABS {
        int value = Pet.averagePetIdealisticABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get curiousABS {
        int value = Pet.averagePetCuriousABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get externalABS {
        int value = Pet.averagePetEnergeticABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get loyalABS {
        int value = Pet.averagePetLoyalABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    static get patientABS {
        int value = Pet.averagePetPatienceABS(last12);
        return Math.min(value, Stat.VERYFUCKINGHIGH+1);
    }

    //non abs keep the sign, so don't need positive or negative.
    static get energetic {
        return Pet.averagePetEnergetic(last12);
    }

    static get idealistic {
        return Pet.averagePetIdealistic(last12);
    }

    static get curious {
        return Pet.averagePetCurious(last12);
    }

    static get external {
        return Pet.averagePetEnergetic(last12);
    }

    static get loyal {
        return Pet.averagePetLoyal(last12);
    }

    static get patient {
        return Pet.averagePetPatience(last12);
    }


    //even default items should have stat values influenced by value of last 12 grubs
    //should have enough items that all stats are possible
    static List<AIItem> get  defaultItems

    {
        List<AIItem> ret = new List<AIItem>();
        //default items are based on troll stats, but still have a set positive/negative leaning.
        ret.add(new AIItem(0,<ItemAppearance>[new ItemAppearance("Soft Friend","Smupet_Blu.png"),new ItemAppearance("Legal Friend","redscale.png"),new ItemAppearance("Squiddle Friend","eldritchplushie.png"),new ItemAppearance("Man Friend","goofs.png")], energetic_value: calmABS, patience_value: patientABS));
        ret.add(new AIItem(0,<ItemAppearance>[new ItemAppearance("Fiduhost","fidushost.png"),new ItemAppearance("Best Friend","lil_cal.png"),new ItemAppearance("Stickball Demon","Felt_smuppet.png"),new ItemAppearance("Wing Beast","batpal.png")], energetic_value: energeticABS, patience_value: impatientABS));


        ret.add(new AIItem(0,<ItemAppearance>[new ItemAppearance("Beast Flesh","meat.png"),new ItemAppearance("Cherub Teeth","FakeCherubTeeth.png"),new ItemAppearance("Pastry Discs","cookies.png"),new ItemAppearance("Wicked Elixer","winners_dont_do_faygo.png")], curious_value: curiousABS, idealistic_value: realisticABS));
        ret.add(new AIItem(1,<ItemAppearance>[new ItemAppearance("Occular Root","carrot.png"),new ItemAppearance("Leaf Sphere","cabbage.png"),new ItemAppearance("Mystery Fruit","bigpumpkin.png"),new ItemAppearance("Small Mystery Fruit","LilPumpkin.png")], curious_value: acceptingABS, idealistic_value: idealisticABS));

        ret.add(new AIItem(2,<ItemAppearance>[new ItemAppearance("Feather Beast","Crow1.png"),new ItemAppearance("Hop Beast","frogsilent.png"),new ItemAppearance("Nap Meow Beast","SleepyMutie.png"),new ItemAppearance("My Little HoofBeast","maplehoof.png")],loyal_value: loyalABS, external_value: externalABS));
        ret.add(new AIItem(2,<ItemAppearance>[new ItemAppearance("Meow Beast","Mutie.png"),new ItemAppearance("Cuttle Creature","SmallFriend.png"),new ItemAppearance("Sea Hop Beast","frogcroak.png"),new ItemAppearance("Swim Beast","SmallerFriend.png")],loyal_value: freeABS, external_value: internalABS));

        return ret;
    }
    static List<AIItem> mutantItems;

    List<AIItem> _myItems = new List<AIItem>();

    ItemInventory();


    ItemInventory.fromJSON(String json){
        //print("loading pet inventory with json $json");
        if(json != null && json.isNotEmpty) loadFromJSON(json);
    }

    void addItem(AIItem item) {
        _myItems.add(item.copyItemForInventory());
        GameObject.instance.player.caegers += -1 * item.cost;
        GameObject.instance.save();
    }

    void removeItem(AIItem item) {
        _myItems.remove(item);
        GameObject.instance.save();
    }

    int numberOf(AIItem item) {
        int ret = 0;
        for(AIItem i in _myItems) {
            if(i.id == item.id) ret ++;
        }
        return ret;
    }


    void loadFromJSON(String json) {
        // print("In item inventory, json is $json");
        JSONObject jsonObj = new JSONObject.fromJSONString(json);
        String idontevenKnow = jsonObj[ITEMLIST];
        loadItemsFromJSON(idontevenKnow);
    }

    void loadItemsFromJSON(String idontevenKnow) {
        if(idontevenKnow == null) return;

        List<dynamic> what = JSON.decode(idontevenKnow);
        //print("what json is $what");
        for(dynamic d in what) {
            //print("dynamic json thing is  $d");
            JSONObject j = new JSONObject();
            j.json = d;
            _myItems.add(new AIItem.fromJSON(null,j));
        }

    }

    JSONObject toJson() {
        JSONObject json = new JSONObject();
        List<JSONObject> jsonArray = new List<JSONObject>();
        for(AIItem p in _myItems) {
            // print("Saving ${p.name}");
            jsonArray.add(p.toJson());
        }
        json[ITEMLIST] = jsonArray.toString(); //will this work?
       // print("item inventory json is: ${json} and items are ${_myItems.length}");
        return json;
    }


    Future<Null> drawShop(Element container) async {
        await drawItems(allItems, container);
    }

    Future<Null> drawInventory(Element container) async {
        await drawItems(_myItems, container);
    }

    //all shop does is tell items to render buy button instead of deploy button.
    Future<Null> drawItems(List<AIItem> chosenItems, Element container) async {
        for(AIItem item in chosenItems) {
            item.drawHTML(container);
        }
    }

}