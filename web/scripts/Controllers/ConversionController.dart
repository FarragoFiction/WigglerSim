import '../Pets/Pet.dart';
import '../Player/Player.dart';
import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";


GameObject game;
DivElement div = querySelector("#output");
void main() {
  loadNavbar();
  game = new GameObject(true);
  start();
}

Future<Null> start() async {
  await game.preloadManifest();
  ImageElement ab = new ImageElement(src: "images/NPCs/ab.png");
  div.append(ab);
  printToScreen("Hello. It seems you wish to initiate the Conversion Procedure. There is a 98.12314% chance that you will unlock new features upon completion. Please wait.");
  printToScreen("It is advised that you download a back up of your save data right now. I may be infallible, but your computer and internet connection is not.");
  saveButton();
}

void saveButton() {
  AnchorElement saveLink2 = new AnchorElement();
  //saveLink2.href = new UriData.fromString(window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain").toString();
  String string = window.localStorage[Player.DOLLSAVEID];
  Blob blob = new Blob([string]); //needs to take in a list o flists
  saveLink2.href = Url.createObjectUrl(blob).toString();
  saveLink2.target = "_blank";
  saveLink2.download = "recoverFileWigglerSimObjectURL.txt";
  saveLink2.setInnerHtml("Seriously, click this link to download a back up. I refuse to continue untill you do.");
  drawConversionButton();
  saveLink2.onClick.listen((Event e) {
    drawConversionButton();
  });
  div.append(saveLink2);
}

void saveButton2() {
  AnchorElement saveLink2 = new AnchorElement();
  //saveLink2.href = new UriData.fromString(window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain").toString();
  String string = window.localStorage[Player.DOLLSAVEID];
  Blob blob = new Blob([string]); //needs to take in a list o flists
  saveLink2.href = Url.createObjectUrl(blob).toString();
  saveLink2.target = "_blank";
  saveLink2.download = "recoverFileWigglerSimObjectURL.txt";
  saveLink2.setInnerHtml("Here's your new save. Make a back up. Make all the backups. Your wigglers will thank you.");
  div.append(saveLink2);
}


Future<Null> begin() async{
    //in theory all the names will do their own thing, but this makes SURE the legacy shit gets brought up
  printToScreen("First, we need to convert your caretaker, ${game.player.name}., ${game.player.doll.toDataBytesX()}");
    game.player.doll.name = game.player.name;
    await new Future.delayed(const Duration(milliseconds : 500));
    printToScreen("Done! ${game.player.doll.toDataBytesX()} Now it's time for your wigglers.... Don't worry, I'll treat them like my own subroutines.");
    for(Pet p in game.player.petInventory.pets) {
      String oldName = p.doll.name;
      p.doll.name = "Please Help.";
      await new Future.delayed(const Duration(milliseconds : 100));
      printToScreen("${p.name} is done! (Used to be $oldName) ${p.doll.toDataBytesX()}");
    }
    printToScreen("Done! Now it's time for your alumni.... ");

    for(Pet p in game.player.petInventory.alumni) {
      String oldName = p.doll.name;
      p.doll.name = p.name;
      await new Future.delayed(const Duration(milliseconds : 100));
      printToScreen("${p.name} is done!  (Used to be $oldName)");
    }
    printToScreen("Alright! Now we just hafta save. There is a 98.2342244037% this will be fine, but don't leave this page till I tell you to.");
    try {
      game.save();
      printToScreen("Success!!! Now you can go back to your ordinary life as a humble Wiggler caretaker and forget you ever saw me.");
      saveButton2();
    }catch(e, stacktrace) {
      printToScreen("Uh. Shit. I don't know what happened. But I do not what did NOT happen. Saving did not happen. Shit went wrong. $e, $stacktrace");
    }
}

void drawConversionButton() {
  div.setInnerHtml("");
  ButtonElement button = new ButtonElement()..text = "Begin Conversion Process";
  div.append(button);
  button.onClick.listen((Event e) {
    begin();
  });
}

void printToScreen(String text) {
  DivElement me = new DivElement()..setInnerHtml(text);
  me.style.paddingBottom = "10px";
  div.append(me);
}

