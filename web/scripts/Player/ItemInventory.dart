import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';
import "../GameShit/AIItem.dart";
import "../GameShit/GameObject.dart";
import 'dart:convert';
import 'dart:math' as Math;
import "../GameShit/Empress.dart";
import 'package:CommonLib/Utility.dart';


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

    //what do you multiply troll stat values by to get item stats?
    static double statMultiplier = 0.5;


    static get allItems {
        List<AIItem> ret = new List<AIItem>();
        ret.addAll(defaultItems);
        return ret;
    }

    static List<Pet> last12 = (GameObject.instance.last12Alumni);

    static List<String> get last12ColorWords

    {
        List<String> ret = new List<String>();
        for(Troll t in last12) {
            ret.add(t.colorWord);
        }
        return ret;
    }

    //the abs have pos and negative because they force a sign.
    static int get calmABS {
        // + 1 because it makes items with no stats if no alum
        int value = Pet.averagePetEnergeticABS(last12)+1;
        return (statMultiplier*makeNegative(Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();
    }

    static int get realisticABS {
        int value = Pet.averagePetIdealisticABS(last12)+1;
        return (statMultiplier* makeNegative( Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();

    }

    static int get acceptingABS {
        int value = Pet.averagePetCuriousABS(last12)+1;
        return (statMultiplier*makeNegative( Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();
    }

    static int get internalABS {
        int value = Pet.averagePetExternalABS(last12)+1;
        return (statMultiplier*makeNegative(Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();
    }

    static int get freeABS {
        int value = Pet.averagePetLoyalABS(last12)+1;
        return (statMultiplier*makeNegative( Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();
    }

    static int get impatientABS {
        int value = Pet.averagePetPatienceABS(last12)+1;
        return (statMultiplier *makeNegative( Math.min(value, Stat.VERYFUCKINGHIGH+1))).round();
    }

    static int get energeticABS {
        int value = Pet.averagePetEnergeticABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get idealisticABS {
        int value = Pet.averagePetIdealisticABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get curiousABS {
        int value = Pet.averagePetCuriousABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get externalABS {
        int value = Pet.averagePetExternalABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get loyalABS {
        int value = Pet.averagePetLoyalABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    static  int get patientABS {
        int value = Pet.averagePetPatienceABS(last12)+1;
        return (statMultiplier* Math.min(value, Stat.VERYFUCKINGHIGH+1)).round();
    }

    //non abs keep the sign, so don't need positive or negative.
    static int get energetic {
        int value = Pet.averagePetEnergetic(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();

    }

    static int get idealistic {
        int value = Pet.averagePetIdealistic(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get curious {
        int value =  Pet.averagePetCurious(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get external {
        int value =  Pet.averagePetExternal(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get loyal {
        int value =  Pet.averagePetLoyal(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
    }

    static int get patient {
        int value =  Pet.averagePetPatience(last12);
        if(value == 0) return 1;
        int sign = (value/value.abs()).round();
        return (sign * statMultiplier* Math.min(value.abs(), Stat.VERYFUCKINGHIGH+1)).round();
    }

    //needed because i keep somehow getting -0.0 as a value.
    static int makeNegative(int number) {
        if(number == 0) number = 1;
        return number * -1;
    }


    //even default items should have stat values influenced by value of last 12 grubs
    //should have enough items that all stats are possible
    static List<AIItem> get  defaultItems

    {
        List<AIItem> ret = new List<AIItem>();
        ret.addAll(Empress.instance.items);
        //default items are based on troll stats, but still have a set positive/negative leaning.
        ret.add(new AIItem(0,<ItemAppearance>[new ItemAppearance("Soft Friend","Smupet_Blu.png"),new ItemAppearance("Legal Friend","redscale.png"),new ItemAppearance("Squiddle Friend","eldritchplushie.png"),new ItemAppearance("Man Friend","goofs.png")], energetic_value: calmABS, patience_value: patientABS));
        ret.add(new AIItem(1,<ItemAppearance>[new ItemAppearance("Fiduhost","fidushost.png"),new ItemAppearance("Best Friend","lil_cal.png"),new ItemAppearance("Stickball Demon","Felt_smuppet.png"),new ItemAppearance("Wing Beast","batpal.png")], energetic_value: energeticABS, patience_value: impatientABS));


        ret.add(new AIItem(2,<ItemAppearance>[new ItemAppearance("Beast Flesh","meat.png"),new ItemAppearance("Cherub Teeth","FakeCherubTeeth.png"),new ItemAppearance("Pastry Discs","cookies.png"),new ItemAppearance("Wicked Elixer","winners_dont_do_faygo.png")], curious_value: curiousABS, idealistic_value: realisticABS));
        ret.add(new AIItem(3,<ItemAppearance>[new ItemAppearance("Ocular Root","carrot.png"),new ItemAppearance("Leaf Sphere","cabbage.png"),new ItemAppearance("Mystery Fruit","bigpumpkin.png"),new ItemAppearance("Small Mystery Fruit","LilPumpkin.png")], curious_value: acceptingABS, idealistic_value: idealisticABS));

        ret.add(new AIItem(4,<ItemAppearance>[new ItemAppearance("Feather Beast","Crow1.png"),new ItemAppearance("Hop Beast","frogsilent.png"),new ItemAppearance("Nap Meow Beast","SleepyMutie.png"),new ItemAppearance("My Little HoofBeast","maplehoof.png")],loyal_value: loyalABS, external_value: externalABS));
        ret.add(new AIItem(5,<ItemAppearance>[new ItemAppearance("Meow Beast","Mutie.png"),new ItemAppearance("Cuttle Creature","SmallFriend.png"),new ItemAppearance("Sea Hop Beast","frogcroak.png"),new ItemAppearance("Swim Beast","SmallerFriend.png")],loyal_value: freeABS, external_value: internalABS));

        ret.add(new AIItem(1005,<ItemAppearance>[new ItemAppearance("Tricky Book","wiseguy.png"),new ItemAppearance("FLARP Manuals","flarps.png"),new ItemAppearance("Dark Magycks","black_book.png"),new ItemAppearance("~ATH Book","athbook.png")],patience_value: patient, loyal_value: loyal, external_value: external, curious_value: curious, energetic_value: energetic, idealistic_value: idealistic));
        ret.add(new AIItem(1006,<ItemAppearance>[new ItemAppearance("Tab","tabstack.png"),new ItemAppearance("Grain Teeth","CornCan.png"),new ItemAppearance("Nutrition Tall Circles","cans2.png")],patience_value: makeNegative(patient), loyal_value: makeNegative(loyal), external_value: makeNegative(external), curious_value: makeNegative(curious), energetic_value: makeNegative(energetic), idealistic_value: makeNegative(idealistic)));
        ret.add(new AIItem(1007,<ItemAppearance>[new ItemAppearance("Loyal Partner","pyralspite_-_scalemate_single.png"),new ItemAppearance("Evidence","beetle_bag.png"),new ItemAppearance("Fiduspawn Cards","fiducards.png"),new ItemAppearance("4 Wheel Device","Sk8Board.png")], loyal_value: loyal, external_value: external,energetic_value: calmABS, patience_value: patientABS));
        ret.add(new AIItem(1007,<ItemAppearance>[new ItemAppearance("Soft Pile","scarf_pile.png"),new ItemAppearance("Friend Pile","stuffpile.png"),new ItemAppearance("Duttle","theduttle.png"),new ItemAppearance("Highblood Pillow","velvetpillow.png")], idealistic_value: idealistic, curious_value: curious,energetic_value: calmABS, patience_value: patientABS));
        ret.add(new AIItem(1008,<ItemAppearance>[new ItemAppearance("Soft Victim","Smupet_red.png"),new ItemAppearance("Best Enemy","do_you_want_to_play_a_game.png"),new ItemAppearance("Accused Pile","TH34CCUS3D.png"),new ItemAppearance("Criminal Scum","scalemate.png")], idealistic_value: makeNegative(idealistic), curious_value: makeNegative(curious),energetic_value: energeticABS, patience_value: impatientABS));

        List<String> colors = last12ColorWords;

        if(colors.contains(HomestuckTrollDoll.BURGUNDY)) {
            ret.add(new AIItem(6,<ItemAppearance>[new ItemAppearance("Burgundy Essence","burgundy.png")], patience_value: impatientABS));
        }

        if(colors.contains(HomestuckTrollDoll.BRONZE)) {
            ret.add(new AIItem(7,<ItemAppearance>[new ItemAppearance("Bronze Essence","bronze.png")], loyal_value: freeABS));
        }

        if(colors.contains(HomestuckTrollDoll.GOLD)) {
            ret.add(new AIItem(8,<ItemAppearance>[new ItemAppearance("Gold Essence","gold.png")], energetic_value: calmABS));
        }

        if(colors.contains(HomestuckTrollDoll.LIME)) {
            ret.add(new AIItem(9,<ItemAppearance>[new ItemAppearance("Lime Essence","lime.png")], loyal_value: loyalABS));
        }

        if(colors.contains(HomestuckTrollDoll.OLIVE)) {
            ret.add(new AIItem(10,<ItemAppearance>[new ItemAppearance("Olive Essence","olive.png")], external_value: internalABS));
        }

        if(colors.contains(HomestuckTrollDoll.JADE)) {
            ret.add(new AIItem(11,<ItemAppearance>[new ItemAppearance("Jade Essence","jade.png")], patience_value: patientABS));
        }

        if(colors.contains(HomestuckTrollDoll.TEAL)) {
            ret.add(new AIItem(12,<ItemAppearance>[new ItemAppearance("Teal Essence","teal.png")], external_value: externalABS));
        }

        if(colors.contains(HomestuckTrollDoll.CERULEAN)) {
            ret.add(new AIItem(13,<ItemAppearance>[new ItemAppearance("Cerulean Essence","cerulean.png")], curious_value: curiousABS));
        }

        if(colors.contains(HomestuckTrollDoll.INDIGO)) {
            ret.add(new AIItem(14,<ItemAppearance>[new ItemAppearance("Indigo Essence","indigo.png")], curious_value: acceptingABS));
        }

        if(colors.contains(HomestuckTrollDoll.PURPLE)) {
            ret.add(new AIItem(15,<ItemAppearance>[new ItemAppearance("Purple Essence","purple.png")], idealistic_value: realisticABS));
        }

        if(colors.contains(HomestuckTrollDoll.VIOLET)) {
            ret.add(new AIItem(16,<ItemAppearance>[new ItemAppearance("Violet Essence","violet.png")], idealistic_value: idealisticABS));
        }

        if(colors.contains(HomestuckTrollDoll.FUCHSIA)) {
            ret.add(new AIItem(17,<ItemAppearance>[new ItemAppearance("Fuschsia Essence","fuchsia.png")], energetic_value: energeticABS));
        }

        if(colors.contains(HomestuckTrollDoll.MUTANT)) {
            ret.add(new AIItem(18,<ItemAppearance>[new ItemAppearance("Mutant Essence","mutant.png")], loyal_value: loyalABS));
        }


        return ret;
    }
    static List<AIItem> mutantItems;

    List<AIItem> _myItems = new List<AIItem>();
    int get numItems =>_myItems.length;


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

    void loadItemsFromJSON(String input) {
        if(input == null) return;

        List<dynamic> j = jsonDecode(input);

        for(dynamic item in j) {
            if (item is String) {
                _myItems.add(new AIItem.fromJSON(item));
            }
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