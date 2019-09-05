import '../GameShit/MoneyHandler.dart';
import '../Pets/CapsuleTIMEHOLE.dart';
import '../Pets/Grub.dart';
import 'package:CommonLib/Utility.dart';
import 'dart:convert';
import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/Empress.dart';
import '../Pets/Pet.dart';
import '../Pets/Stat.dart';
import '../Pets/TreeBab.dart';
import "navbar.dart";

GameObject game;
String SHAREDKEY = "SHARED_DATA";

int sharedFunds = 0;
Element output = querySelector('#output');
List<String> secretsForCalm = new List<String>();

Future<Null> main() async {
  loadNavbar();
  await Doll.loadFileData();
  game = new GameObject(false);
  start();
}

Future<Null> start() async {
  if(Empress.instance.allowsGambling()) {
    AnchorElement a = new AnchorElement(href: "blackJack.html");
    a.style.display = "block";
    String money = Empress.instance.moneyImageLocation();
    a.setInnerHtml("<img src = '${money}'><img src = '${money}'><img src = '${money}'>Challenge the Empress to a Game For More Funds?<img src = '${money}'><img src = '${money}'><img src = '${money}'>");

    querySelector('#output').append(a);
  }

  if(Empress.instance.allowsAdoptingWigglersfromTIMEHOLE() || getParameterByName("trade",null) == "wonder") {
    AnchorElement a = new AnchorElement(href: "TIMEHOLE.html?adopt=selflessly");
    a.style.display = "block";
    a.setInnerHtml("Selflessly adopt an abandoned wiggler?");

    querySelector('#output').append(a);
  }
  Element container = new DivElement();
  querySelector('#output').append(container);

  Empress.instance.drawDecrees(container);

  processTreeSim();

}


void processTreeSim() {
  if(window.localStorage.containsKey(SHAREDKEY)) {
    copySharedFromDataString(window.localStorage[SHAREDKEY]);
  }
  drawPossibleAdopts();

  if(Empress.instance.allowsFundingTrees()) {
    drawConversionRate();
  }
}

void copySharedFromDataString(String dataString) {
  print("dataString is $dataString");
  String rawJson = new String.fromCharCodes(base64Url.decode(dataString));
  print("rawJSON is $rawJson");
  JSONObject json = new JSONObject.fromJSONString(rawJson);
  print("json is $json");
  copySharedFromJSON(json);
}

void copySharedFromJSON(JSONObject json) {
  secretsForCalm = json["CALM_SECRETS"].split(",").where((s) => s.isNotEmpty).toList();
  sharedFunds= int.parse(json["SHARED_FUNDS"]);

}

JSONObject sharedToJSON() {
  JSONObject json = new JSONObject();
  json["SHARED_FUNDS"] = "${sharedFunds}";
  json["CALM_SECRETS"] = secretsForCalm.join(",");
  return json;
}

String sharedToDataString() {
  try {
    String ret = sharedToJSON().toString();
    print("the json string for shared data was $ret");
    return "${base64Url.encode(ret.codeUnits)}";
  }catch(e) {
    print(e);
    print("Error Saving Data. Are there any special characters in there? ${sharedToJSON()} $e");
  }
}

void save() {
  print("saving...");
  window.localStorage[SHAREDKEY] = sharedToDataString().toString();
}

void drawCanon() async {
  DivElement element = new DivElement();
  output.append(element);
  List<Pet> canon = new List<Pet>();

  canon.add(makeOthala());
  canon.add(makeEirikr());
  canon.add(makeDespap());
  canon.add(makePeewee());
  canon.add(makeZawhei());
  canon.add(makeHagala());

  for(Pet p in canon) {
    p.makeCorrupt();
    await game.player.petInventory.drawPet(output, p);
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE(p, "yggdrasilsYeoman");
    output.appendHtml(capsule.toJson().toString());
  }
  Doll doll = Doll.loadSpecificDoll("Despap Citato:___ArBhlggBlggBDYACFr_94nuZzk9BlggBlggAA_wAAAABAUwBQaABlggATExMAAAApHVMgFUYA_wAA_wBJSUlpuMgHhEYDQiMIgSwJYDtgLQBpeAp0AxgGMAqAFRg");
  output.append(await doll.getNewCanvas());
  /*
  String website = "https://plaguedoctors.herokuapp.com";
  String url = "$website/time_holes/abdicateTIMEHOLE";
  await HttpRequest.postFormData(url,capsule.makePostData(true));
  print("despap is $despap");
  */
}

