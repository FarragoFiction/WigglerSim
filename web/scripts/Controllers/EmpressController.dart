import '../Pets/JSONObject.dart';
import 'dart:convert';
import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../GameShit/Empress.dart';
import "navbar.dart";

GameObject game;
String SHAREDKEY = "SHARED_DATA";

int sharedFunds = 0;
Element output = querySelector('#output');
List<String> secretsForCalm = new List<String>();

void main() {
  loadNavbar();
  game = new GameObject(false);
  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  if(Empress.instance.allowsGambling()) {
    AnchorElement a = new AnchorElement(href: "blackJack.html");
    a.setInnerHtml("<img src = 'images/tinyMoney.png'><img src = 'images/tinyMoney.png'><img src = 'images/tinyMoney.png'>Challenge the Empress to a Game For More Funds?<img src = 'images/tinyMoney.png'><img src = 'images/tinyMoney.png'><img src = 'images/tinyMoney.png'>");

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

  if(Empress.instance.allowsImportingMutants()) {
    drawPossibleAdopts();
  }

  if(Empress.instance.allowsFundingTrees()) {
    drawConversionRate();
  }
}

void copySharedFromDataString(String dataString) {
  print("dataString is $dataString");
  String rawJson = new String.fromCharCodes(BASE64URL.decode(dataString));
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
    return "${BASE64URL.encode(ret.codeUnits)}";
  }catch(e) {
    print(e);
    print("Error Saving Data. Are there any special characters in there? ${sharedToJSON()} $e");
  }
}

void save() {
  print("saving...");
  window.localStorage[SHAREDKEY] = sharedToDataString().toString();
}


void drawPossibleAdopts() {
  DivElement element = new DivElement();
  element.text = "There are ${secretsForCalm} Wigglers to adopt.";
  AnchorElement a = new AnchorElement(href: "http://www.farragofiction.com/LOHAE")..target = "_blank"..text = "Play TreeSim to get Imports";
  a.style.display = "block";
  element.append(a);
  output.append(element);

}

void drawConversionRate() {
  DivElement element = new DivElement();
  AnchorElement a = new AnchorElement(href: "http://www.farragofiction.com/LOHAE")..target = "_blank"..text = "Play TreeSim to get Imports";

  InputElement amountToImport = importRate(element);

  exportRate(element);
  a.style.display = "block";
  element.append(a);
  output.append(element);

}

void exportRate(DivElement element) {
  DivElement exportElement = new DivElement();
  LabelElement label = new LabelElement()..text = "Amount to take from LOHAE: 0 Caegers";
  DivElement result2 = new DivElement()..text = "The Empress is willing to let you allocate 0 Caegers of your funding to your work in Horticulture.";
  result2.style.paddingTop = "15px";
  result2.style.width = "500px";
  result2.style.border = "3px solid black";
  result2.style.marginLeft = "auto";
  result2.style.marginRight = "auto";
  LabelElement labelBack2 = new LabelElement()..text = "${game.player.caegers}";
  InputElement amountToExport = new InputElement()..style.padding = "10px";;
  amountToExport.type = "range";
  amountToExport.min = "0";
  ButtonElement button2 = new ButtonElement()..text = "Accept";
  amountToExport.max = "${game.player.caegers}}";
  exportElement.append(label);
  exportElement.append(amountToExport);
  exportElement.append(labelBack2);
  exportElement.append(result2);
  result2.append(button2);
  element.append(exportElement);

  amountToExport.onChange.listen((Event e)
  {
    label.text = "Amount to take from WigglerSim: ${amountToExport.value} Caegers";
  });
}

InputElement importRate(DivElement element) {
   DivElement importElement = new DivElement()..style.padding = "10px";
  LabelElement label = new LabelElement()..text = "Amount to Import from LOHAE: 0 Caegers";
  DivElement result = new DivElement()..text = "The Empress is willing to give you 0 Caegers for your work in Horticulture.";
  result.style.paddingTop = "15px";

  InputElement amountToImport = new InputElement();
  LabelElement labelBack = new LabelElement()..text = "${sharedFunds}";
  ButtonElement button = new ButtonElement()..text = "Accept";
  amountToImport.type = "range";
  amountToImport.min = "0";
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
     label.text = "Amount to Import from LOHAE: ${amountToImport.value} Caegers";
   });



  element.append(importElement);
  return amountToImport;
}



