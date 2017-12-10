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

    void save() {
        window.localStorage[dollSaveID] = doll.toDataBytesX();
    }

    void load() {
        doll = Doll.loadSpecificDoll(window.localStorage[dollSaveID]);
    }

    //TODO probably need to spend time thining of what needs to happen here. should i cache canvas?
    Future<CanvasElement> draw() async {
        if(canvas == null) canvas = new CanvasElement(width: width, height: height);

        CanvasElement dollCanvas = new CanvasElement(width: doll.width, height: doll.height);
        await Renderer.drawDoll(dollCanvas, doll);

        dollCanvas = Renderer.cropToVisible(dollCanvas);

        Renderer.drawToFitCentered(canvas, dollCanvas);
        return canvas;
    }
}