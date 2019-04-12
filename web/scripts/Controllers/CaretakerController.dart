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
    window.onMouseMove.listen((Event e) {
        if(!GameObject.instance.bgMusic.paused) {
            GameObject.instance.playMusic(
                "WTWJ1"); //i wish i didn't have to wait for user input
        }
    });
    start();
}
Future<void> start()async {
    output.append(LoginHandler.loginStatus());


    if(LoginHandler.hasLogin()) {
        LoginInfo yourInfo = LoginHandler.fetchLogin();
        DivElement loading = new DivElement();
        output.append(loading);
        LoadingAnimation la = new LoadingAnimation("Loading Sweepbook",null,loading );
        String confirmed = await  yourInfo.confirmedInfo();
        la.stop();

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
        Response resp = await post("https://plaguedoctors.herokuapp.com/caretakers/idFromLogin", body: yourInfo.toMiniURL());
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
    String url = "https://plaguedoctors.herokuapp.com/caretakers/$id.json";
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
    List<String> feedbacks = <String>["You shou1dn't g3t comp1ac3nt.","1 wond3r what you'r3 do1ng r1ght?","Stat1st1ca11y, you'r3 abov3 av3rag3.","1 shou1d tak3 not3s on your progr3ss.","Th1s 1s r3markab13.","You ar3 an 3xc3113nt car3tak3r."];
    int index = (points/13).floor();
    if(index < feedbacks.length) {
        return feedbacks[index];
    }else {
        return "... Wow. You ar3 an 3xc3pt1ona1 sp3c1m1n.";
    }
}

String badBoi(int points) {
    points = points.abs();
    List<String> feedbacks = <String>["Appar3nt1y your grubs hav3 b33n judg3d 1nsuff1c13nt.","1 wond3r what 1s annoy1ng th3 oth3r car3tak3rs?","You shou1d probab1y stop do1ng what3v3r 1t 1s you'r3 do1ng.","S3r1ous1y. Qu1t 1t.","On3 wou1d th1nk you'd g3t th3 h1nt by now."];
    int index = (points/13).floor();
    if(index < feedbacks.length) {
        return feedbacks[index];
    }else {
        return "... Wow. You ar3 1ucky grubs ar3 so p13nt1fu1. Oth3rw1s3 th3 oth3rcar3tak3rs m1ght conv1nc3 m3 to f1r3 you.";
    }

}