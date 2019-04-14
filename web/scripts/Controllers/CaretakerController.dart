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


DivElement output = querySelector("#output");
String website = "https://plaguedoctors.herokuapp.com";
//String website = "http://localhost:3000";
List<String> scoringOptions = <String>["total_points","good_boi_points","bad_boi_points","grubs_donated_lazy","grubs_adopted_lazy","created_at","updated_at"];
Future<Null> main() async{
    await Doll.loadFileData();

    loadNavbar();
    drawScoreBoardLinks();
    window.onMouseMove.listen((Event e) {
        if(!GameObject.instance.bgMusic.paused) {
            GameObject.instance.playMusic(
                "WTWJ1"); //i wish i didn't have to wait for user input
        }
    });
    if(Uri.base.queryParameters["score"]=="board"){
        scoreBoard();
    }else {
        fetchSpecificCaretaker();
    }
}

void drawScoreBoardLinks() {
    DivElement links = new DivElement()..classes.add("score_board_bar");
    output.append(links);
    scoringOptions.forEach((String option) {
        DivElement link = new DivElement()..classes.add("score_board_link");
        links.append(link);
        AnchorElement a = new AnchorElement(href: "caretaker.html?score=board&sort=$option")..text = "$option";
        link.append(a);
    });
}

Future scoreBoard() async {
    String sort = Uri.base.queryParameters["sort"];
    sort ??= "total_points";
    String url = "$website/caretakers.json?sort=$sort&limit=113";
    try {
        String result = await HttpRequest.getString(url); //man why was i both awaiting AND doing a then? i had no clue what i was doing with the first TIMEHOLE
        GameObject.instance.stopMusic();
        processScoreBoard(sort, result);
    }catch(error, trace) {
        GameObject.instance.stopMusic();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}

void processScoreBoard(String sort, String result) {
    TableElement div = new TableElement();
    div.style.border = "1px solid black";
    TableRowElement header = new TableRowElement();
    Element sortBy = new Element.th()..text = "Top $sort";
    header.append(sortBy);

    Element blank = new Element.th()..text = "Rank";
    header.append(blank);

    Element value = new Element.th()..text = "Value";
    header.append(value);

    div.append(header);
    output.append(div);
    List<dynamic> what = jsonDecode(result);
    int index = 0;
    for(dynamic d in what) {
        index ++;
        try {
            scoreboardentry(sort, div,d,index);
        }catch(error, trace) {
            window.console.error(error);
            window.console.error(trace);
            print("error parsing $d,  $error");
        }
    }
}

void scoreboardentry(String sort, Element div, dynamic j, int rank) {
    TableRowElement tr = new TableRowElement()..classes.add("scoreBoard");
    TableCellElement td1 = new TableCellElement()..classes.add("scoreEntry");
    TableCellElement td2 = new TableCellElement()..classes.add("scoreEntry");
    TableCellElement td3 = new TableCellElement()..classes.add("scoreEntry");

    AnchorElement a = new AnchorElement(href: "caretaker.html?id=${j["id"]}")..text = j["name"];

    DivElement rankElement = new DivElement()..text = "$rank";
    DivElement valueElement = new DivElement()..text = "${j[sort]}";

    td1.append(a);
    td2.append(rankElement);
    td3.append(valueElement);
    tr.append(td1);
    tr.append(td2);
    tr.append(td3);
    div.append(tr);
}

Future<void> fetchSpecificCaretaker()async {
    if(Uri.base.queryParameters["id"] != null) {
        //you don't gotta be logged in to view someone else
        LoadingAnimation la = new LoadingAnimation("Loading Sweepbook",null,loading );

        await handleShit();
        la.stop();
        output.append(LoginHandler.loginStatus());

        return;
    }
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
    String id = Uri.base.queryParameters["id"];
    if(id == null) {
        LoginInfo yourInfo = LoginHandler.fetchLogin();
        Response resp = await post("$website/caretakers/idFromLogin", body: yourInfo.toMiniURL());
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


    int grubsAdopted = caretakerJSON["grubs_adopted_lazy"];
    DivElement grubsAdoptedDiv = new DivElement()..classes.add("boiPoints")..text = "Grubs Adopted: ${grubsAdopted}";

    int grubsDoanted = caretakerJSON["grubs_donated_lazy"];
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
    String url = "$website/caretakers/$id.json";
    print('trying to fetch caretaker from $url');
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