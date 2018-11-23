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
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(window.localStorage["TIMEHOLE"]));
    //TODO send them flipping into the TIMEHOLE
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);

    ButtonElement button = new ButtonElement()..text = "Chuck into TIMEHOLE Y/N???";
    output.append(button);
    button.style.display = "block";
    button.style.marginLeft = "auto";
    button.style.marginRight = "auto";
    button.onClick.listen((Event e) {
        button.remove();
        TIMEHOLE(capsule,canvas);
    });
}

Future<Null> TIMEHOLE(CapsuleTIMEHOLE capsule, CanvasElement canvas) async {
    DivElement div = new DivElement();
    output.append(div);
    new LoadingAnimation("Chucking ${capsule.pet.name} into the TIMEHOLE...",canvas,div );
    GameObject.instance.playMusic("WTWJ1");
    String url = "https://plaguedoctors.herokuapp.com/time_holes/TIMEHOLE";
    if(true) {
        url = "http://localhost:3000/time_holes/TIMEHOLE";
    }

    try {
        await HttpRequest.postFormData(url,capsule.makePostData())
            .then(finishLoadingJSON);
    }catch(error, trace) {
        LoadingAnimation.instance.stop();
        output.setInnerHtml("ERROR: cannot access TIMEHOLE system.");
    }
}



void finishLoadingJSON(HttpRequest request)  {
    window.alert("text is ${request.responseText}");
    LoadingAnimation.instance.stop;
    GameObject.instance.playMusic("WTJ2");
    CapsuleTIMEHOLE capsule = new CapsuleTIMEHOLE.fromJson(new JSONObject.fromJSONString(request.responseText));
    displayNewGrub(capsule);
    print("adding new pet ${capsule.pet}");
    GameObject.instance.addPet(capsule.pet);
}

Future<Null> displayNewGrub(CapsuleTIMEHOLE capsule) async {
    print("displaying new grub");
    CanvasElement canvas = await capsule.pet.draw();
    output.append(canvas);
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
        petCanvas.remove();
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
