import 'dart:convert';
import 'dart:html';
import 'package:CommonLib/Random.dart';
import 'package:CommonLib/Utility.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/AIItem.dart';
import '../GameShit/Empress.dart';
import '../GameShit/GameObject.dart';
import '../Pets/Egg.dart';
import '../Pets/Pet.dart';
import '../Pets/Stat.dart';
import '../Pets/TreeBab.dart';
import '../Pets/Troll.dart';
import '../Player/ItemInventory.dart';
import '../Player/PetInventory.dart';
import "navbar.dart";

GameObject game;
Future<Null> main() async {
  loadNavbar();
  await Doll.loadFileData();

  game = new GameObject(true);

  querySelector("#npc").onClick.listen((e){

    window.location.href= "${window.location.href}?debug=signs";
  });

  if(getParameterByName("mode",null) == "edna") {
    ButtonElement button = new ButtonElement();
    button.text = ("Hair Make Over Time!!!");
    button.onClick.listen((e)
    {
      game.makeOverAlumni();
      game.save();
      window.location.href = "${window.location.href}";
    });
    querySelector("#output").append(button);
  }

  if(getParameterByName("talking",null) == "turtle") {
    showBreeding();
  }else {
    start();
  }
}

Future<Null> showBreeding() async {
  Element container = new DivElement();
  Element status = new DivElement();
  container.append(status);
  //window.localStorage.remove(PetInventory.FUCKPILE);
  querySelector('#output').append(container);
  if(!window.localStorage.containsKey(PetInventory.FUCKPILE)) {
        container.text = "You have selected no alumni to create a new generation!";
        return;
  }
  String fuckPile =window.localStorage[PetInventory.FUCKPILE];
  print("fuckpile is $fuckPile");
  List<Map<String,dynamic>> json = jsonDecode(window.localStorage[PetInventory.FUCKPILE]);
  List<Troll> realFuckPile = new List<Troll>();
  // for testing realFuckPile.addAll(GameObject.instance.player.petInventory.alumni);
  //print("what json is $what");
  bool lamiaMode = true;
  for(Map<String,dynamic> d in json) {
      Troll troll = Pet.loadPetFromJSON(d);
      status.text = "loading: ${troll.name}";
      //if tehre is even one non lamia, its not lamia
      if(!(troll.doll is HomestuckLamiaDoll)) lamiaMode =false;
      realFuckPile.add(troll);
  }

  int min = 4;
  int max = 12;
  if(lamiaMode) min = 2;

  DivElement instructions = new DivElement()..style.paddingTop="50px";
  if(lamiaMode) {
      instructions.text = "Pure Lamia breeding allows between $min and $max Lamia at a time.";
  }else {
      instructions.text = "Troll style breeding allows between $min and $max Trolls at a time.";
  }

  if(realFuckPile.length < min) {
      instructions.text = "${instructions.text} You only have ${realFuckPile.length} selected. You need ${min -realFuckPile.length } more.";
  }else if(realFuckPile.length > max) {
      instructions.text = "${instructions.text} You  have ${realFuckPile.length} selected, which is too many. You need to get rid of ${realFuckPile.length - max}. Click an Alumni to remove them.";

  }

  if(!GameObject.instance.player.petInventory.hasRoom) {
      instructions.text = "By Emperial Decree: You have no more room for wigglers! Let the ones you have already grow up first! ${instructions.text}";
  }

  container.append(instructions);

  if(realFuckPile.length >= min && realFuckPile.length <= max && GameObject.instance.player.petInventory.hasRoom) {
      ButtonElement fuck = new ButtonElement()..style.display="block"..style.marginLeft="auto"..style.marginRight="auto";
      ImageElement bucket = new ImageElement(src: "images/buckit.png");
      ImageElement turtle = new ImageElement(src: "images/turtle.png");
      ImageElement tree = new ImageElement(src: "images/tree.png");
      int price = 0;
      realFuckPile.forEach((Troll t) => price+= Empress.instance.priceOfTroll(t));
      price = realFuckPile.isEmpty ? 0:(price/realFuckPile.length).ceil();
      price = price.abs();
      DivElement priceText = new DivElement()..text = "Cost $price";
      fuck.append(bucket);
      fuck.append(turtle);
      fuck.append(tree);
      fuck.append(priceText);
      container.append(fuck);
      fuck.onClick.listen((Event e) {
          GameObject.instance.player.caegers += -1 * price;
          popEgg(realFuckPile,lamiaMode);
          //window.location.href = "petInventory.html";
      });
  }


  realFuckPile.forEach((Troll t) async {
      status.text = "displaying: ${t.name}";
      displayBreeder(status, realFuckPile, t, container);
  });

}

void popEgg(List<Troll> realFuckPile, bool lamiaMode) async {
   List<Doll> parents = new List<Doll>.from(realFuckPile.map((Troll t) => t.doll));
  Doll adult = Doll.breedDolls(parents);
  Doll grub;
  Pet pet;
  if(lamiaMode) {
      grub = Doll.convertOneDollToAnother(adult, new HomestuckTreeBab());
      pet = new TreeBab(grub);
      pet.name = "Descendant Fruit";
  }else {
      grub = Doll.convertOneDollToAnother(adult, new HomestuckGrubDoll());
      pet = new Egg(grub);
      pet.name = "Descendant Egg";
  }
  List<AIItem> items = new List<AIItem>();
  if(lamiaMode) {
      realFuckPile.forEach((Troll t) => items.addAll(fruitItems(t)));
  }else {
      realFuckPile.forEach((Troll t) => items.addAll(ancestralItems(t)));
  }
  AIItem item = new Random().pickFrom(items);
  await item.pickVersion();

  GameObject.instance.player.itemInventory.addItem(item,true);
  GameObject.instance.player.addPet(pet);
  GameObject.instance.save();
  DivElement popup = new DivElement()..classes.add("popup");
  popup.text = "Descendant and Ancestral Item Obtained!!!";
  CanvasElement eggCanvas =  await pet.draw();
  popup.append(eggCanvas);
  DivElement label = new DivElement()..text = item.name;
  popup.append(label);
  popup.append(item.imageElement);
  querySelector("#output").append(popup);
  window.onClick.listen((Event e) {
      window.location.href = "petInventory.html";
   });

}

