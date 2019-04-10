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
import 'TIMEHOLEController.dart';
import "navbar.dart";
import "dart:math" as Math;

import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/src/Dolls/Doll.dart';
import 'package:DollLibCorrect/src/Dolls/KidBased/HomestuckGrubDoll.dart';
import 'package:DollLibCorrect/src/Rendering/ReferenceColors.dart';
import 'package:RenderingLib/RendereringLib.dart';


GameObject game;
DivElement output = querySelector("#output");
Future<Null> main() async{
    await Doll.loadFileData();

    loadNavbar();
    game = new GameObject(true);
    GameObject.instance.playMusic("WTWJ1"); //i wish i didn't have to wait for user input
    start();
}
Future<void> start()async {
    output.append(LoginHandler.loginStatus());
    if(LoginHandler.hasLogin()) {
        LoginInfo yourInfo = LoginHandler.fetchLogin();
        String confirmed = await  yourInfo.confirmedInfo();
        if(confirmed == "200") {
            handleShit();
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



Future<void> handleShit() async {
    LoginInfo yourInfo = LoginHandler.fetchLogin();
    String id = Uri.base.queryParameters["id"];
    if(id == null) {
        Response resp = await post("http://localhost:3000/caretakers/idFromLogin", body: yourInfo.toMiniURL());
        id = resp.body;
    }
    String caretakerJSON = await fetchCaretaker(int.parse(id));
    print("caretakerjson is $caretakerJSON");
    var scores = jsonDecode(caretakerJSON);
    window.console.table(scores);

    displayCaretaker(scores);
}

void displayCaretaker(var caretakerJSON) async {
    DivElement caretaker = new DivElement()..classes.add("caretakerBox");
    output.append(caretaker);
    DivElement name = new DivElement()..classes.add("caretakerName")..text = caretakerJSON["name"];
    DivElement desc = new DivElement()..text = caretakerJSON["desc"];


    int grubsAdopted = caretakerJSON["grubs_adopted"];
    DivElement grubsAdoptedDiv = new DivElement()..classes.add("boiPoints")..text = "Grubs Adopted: ${grubsAdopted}";

    int grubsDoanted = caretakerJSON["grubs_donated"];
    DivElement grubsDonatedDiv = new DivElement()..classes.add("boiPoints")..text = "Grubs Donated: ${grubsDoanted}";

    int gbp = caretakerJSON["good_boi_points"];
    DivElement gb = new DivElement()..classes.add("boiPoints")..text = "Good Boi Points: ${gbp}";
    int bbp = caretakerJSON["bad_boi_points"];
    DivElement bb = new DivElement()..classes.add("boiPoints")..text = "Bad Boi Points: ${bbp}";
    DivElement judgeDiv = new DivElement()..classes.add("boiPoints")..text = "Jibade Judgement: ${judgement(gbp-bbp)}";

    Doll doll = Doll.loadSpecificDoll(caretakerJSON["doll"]);
    CanvasElement dollCanvas = await doll.getNewCanvas();
    caretaker.append(dollCanvas);
    caretaker.append(name);
    caretaker.append(desc);
    caretaker.append(grubsAdoptedDiv);
    caretaker.append(grubsDonatedDiv);

    caretaker.append(gb);
    caretaker.append(bb);
    caretaker.append(judgeDiv);


}

Future<String> fetchCaretaker(int id) async {
    String url = "http://localhost:3000/caretakers/$id.json";
    try {
        String result = await HttpRequest.getString(url); //man why was i both awaiting AND doing a then? i had no clue what i was doing with the first TIMEHOLE
        GameObject.instance.stopMusic();

        return result;
    }catch(error, trace) {
        GameObject.instance.stopMusic();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}

String judgement(int points) {
    if(points > 0) {
        return goodBoi(points);
    }else {
        return badBoi(points);
    }
}

String goodBoi(int points) {
    //todo have categories of bullshit going on here.
    return "You ar3 an 3xc3113nt car3tak3r.";
}

String badBoi(int points) {
    return "On3 wou1d th1nk you'd g3t th3 h1nt by now.";

}