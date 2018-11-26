import '../GameShit/Empress.dart';
import '../Pets/CapsuleTIMEHOLE.dart';
import '../Pets/Grub.dart';
import '../Pets/JSONObject.dart';
import '../Pets/Pet.dart';
import 'dart:html';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
import "dart:math" as Math;

import 'package:DollLibCorrect/src/Dolls/KidBased/HomestuckGrubDoll.dart';
import 'package:DollLibCorrect/src/Rendering/ReferenceColors.dart';


GameObject game;
DivElement output = querySelector("#output");
bool monster = false;
int numHax = 0;
bool savior = false;
void main() {
    loadNavbar();
    game = new GameObject(true);
    querySelector("#npc").onClick.listen((e){

        window.location.href= "${window.location.href}?open=saysjr";
    });

    start();
}

Future<Null> start() async {
    Empress e = Empress.instance;
    if(window.location.href.contains("localhost")&& getParameterByName("open",null) == "saysjr") {
        jrHax();
        return;
    }

    if(getParameterByName("weaponofchoice",null) == "curiosity"){
        viewTIMEHOLE();
        return;
    }else {
        AnchorElement a = new AnchorElement(href: "TIMEHOLE.html?weaponofchoice=curiosity")..text ="Peer Into Time Hole Y/N?";
        output.append(a);
    }
    if(!e.allowsAdoptingWigglersfromTIMEHOLE() && !e.allowsAbdicatingWigglersToTIMEHOLE() && !e.allowTIMEHOLE()) {
        output.text = "By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE.";
        return;
    }

    if(getParameterByName("adopt",null) == "selflessly") {
        savior = true;
        if(!e.allowsAdoptingWigglersfromTIMEHOLE()) {
            output.text = "By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE TO ADOPT WIGGLERS.";
            return;
        }
        if(game.player.petInventory.hasRoom) {
            adopt();
        }else {
            output.text = "You don't have enough ENERGY to adopt more wigglers. Focus on your current brood first.";
        }
        return;
    }
    CapsuleTIMEHOLE capsule;
    try {
        capsule = new CapsuleTIMEHOLE.fromJson(
            new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]));
    }catch(error) {
        output.text = "Haha, nope, gotta pick a wiggler first, k? No wasting online stuff, yeah?";
        return;
    }
    //TODO send them flipping into the TIMEHOLE
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);

    String text = "Chuck into TIMEHOLE Y/N???";
    if(getParameterByName("abandon",null) == "youmonster") {
        if(!e.allowsAbdicatingWigglersToTIMEHOLE()) {
            output.text = "By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE TO ABANDON WIGGLERS.";
            return;
        }
        text = "$text You won't get anything back, you monster.";
        monster = true;
    }
    if(!e.allowTIMEHOLE()) {
        output.text = "By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE TO TRADE WIGGLERS.";
        return;
    }
    ButtonElement button = new ButtonElement()..text = "$text";
    output.append(button);
    button.style.display = "block";
    button.style.marginLeft = "auto";
    button.style.marginRight = "auto";
    button.onClick.listen((Event e) {
        button.remove();
        TIMEHOLE(capsule,canvas);
    });
}

Future<Null> jrHax() async {
    String url = "https://plaguedoctors.herokuapp.com/time_holes/abdicateTIMEHOLE";
    Pet pet = new Grub(new HomestuckGrubDoll());
    pet.name = "Hacked ${pet.doll.name}";
    //pet.doll.copyPalette(ReferenceColours.MIND);
    CapsuleTIMEHOLE haxCapsule = new CapsuleTIMEHOLE(pet,"JR's Hax");
    try {
        await HttpRequest.postFormData(url,haxCapsule.makePostData())
            .then(jrHaxNext);
    }catch(error, trace) {
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }

}

void jrHaxNext(HttpRequest request)  {
    numHax ++;
    output.appendHtml("Hax $numHax complete.");
    if(numHax < 13) {
        jrHax();
    }else {
        output.appendHtml("All Hax Complete");
    }
}

Future<Null> TIMEHOLE(CapsuleTIMEHOLE capsule, CanvasElement canvas) async {
    DivElement div = new DivElement();
    output.append(div);
    new LoadingAnimation("Chucking ${capsule.pet.name} into the TIMEHOLE...",canvas,div );
    GameObject.instance.playMusic("WTWJ1");
    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 1));

    String url = "https://plaguedoctors.herokuapp.com/time_holes/TIMEHOLE";
    if(monster) {
        url = "https://plaguedoctors.herokuapp.com/time_holes/abdicateTIMEHOLE";
    }

    /*if(true) {
        url = "http://localhost:3000/time_holes/TIMEHOLE";
    }*/

    try {
        await HttpRequest.postFormData(url,capsule.makePostData())
            .then(finishLoadingJSON);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}

Future<Null> viewTIMEHOLE() async {
    DivElement div = new DivElement();
    output.append(div);
    new LoadingAnimation("Peering into TIMEHOLE.",null,div );
    GameObject.instance.playMusic("WTWJ1");
    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 1));

    String url = "https://plaguedoctors.herokuapp.com/time_holes.json";
    //String url = "http://localhost:3000/time_holes.json";

    try {
        await HttpRequest.getString(url)
            .then(finishLoadingJSONGetAll);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}