List<AIItem> fruitItems(Troll troll) {
    List<AIItem> defaultItems = new List<AIItem>();
    defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Fruit", "bigpumpkin.png")], energetic_value: 85));
    defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Fruit", "LilPumpkin.png")], energetic_value: 85));
    defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Plant", "pot_of_green.png")], energetic_value: 85));
    defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Plant", "carrot.png")], energetic_value: 85));
    defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Plant", "cabbage.png")], energetic_value: 85));
    return defaultItems;
}

List<AIItem> ancestralItems(Troll troll) {
    List<AIItem> defaultItems = new List<AIItem>();

    if(troll.isPatient) {
        defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Goldblood Doll", "GoldbloodDoll.png")],loyal_value: troll.loyal.value, energetic_value: -1*troll.energetic.value.abs()));
        defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Jadeblood Doll", "JadebloodDoll.png")],patience_value: troll.patience.value, energetic_value: -1*troll.energetic.value.abs()));

    }
    if(troll.isCurious) {
        defaultItems.add(new AIItem(114, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Trophy", "HornTrophy.png")], energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs()), loyal_value: troll.loyal.value, curious_value: troll.curious.value.abs()));
        defaultItems.add(new AIItem(114, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Trophy", "OscarTrophy.png")], energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs()), loyal_value: troll.loyal.value, curious_value: troll.curious.value.abs()));

        defaultItems.add(new AIItem(114, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Glow Bug", "flyfulamber.png")], energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs()), loyal_value: troll.loyal.value, curious_value: troll.curious.value.abs()));
        defaultItems.add(new AIItem(118, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Honorable Tyranny Blood", "better_than_bleach.png")],curious_value: troll.curious.value, external_value: troll.external.value.abs(),loyal_value: troll.loyal.value.abs()));

        if(troll.curious.value > Stat.VERYFUCKINGHIGH) {
            defaultItems.add(new AIItem(121, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Cosbytop", "Cosbytop.png")], curious_value: troll.curious.value,external_value: troll.external.value.abs()));
            defaultItems.add(new AIItem(120, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral SCIENCE 3-DENT", "wiredent.png")],curious_value: troll.curious.value, idealistic_value: ItemInventory.makeNegative(troll.idealistic.value.abs())));
            defaultItems.add(new AIItem(113, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Alien Specimen", "MisterTFetus.png")],curious_value: troll.curious.value, idealistic_value: ItemInventory.makeNegative(troll.idealistic.value.abs())));
        }
        if(troll.curious.value > Stat.HIGH) {
            defaultItems.add(new AIItem(115, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral PCHOOOES", "pchoooes.png")], curious_value: troll.curious.value, patience_value:ItemInventory.makeNegative(troll.patience.value.abs()), energetic_value: troll.energetic.value.abs()));
            defaultItems.add(new AIItem(119, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Husktop", "skaiatop.png")],curious_value: troll.curious.value, external_value: ItemInventory.makeNegative(troll.external.value.abs())));

        }
        if(troll.curious.value > Stat.MEDIUM) {
            defaultItems.add(new AIItem(116, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Picture Box", "jpgcamera.png")],curious_value: troll.curious.value, patience_value: troll.patience.value, external_value: troll.external.value.abs()));
            defaultItems.add(new AIItem(117, <ItemAppearance>[new ItemAppearance("${troll.name}'s Ancestral Zap Cube", "skaianbattery.png")],curious_value: troll.curious.value, energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs())));
        }
    }
    return defaultItems;
}

void displayBreeder(Element status, List<Troll> realFuckPile, Troll t, Element container)  {
  DivElement me = new DivElement()..style.display='inline-block'..style.height="100px";
  container.append(me);

  me.onClick.listen((Event e) {
      removeFromFuckPile(realFuckPile, t);
  });
  status.text = "rendering: ${t.name}";
  CanvasElement tiny = new CanvasElement(height: (t.textHeight/2).ceil(), width: (t.textWidth/2).ceil());
  me.append(tiny);

  asyncRender(status, t, tiny);
}

Future asyncRender(Element status , Troll t, CanvasElement me) async {
  CanvasElement c = await GameObject.instance.player.petInventory.drawPet(new DivElement(), t);
  me.context2D.drawImageScaled(c,0,0, t.textWidth/2, t.textHeight/2);
  status.text = "drawing: ${t.name}";

}

void removeFromFuckPile(List<Troll> realFuckPile, Troll t) {
  realFuckPile.remove(t);
  List<JSONObject> jsonArray = new List<JSONObject>();
  realFuckPile.forEach((Troll t) =>jsonArray.add(t.toJSON()));
  window.localStorage[PetInventory.FUCKPILE] = jsonArray.toString();
  window.location.href = window.location.href;
}

Future<Null> start() async {
  await game.preloadManifest();
  Element container = new DivElement();
  container.style.display = "inline-block";
  querySelector('#output').append(container);
  if(game.player.petInventory.alumni.isEmpty) {
    container.setInnerHtml("You haven't raised any grubs, yet!");
  }else {
    game.drawAlumni(container);
  }
}