Pet makeHagala() {
  final Pet hagala = new TreeBab(Doll.loadSpecificDoll("Hagala Folnir:___ArBhhdPvZxu1AAICFr_94nuZzk9AAAAAAAAAA_wAAAADZxu2QhJ5gWGkTExMAAAApHVMgFUYA_wAA_wBJSUlpuMiFr_9zk9AI_A8YYgIVAMcBjgRAImA"));

  hagala.name = "Hagala Folnir";
  for(Stat stat in hagala.stats) {
    stat.value = 0;
  }
  hagala.patience.value = 113;
  return hagala;
}

Pet makeOthala() {
  final Pet pet = new TreeBab(Doll.loadSpecificDoll("Othala Grigor:___ArBiZAE3y4Onju8-Fr_94nuZzk9AAAAAAAAAA_wAAAADy4OnyyN3ykMETExMAAAApHVMgFUYA_wAA_wBJSUlpuMgzMzMREREIgE_AJ-AUrANWl0AbcA24BowDR4="));

  pet.name = "Othala Grigor";
  for(Stat stat in pet.stats) {
    stat.value = 0;
  }
  pet.loyal.value = 113;
  return pet;
}

Pet makeEirikr() {
  final Pet pet = new TreeBab(Doll.loadSpecificDoll("Eirikr Kharun:___ArBjS0clCAAAvAACFr_94nuZzk9AAAAAAAAAA_wAAAABCAACEAABCAAATExMAAAApHVMgFUYA_wAA_wBJSUlpuMihAABQAAAIgPQB6AO7AmeBXQSCQDUAamA"));

  pet.name = "Eirikr Kharun";
  for(Stat stat in pet.stats) {
    stat.value = 0;
  }
  pet.curious.value = -113;
  return pet;
}

Pet makeDespap() {
  final Pet pet = new TreeBab(Doll.loadSpecificDoll("Despap Citato:___ArBhlggBlggBDYACFr_94nuZzk9AAAAAAAAAA_wAAAABAUwBQaABlggATExMAAAApHVMgFUYA_wAA_wBJSUlpuMgHhEYDQiMIgSwJYDtgLQBpeAp0AxgGMAqAFRg"));
  pet.name = "Despap Citato";
  for(Stat stat in pet.stats) {
    stat.value = 0;
  }
  pet.idealistic.value = -113;
  return pet;
}

Pet makePeewee() {
  final Pet pet = new TreeBab(Doll.loadSpecificDoll("Peewee 'The Man' Cassan:___ArBihoQBfXwCAgACFr_94nuZzk9AAAAAAAAAA_wAAAACIiABfXwCIiAATExMAAAApHVMgFUYA_wAA_wBJSUlpuMhlggAyQQAIgOgB0Ab4HwBMfQPgfAOYBzY"));

  pet.name = "Peewee `The Man` Cassan";
  for(Stat stat in pet.stats) {
    stat.value = 0;
  }
  pet.energetic.value = -113;
  return pet;
}

Pet makeZawhei() {
  final Pet pet = new TreeBab(Doll.loadSpecificDoll("Zawhei Bacama:___ArBgHhEZJpHcFYiT________AwMAAAAAAAAAA_wAAAAAFYiQHhEYFYiQTExMAAAApHVMgFUYA_wAA_wBJSUlpuMgAQYIAIEEIgJoBNAEEgIz9ALwBeAEhAJDgA=="));
      pet.name = "Zawhei Bacama";
  for(Stat stat in pet.stats) {
    stat.value = 0;
  }
  pet.energetic.value = 113;
  return pet;
}


void drawPossibleAdopts() {
  //drawCanon();
  DivElement element = new DivElement();
  secretsForCalm.add("Fred+Feelix%3A___HBS5TN0AIcsAEGX43FfRqTuthx7_qP__qP8AIcsAAAADUA4ANBrq6Oe_wsH_qP__W_-MytYAIcsAEGUIgcQOIFD_OATIAmQBSgClYA%3D%3D");
   //secretsForCalm.add("Fuchsia+Blooded+Grub%3A___HBTMw7GZAE1MACaZAE3jAHFMACaZAE2ZAE2ZAE0AAABLS0s6OjoREREAAAAREREzMzPExMSZAE1MACYIgJwBOALCDsIJcUCcE4CxAWOA");

  String word = "Wigglers";
  if(Empress.instance.troll != null && Empress.instance.troll.corrupt) word = "Siblings";
  element.text = "There are ${secretsForCalm.length} $word to adopt from LOHAE.";
  AnchorElement a = new AnchorElement(href: "http://www.farragofiction.com/LOHAE")..target = "_blank"..text = "Play TreeSim to get Imports";
  a.style.display = "block";
  element.append(a);
  output.append(element);


  for(String dataString in secretsForCalm) {
    SpanElement subContainer = new SpanElement()..style.width = "420px"..style.display="inline-block";
    element.append(subContainer);
    TreeBab p = new TreeBab(Doll.loadSpecificDoll(dataString));
    p.name = "Nidhogg's Child";
    String corrupt = "Corrupt";

    if(dollIsPurified(p.doll)){
      p.makePure();
      corrupt = "Purified";
    }else{
      p.makeCorrupt();
    }
    game.player.petInventory.drawPet(subContainer, p);
    if(Empress.instance.allowsImportingMutants()) {
      ButtonElement button = new ButtonElement();

      button.text = "Adopt the $corrupt ${(p.doll as HomestuckTreeBab).bloodColor} Blood?";
      subContainer.append(button);

      button.onClick.listen((Event e) {
        subContainer.remove();
        game.player.petInventory.pets.add(p);
        secretsForCalm.remove(dataString);
        save();
        game.save();
      });
    }else {
      DivElement divElement = new DivElement()..text = "By Imperial Decree severe mutants (defined as trolls with non standard, plant based, internal structures, colliqually known as 'corruption') are culled on sight, for the good of all. (Yes, even those 'purified' trolls)";
      subContainer.append(divElement);
    }

  }



}