Future<Null> adopt() async {
    DivElement div = new DivElement();
    output.append(div);
    new LoadingAnimation("Looking for abandoned wigglers in need of a home...",null,div );
    GameObject.instance.playMusic("WTWJ1");
    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 3));

    String url = "https://plaguedoctors.herokuapp.com/time_holes/adoptTIMEHOLE";
    try {
        await HttpRequest.getString(url)
            .then(finishLoadingJSONGet);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}



void finishLoadingJSON(HttpRequest request)  {
    LoadingAnimation.instance.stop();
    GameObject.instance.playMusicOnce("WTJ2");
    CapsuleTIMEHOLE originalCapsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]));
    if(monster) {
        GameObject.instance.removePet(originalCapsule.pet);
        output.appendHtml("You have one less wiggler to raise!!! You monster.");
    }else {

        JSONObject outerJSON = new JSONObject.fromJSONString(
            request.responseText);
        JSONObject innerJSON = new JSONObject.fromJSONString(
            outerJSON["wigglerJSON"]);
        CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(innerJSON);
        displayNewGrub(capsule,false);
        print("adding new pet ${capsule.pet}");
        GameObject.instance.removePet(originalCapsule.pet);
        GameObject.instance.addPet(capsule.pet);
        window.localStorage.remove("TIMEHOLE");
    }
}

void finishLoadingJSONGet(String response)  {
    LoadingAnimation.instance.stop();
    GameObject.instance.playMusicOnce("WTJ2");
    JSONObject outerJSON = new JSONObject.fromJSONString(response);
    JSONObject innerJSON = new JSONObject.fromJSONString(outerJSON["wigglerJSON"]);
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(innerJSON);
    displayNewGrub(capsule,false);
    print("adding new pet ${capsule.pet}");
    GameObject.instance.addPet(capsule.pet);
    window.localStorage.remove("TIMEHOLE");
}

Future<Null> finishLoadingJSONGetAll(String response) async  {
    LoadingAnimation.instance.stop();
    GameObject.instance.playMusicOnce("WTJ2");
    List<CapsuleTIMEHOLE> capsules = CapsuleTIMEHOLE.getAllFromJSON(response);
    //getting them isn't that expensive, but rendering them is so cool it.
    render13Wigglers(capsules);
}

Future<Null> render13Wigglers(List<CapsuleTIMEHOLE> capsules) async {
    int amount = 33;
    for(int i = 0; i <amount; i++) {
        if(capsules.length > i) {
            CapsuleTIMEHOLE c = capsules[i];
            await new Future.delayed(new Duration(milliseconds: 150));
            displayNewGrubForViewer(c, true);
        }
    }
    ButtonElement button = new ButtonElement()..text = "Show $amount more?";
    output.append(button);
    button.onClick.listen((Event e) {
        capsules.removeRange(0,Math.min(amount,capsules.length));
        button.remove();
        render13Wigglers(capsules);
    });
}




Future<Null> displayNewGrub(CapsuleTIMEHOLE capsule, bool readOnly) async {
    //print("displaying new grub");
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);
    String text =  "You got: ${capsule.pet.name} from ${capsule.breederName}!!!";
    if(savior) text = "You selflessly adopted: ${capsule.pet.name} from ${capsule.breederName}!!!";
    if(readOnly) text  = "${capsule.pet.name} from ${capsule.breederName}";
    DivElement div = new DivElement()..text = text;
    output.append(div);
}

Future<Null> displayNewGrubForViewer(CapsuleTIMEHOLE capsule, bool readOnly) async {
  //  print("displaying new grub");
    DivElement container = new DivElement();
    output.append(container);
    container.style.display ="inline-block";
    CanvasElement buffer = await capsule.pet.draw();
    CanvasElement canvas = new CanvasElement(width:100,height:100);
    canvas.style.display="inline-block";
    canvas.context2D.drawImageScaled(buffer,0,0,100,75);
    container.append(canvas);
    String text  = "${capsule.pet.name} from ${capsule.breederName}";
    DivElement div = new DivElement()..text = text;
    div.style.width ="200px";
    div.style.overflow = "hidden";
    container.append(div);
}


class LoadingAnimation {
    CanvasElement petCanvas;
    Element textElement;
    String text;
    bool stopPlz = false;
    int index = 0;
    static LoadingAnimation instance;
    int frameRateInMillis = 100;
    LoadingAnimation(String this.text, CanvasElement this.petCanvas, Element this.textElement) {
        loop();
        instance = this;
    }

    String getCurrentText() {
        return text.substring(0,index);
    }

    void stop() {
        GameObject.instance.stopMusic();
        if(petCanvas != null)petCanvas.remove();
        textElement.remove();
        stopPlz = true;
        return;
    }

    Future<Null> loop() async{
        if(stopPlz){
            return;
        }
        await window.animationFrame;
        textElement.text = getCurrentText();
        index = (index +1)%text.length;
        new Timer(new Duration(milliseconds: frameRateInMillis), () => loop());
    }
}
