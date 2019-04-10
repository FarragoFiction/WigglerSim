import 'dart:convert';

import 'package:http/http.dart';

import '../GameShit/Empress.dart';
import '../Pets/CapsuleTIMEHOLE.dart';
import '../Pets/Grub.dart';
import 'package:CommonLib/Utility.dart';
import '../Pets/LoginHandler.dart';
import '../Pets/Pet.dart';
import 'dart:html';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";
import "dart:math" as Math;

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/src/Dolls/Doll.dart';
import 'package:DollLibCorrect/src/Dolls/KidBased/HomestuckGrubDoll.dart';
import 'package:DollLibCorrect/src/Rendering/ReferenceColors.dart';
import 'package:RenderingLib/RendereringLib.dart';


GameObject game;
DivElement output = querySelector("#output");
bool monster = false;
String website = "https://plaguedoctors.herokuapp.com";
//String website = "http://localhost:3000";
int numHax = 0;

bool savior = false;
Future<Null> main() async{
    await Doll.loadFileData();

    loadNavbar();
    game = new GameObject(true);
    querySelector("#npc").onClick.listen((e){

        window.location.href= "${window.location.href}?open=saysjr";
    });


    output.append(LoginHandler.loginStatus());


    if(LoginHandler.hasLogin()) {
        DivElement loading = new DivElement();
        output.append(loading);
        LoadingAnimation la = new LoadingAnimation("Loading Sweepbook",null,loading );
        LoginInfo yourInfo = LoginHandler.fetchLogin();
        String confirmed = await  yourInfo.confirmedInfo();
        la.stop();

        if(confirmed == "200") {
            start();
        }else {
            DivElement error = new DivElement()..text = "ERROR CONFIRMING YOUR LOGIN INFORMATION. '$confirmed' DID YOU TYPO ANYTHING? OR WERE YOU TRYING TO CREATE A NEW ACCOUNT AND IT WAS ALREADY TAKEN? Login was: ${yourInfo.login} and PW was ${yourInfo.password}";
            error.style.color = "red";
            error.style.border = "3px solid red";
            output.append(error);
            LoginHandler.clearLogin();
            output.append(LoginHandler.loginStatus());

        }
    };

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
        output.appendHtml( "By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE.");
        return;
    }

    if(getParameterByName("adopt",null) == "selflessly") {
        savior = true;
        if(!e.allowsAdoptingWigglersfromTIMEHOLE()) {
            output.appendHtml("By ROYAL DECREE, NO CARETAKER MAY INTERACT WITH THE TIMEHOLE TO ADOPT WIGGLERS.");
            return;
        }
        if(game.player.petInventory.hasRoom) {
            adoptPrelude();
        }else {
            output.text = "You don't have enough ENERGY to adopt more wigglers. Focus on your current brood first.";
        }
        return;
    }
    CapsuleTIMEHOLE capsule;
    try {
        capsule = new CapsuleTIMEHOLE.fromJson(
            new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]),null);
    }catch(error) {
        output.appendHtml("Haha, nope, gotta pick a wiggler first, k? No wasting online stuff, yeah?");
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
    //if there are no params and it doesn't let normal trading i guess???
    if(!e.allowTIMEHOLE() && getParameterByName("abandon",null) == null && getParameterByName("adopt",null) == null) {
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

void adoptPrelude() {
    getCost();
}

Future<Null> jrHax() async {
    String url = "$website/time_holes/abdicateTIMEHOLE";
    Pet pet = new Grub(new HomestuckGrubDoll());
    pet.name = "Hacked ${pet.doll.name}";
    pet.doll.copyPalette(new Random().pickFrom(ReferenceColours.paletteList.values));


    CapsuleTIMEHOLE haxCapsule = new CapsuleTIMEHOLE(pet,"JR's Hax");
    try {
        await HttpRequest.postFormData(url,haxCapsule.makePostData())
            .then(jrHaxNext);
    }catch(error, trace) {
        errorMessage(error,trace);
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

    String url = "$website/time_holes/TIMEHOLE";
    if(monster) {
        url = "$website/time_holes/abdicateTIMEHOLE";
    }

    /*if(true) {
        url = "http://localhost:3000/time_holes/TIMEHOLE";
    }*/

    try {
        await HttpRequest.postFormData(url,capsule.makePostData())
            .then(finishLoadingJSON);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        errorMessage(error,trace);
    }
}

Future<Null> getCost() async {

    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 1));

    String url = "$website/time_holes/timeholesize.json";
    //String url = "http://localhost:3000/time_holes/timeholesize.json";

    try {
        await HttpRequest.getString(url)
            .then(finishLoadingCount);
    }catch(error, trace) {
        errorMessage(error,trace);
    }
}

void errorMessage(error, trace) {
  output.setInnerHtml("ERROR: cannot access TIMEHOLE system. $error $trace");
  window.console.error([error, trace]);
}

Future<Null> viewTIMEHOLE() async {
    DivElement div = new DivElement();
    output.append(div);
    new LoadingAnimation("Peering into TIMEHOLE.",null,div );
    GameObject.instance.playMusic("WTWJ1");
    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 1));

    String url = "$website/time_holes.json";
    //String url = "http://localhost:3000/time_holes.json";

    try {
        await HttpRequest.getString(url)
            .then(finishLoadingJSONGetAll);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        errorMessage(error,trace);
    }
}

