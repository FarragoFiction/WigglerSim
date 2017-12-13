import 'package:DollLibCorrect/DollRenderer.dart';
import '../Player/Player.dart';
import 'dart:async';
import 'dart:html';


//handles shit that my instincts want to put on a page controller.
class GameObject {
    Player player;

    static GameObject instance;

    GameObject() {
        window.onError.listen((e) {
            window.alert("Shit. There's been an error.");
        });

        instance = this;
        if(window.localStorage.containsKey(Player.DOLLSAVEID)) {
            player = new Player.fromJSON(window.localStorage[Player.DOLLSAVEID]);
            player.save();
            print("loading player ${player} from local storage");
        }else {
            player = new Player(new HomestuckTrollDoll());
            player.save();
            print("creating new player");
        }
    }

    void save() {
        print("saving game");
        //TODO if this gets too big, compress with LZString or equivalent.
        player.save();
    }

    void load() {
        player.loadFromJSON(window.localStorage[Player.DOLLSAVEID]);
    }

    Future<Null> drawPlayer(Element container) async {
        CanvasElement canvas = await player.draw();
        container.append(canvas);
    }

    void drawPetInventory(Element container) {
        player.petInventory.drawInventory(container);
    }

    void drawStarters(Element container) {
        player.petInventory.drawStarters(container);
    }

    Future<Null> drawPlayerIntroShit(Element container) async {
        player.displayloadBoxAndText(container);
    }

    void parseLoadData(String loadData) {
        //if it's not in the format I expect, error out. window.alert.
        player.loadFromJSON(loadData);
        save();
        window.location.reload();
    }

    void drawSaveLink(Element container) {
        String saveData =  player.toJson().toString();
        print("save data is: $saveData");

        DivElement fileContainer = new DivElement();
        fileContainer.text = "Restore from Save Backup?";
        fileContainer.style.paddingTop = "10px";

        InputElement fileElement = new InputElement();
        fileElement.type = "file";
        fileElement.setInnerHtml("Restore from Save Backup?");
        fileContainer.append(fileElement);
        container.append(fileContainer);

        fileElement.onChange.listen((e) {
            List<File> loadFiles = fileElement.files;
            File file = loadFiles.first;
            FileReader reader = new FileReader();
            reader.readAsText(file);
            reader.onLoadEnd.listen((e) {
                String loadData = reader.result;
                print("load data is $loadData");
                parseLoadData(loadData);
            });
        });

        AnchorElement saveLink = new AnchorElement();
        saveLink.href = new UriData.fromString(saveData, mimeType: "text/plain").toString();
        saveLink.target = "_blank";
        saveLink.download = "wigglerSimData.txt";
        saveLink.setInnerHtml("Download Save Backup?");
        container.append(saveLink);
    }

}