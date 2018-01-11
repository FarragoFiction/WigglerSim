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
 */
class ItemInventory {

    static get allItems {

    }

    static List<AIItem> defaultItems;
    static List<AIItem> mutantItems;
    static List<AIItem> calmEmpressItems;



}