Future<Null> adopt() async {
    DivElement div = new DivElement();
    output.append(div);
    ButtonElement button = new ButtonElement();
    new LoadingAnimation("Looking for abandoned wigglers in need of a home...",null,div );
    GameObject.instance.playMusic("WTWJ1");
    //don't skip manics nice music thingy
    await new Future.delayed(new Duration(seconds: 3));

    String url = "$website/time_holes/adoptTIMEHOLE";

    LoginInfo yourInfo = LoginHandler.fetchLogin();


    try {
        await HttpRequest.postFormData(url,yourInfo.toURL() )
            .then(finishLoadingJSONGet);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        errorMessage(error,trace);
    }
}



void finishLoadingJSON(HttpRequest request)  {
    LoadingAnimation.instance.stop();
    print("i am finishing loading my json, request is $request");
    GameObject.instance.playMusicOnce("WTJ2");
    CapsuleTIMEHOLE originalCapsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]),null);
    if(monster) {
        GameObject.instance.removePet(originalCapsule.pet);
        output.appendHtml("You have one less wiggler to raise!!! You monster.");
    }else {

        var outerJSON = jsonDecode(
            request.responseText);
        print("id is ${outerJSON["caretaker_id"]}");

        JSONObject innerJSON = new JSONObject.fromJSONString(
            outerJSON["wigglerJSON"]);
        print("outer json is $outerJSON");

        print("inner json is $innerJSON");
        int cid = outerJSON["caretaker_id"];
        CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(innerJSON,cid);
        print("about to display new grub");
        displayNewGrub(capsule,false);
        print("adding new pet ${capsule.pet}");
        GameObject.instance.removePet(originalCapsule.pet);
        GameObject.instance.addPet(capsule.pet);
        window.localStorage.remove("TIMEHOLE");
    }
}

void finishLoadingJSONGet(HttpRequest request)  {
    LoadingAnimation.instance.stop();
    GameObject.instance.playMusicOnce("WTJ2");
    var outerJSON = jsonDecode(request.responseText);
    JSONObject innerJSON = new JSONObject.fromJSONString(outerJSON["wigglerJSON"]);
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(innerJSON, outerJSON["caretaker_id"]);
    displayNewGrub(capsule,false);
    print("adding new pet ${capsule.pet}");
    GameObject.instance.addPet(capsule.pet);
    window.localStorage.remove("TIMEHOLE");
}


void finishLoadingCount(String response)  {
   int count = int.parse(response);
   //the more wigglers there are the cheaper the cost
   int cost = 300-count*3;
   cost = Math.max(cost,13); //cost at least 13.
   if (count < 50) cost = (game.player.caegers/2).round();
   if(game.player.caegers > cost) {
       ButtonElement button = new ButtonElement()..text = "Spend $cost caegers to selflessly adopt a wiggler from the TIMEHOLE?";
       output.append(button);
       button.style.display = "block";
       output.appendHtml("(WARNING: Fee applies even should the TIMEHOLE malfunction");
       button.onClick.listen((Event e) {
           game.player.caegers += -1* cost;
           game.save();
           adopt();
           //can only adopt once per click, have to refresh.
           button.disabled = true;
           button.remove();
       });
   }else {
       output.text = "You can not afford the minimum TIMEHOLE FEE of $cost caegers.";
   }

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
    String ratingText = "How do you feel about the caretaker who sent you this grub? And remember, this is for posterity, so be honest — how do you feel?";
    String text =  "You got: ${capsule.pet.name} from ${capsule.breederName}!!! , with id ${capsule.caretakerId}";
    if(savior) text = "You selflessly adopted: ${capsule.pet.name} from ${capsule.breederName}!!! , with id ${capsule.caretakerId}";
    if(readOnly) text  = "${capsule.pet.name} from ${capsule.breederName}, with id ${capsule.caretakerId}";
    DivElement div = new DivElement()..text = text;

    DivElement div2 = new DivElement()..text = ratingText;

    DivElement ratings = new DivElement();
    ImageElement love = new ImageElement(src: "images/Emoticons/heart.png");
    ImageElement hate = new ImageElement(src: "images/Emoticons/spade.png");
    ratings.append(love);
    ratings.append(hate);
    LoginInfo yourInfo = LoginHandler.fetchLogin();

    love.onClick.listen((Event e) async{
        String url = "$website/caretakers/${capsule.caretakerId}/upvote";
        Response resp =   await post(url, body: yourInfo.toURL());
        window.console.table(resp);
        DivElement ret = new DivElement()..text = "Your overtures of friendship is registered.";
        AnchorElement view = new AnchorElement(href: "caretaker.html?id=${capsule.caretakerId}")..text = "I wonder what other people think of that caretaker???";
        ret.append(view);
        output.append(ret);
    });

    hate.onClick.listen((Event e) async {
        String url = "$website/caretakers/${capsule.caretakerId}/downvote";
        Response resp =   await post(url, body: yourInfo.toURL());
        window.console.table(resp);
        DivElement ret = new DivElement()..text = "Your displeasure is registered.";
        AnchorElement view = new AnchorElement(href: "caretaker.html?id=${capsule.caretakerId}")..text = "I wonder what other people think of that caretaker???";
        ret.append(view);
        output.append(ret);
    });

    output.append(div);
    output.append(div2);
    output.append(ratings);

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


