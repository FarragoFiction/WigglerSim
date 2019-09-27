import 'dart:convert';
import 'dart:html';
import 'package:CommonLib/Utility.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../Pets/Pet.dart';
import '../Pets/Troll.dart';
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
  querySelector('#output').append(container);
  String fuckPile =window.localStorage["FUCKPILE"];
  String idontevenKnow = window.localStorage["FUCKPILE"];
  List<Troll> realFuckPile = new List<Troll>();
  List<dynamic> what = jsonDecode(idontevenKnow);
  //print("what json is $what");
  bool lamiaMode = true;
  for(dynamic d in what) {
      //print("dynamic json thing is  $d");
      JSONObject j = new JSONObject();
      j.json = d;
      Troll troll = Pet.loadPetFromJSON("", j);
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
      instructions.text = "${instructions.text} You  have ${realFuckPile.length} selected, which is too many. You need to get rid of ${realFuckPile.length - max}.";

  }


  container.append(instructions);


  realFuckPile.forEach((Troll t) async {
      DivElement me = new DivElement()..style.display='inline-block';
      CanvasElement c = await GameObject.instance.player.petInventory.drawPet(new DivElement(), t);
      CanvasElement tiny = new CanvasElement(height: (t.textHeight/2).ceil(), width: (t.textWidth/2).ceil());
      tiny.context2D.drawImageScaled(c,0,0, t.textWidth/2, t.textHeight/2);
      me.append(tiny);
      container.append(me);
  });

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