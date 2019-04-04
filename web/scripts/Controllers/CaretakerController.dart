import 'dart:convert';

import '../GameShit/Empress.dart';
import '../Pets/CapsuleTIMEHOLE.dart';
import '../Pets/Grub.dart';
import 'package:CommonLib/Utility.dart';
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
    /*TODO:
        use your login and password to get an id back, then fetch your caretaker from that
        take a id from the query param and fetch that one too
        actually display the caretaker right
     */
    test();

}

Future<void> test() async {
    String caretakerJSON = await fetchCaretaker(2);
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

    int gbp = caretakerJSON["good_boi_points"];
    DivElement gb = new DivElement()..classes.add("boiPoints")..text = "Good Boi Points: ${gbp}";
    int bbp = caretakerJSON["bad_boi_points"];
    DivElement bb = new DivElement()..classes.add("boiPoints")..text = "Bad Boi Points: ${bbp}";
    DivElement judgeDiv = new DivElement()..classes.add("boiPoints")..text = "Judgement ${judgement(gbp-bbp)}";

    Doll doll = Doll.loadSpecificDoll(caretakerJSON["doll"]);
    CanvasElement dollCanvas = await doll.getNewCanvas();
    caretaker.append(dollCanvas);
    caretaker.append(name);
    caretaker.append(desc);
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