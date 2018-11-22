import '../Pets/CapsuleTIMEHOLE.dart';
import '../Pets/JSONObject.dart';
import 'dart:html';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "navbar.dart";


GameObject game;
DivElement output = querySelector("#output");
void main() {
    loadNavbar();
    game = new GameObject(true);
    start();
}

Future<Null> start() async {
    output.appendHtml(window.localStorage["TIMEHOLE"]);
}

Future<Null> TIMEHOLE() async {
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]));
    //TODO send them flipping into the TIMEHOLE
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);
    try {
        await HttpRequest.postFormData('https://plaguedoctors.herokuapp.com/time_holes/TIMEHOLE',capsule.makePostData())
            .then(finishLoadingJSON);
    }catch(error, trace) {
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system. $error");
    }
}

void finishLoadingJSON(HttpRequest request)  {
    window.alert("text is ${request.responseText}");
    request.onReadyStateChange.listen((ProgressEvent response){
        window.alert("state changed text is ${request.responseText}");
        CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(request.responseText));
        displayNewGrub(capsule);

    });
    //append to existing, don't replace
   //
}

Future<Null> displayNewGrub(CapsuleTIMEHOLE capsule) async {
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);
}