bool dollIsPurified(HomestuckTreeBab doll) {
  HomestuckPalette palette = doll.palette as HomestuckPalette;
  if(palette.skin == ReferenceColours.PURIFIED.skin) return true;
}



void drawConversionRate() {
  DivElement element = new DivElement();
  AnchorElement a = new AnchorElement(href: "http://www.farragofiction.com/LOHAE")..target = "_blank"..text = "Play TreeSim to get Imports";

  importRate(element);

  exportRate(element);
  a.style.display = "block";
  element.append(a);
  output.append(element);

}

void exportRate(DivElement element) {
  DivElement exportElement = new DivElement();
  LabelElement label = new LabelElement()..text = "Amount to take from WigglerSim: 0 Caegers";
  DivElement result2 = new DivElement();
  DivElement resultInner = new DivElement();
  result2.append(resultInner);
  result2.style.paddingTop = "15px";
  result2.style.width = "500px";
  result2.style.border = "3px solid black";
  result2.style.marginLeft = "auto";
  result2.style.marginRight = "auto";
  LabelElement labelBack = new LabelElement()..text = "${game.player.caegers}";
  InputElement amountToExport = new InputElement()..style.padding = "10px";;
  amountToExport.type = "range";
  amountToExport.value = "0";
  amountToExport.min = "0";
  ButtonElement button2 = new ButtonElement()..text = "Accept";
  amountToExport.max = "${game.player.caegers}";
  exportElement.append(label);
  exportElement.append(amountToExport);
  exportElement.append(labelBack);
  exportElement.append(result2);
  result2.append(button2);
  element.append(exportElement);

  amountToExport.onChange.listen((Event e)
  {
    label.text = "Amount to take from WigglerSim: ${amountToExport.value} Caegers";
    resultInner.text = "The Empress is willing to let you allocate ${amountToExport.value} Caegers of your funding to your work in Horticulture.";
  });

  button2.onClick.listen((Event e) {
    GameObject.instance.player.caegers = GameObject.instance.player.caegers - int.parse(amountToExport.value);
    GameObject.instance.save();
    MoneyHandler.instance.sync();
    sharedFunds += int.parse(amountToExport.value);
    save();
    window.location.href = window.location.href;
  });
}

void importRate(DivElement element) {
   DivElement importElement = new DivElement()..style.padding = "10px";
  LabelElement label = new LabelElement()..text = "Amount to Take from LOHAE: 0 Caegers";
  DivElement result = new DivElement();
  DivElement resultInner = new DivElement();
  result.append(resultInner);
  result.style.paddingTop = "15px";

  InputElement amountToImport = new InputElement();
  LabelElement labelBack = new LabelElement()..text = "${sharedFunds}";
  ButtonElement button = new ButtonElement()..text = "Accept";
  amountToImport.type = "range";
  amountToImport.min = "0";
  amountToImport.value = "0";

   amountToImport.max = "$sharedFunds";
  importElement.append(label);
  importElement.append(amountToImport);
  importElement.append(labelBack);
  importElement.append(result);
  result.append(button);
  result.style.width = "500px";
  result.style.marginLeft = "auto";
  result.style.marginRight = "auto";
  result.style.border = "3px solid black";

   amountToImport.onChange.listen((Event e)
   {
     label.text = "Amount to Take from LOHAE: ${amountToImport.value} Caegers";
     resultInner.text = "The Empress is willing to give you ${amountToImport.value} Caegers for your work in Horticulture.";

   });

   button.onClick.listen((Event e) {
     GameObject.instance.player.caegers = GameObject.instance.player.caegers + int.parse(amountToImport.value);
     GameObject.instance.save();
     MoneyHandler.instance.sync();
     sharedFunds += -1* int.parse(amountToImport.value);
     save();
     window.location.href = window.location.href;
   });



  element.append(importElement);
}



