//a player has an inventory.
// a player has a doll.
//a player has a graduatesList.
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:html';
import 'dart:async';

class Player {
    Doll doll;
    CanvasElement canvas;
    int width = 400;
    int height = 300;

    String dollSaveID = "WigglerCaretakerDoll";

    int minJadeSign = 121;
    int maxJadeSign = 144;

    Player(this.doll, [bool makeJade = true]) {
        if(makeJade && doll is HomestuckTrollDoll) {
            HomestuckTrollDoll troll = doll as HomestuckTrollDoll;
            Random rand = new Random();
            int signNumber = rand.nextInt(maxJadeSign - minJadeSign) + minJadeSign;
            troll.canonSymbol.imgNumber = signNumber;
            troll.randomize(false);
            print("canon symbol set to ${troll.canonSymbol.imgNumber} which should be jade");
        }
    }

    void displayloadBoxAndText(Element div)
    {
        Element container = new DivElement();
        String text = "Your name is UNIMPORTANT. What IS important is that you are a JADE BLOOD assigned to the BROODING CAVERNS. You are new to your duties, but are SUDDENLY CERTAIN that you will be simply the best there is at RAISING WIGGLERS.";
        Element container2 = new DivElement();
        String text2 = "<br><Br>Or is it? Maybe you are someone else? ";
        AnchorElement link = new AnchorElement();
        link.href = "http://www.farragofiction.com/DollSim/troll_index.html";
        link.text = " Anybody in mind?";
        link.style.padding = "padding:10px";

        Element container3 = new DivElement();
        TextAreaElement dollLoader = new TextAreaElement();
        dollLoader.cols = 30;
        dollLoader.rows = 9;
        dollLoader.text = doll.toDataBytesX();
        dollLoader.style.padding = "padding:10px";
        container3.append(dollLoader);
        Element container4 = new DivElement();
        ButtonElement button = new ButtonElement();
        button.text = "Load Doll";
        button.onClick.listen((Event e) {
            doll = Doll.loadSpecificDoll(dollLoader.value);
            save();
            draw();
        });

        container4.append(button);


        container.appendHtml(text);
        container2.appendHtml(text2);
        container2.append(link);
        div.append(container);
        div.append(container2);
        div.append(container3);
        div.append(container4);

    }


    //TODO convert self to json (including pet inventory) to save in this localStorage
    void save() {
        window.localStorage[dollSaveID] = doll.toDataBytesX();
    }

    bool load() {
        if(!window.localStorage.containsKey(dollSaveID)) return false;
        String s = window.localStorage[dollSaveID];
        print("loaded $s from storage");
        doll = Doll.loadSpecificDoll(s);
        return true;
    }

    //TODO probably need to spend time thining of what needs to happen here. should i cache canvas?
    Future<CanvasElement> draw() async {
        if(canvas == null) canvas = new CanvasElement(width: width, height: height);
        canvas.context2D.clearRect(0,0,width,height);
        CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
        await Renderer.drawDoll(dollCanvas, doll);

        dollCanvas = Renderer.cropToVisible(dollCanvas);

        Renderer.drawToFitCentered(canvas, dollCanvas);
        return canvas;
    }
}