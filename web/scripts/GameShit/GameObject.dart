import 'dart:convert';
import 'package:CommonLib/Compression.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import '../Player/Player.dart';
import 'dart:async';
import 'dart:html';
import "../Pets/PetLib.dart";
import "PlayPen.dart";
import "MoneyHandler.dart";
import 'package:LoaderLib/Loader.dart';

//handles shit that my instincts want to put on a page controller.
class GameObject {
    Player player;
    //will be null everywhere but the playpen screen.
    PlayPen playPen;

    static GameObject _instance;
    static GameObject get instance {
        if(_instance == null) {
            _instance = new GameObject(false);
        }
        return _instance;
    }
    Element infoElement;
    AudioElement bgMusic = new AudioElement()..autoplay = false;

    int chosenBGIndex = 0;
    String get chosenBG => "images/Backgrounds/${indexToBG(chosenBGIndex)}";
    String indexToBG(int index) => "${potentialBGs[index]}";


    List<String> potentialBGs = <String>["BroodingCaverns.png","BirdBG.png","HalloweenPlaypen.png","GhostPlaypen.png","BeachPen.png","BronzePlaypen.png","GoldPlaypen.png","LimeBackground.png"];

    List<int> get unlockedBGIndices {
        List<int> ret = <int>[0,1,2];
        List<String> completedCastes = Sign.completedCastes;
        if(completedCastes.contains(HomestuckTrollDoll.BURGUNDY)) ret.add(3);
        if(completedCastes.contains(HomestuckTrollDoll.VIOLET)) ret.add(4);
        if(completedCastes.contains(HomestuckTrollDoll.BRONZE)) ret.add(5);
        if(completedCastes.contains(HomestuckTrollDoll.GOLD)) ret.add(6);
        if(completedCastes.contains(HomestuckTrollDoll.LIME)) ret.add(7);

        return ret;
    }

    GameObject(bool redirect) {
        window.onError.listen((e) {
            DivElement linkContainer = new DivElement();
            linkContainer.style.padding = "10px";
            AnchorElement saveLink = new AnchorElement();
            String saveData = "";
            if(window.localStorage.containsKey(Player.DOLLSAVEID)) saveData =  window.localStorage[Player.DOLLSAVEID];
            saveLink.href = new UriData.fromString(saveData, mimeType: "text/plain").toString();
            saveLink.target = "_blank";
            saveLink.download = "recoverFileWigglerSim.txt";
            saveLink.setInnerHtml("Download Recovery File to Send to JR? (jadedresearcher on tumblr, gmail, and discord)");
            linkContainer.append(saveLink);
            querySelector("#output").append(linkContainer);

            InputElement fileElement = new InputElement();
            fileElement.type = "file";
            fileElement.setInnerHtml("Restore from JR's File?");
            querySelector("#output").appendHtml("Upload Save Backup after JR fixes it here:");
            querySelector("#output").append(fileElement);


            fileElement.onChange.listen((e) {
                List<File> loadFiles = fileElement.files;
                File file = loadFiles.first;
                FileReader reader = new FileReader();
                reader.readAsText(file);
                reader.onLoadEnd.listen((e) {
                    String loadData = reader.result;
                    window.localStorage[Player.DOLLSAVEID] = loadData;
                    window.location.href= "index.html";
                });
            });

            window.alert("Shit. There's been an error. $e");
        });

        infoElement = new DivElement();
        _instance = this;
        if(window.localStorage.containsKey(Player.DOLLSAVEID)) {
            //window.localStorage.remove(Player.DOLLSAVEID);
            print("local storage has ${window.localStorage[Player.DOLLSAVEID]}");
            player = new Player.fromJSON(jsonDecode(window.localStorage[Player.DOLLSAVEID]));
            player.save(); //Currently panic debugging jr on 4/11/19 says: wtf why was i ever saving here?
            print("loading player ${player} from local storage, their inventory is ${player.itemInventory.numItems}");
        }else {
            player = new Player(new HomestuckTrollDoll());
            player.save();
            print("creating new player");
        }
        new MoneyHandler(querySelector("#output"));
        querySelector("#output").append(infoElement);

        if(redirect && player.petInventory.pets.isEmpty && player.petInventory.alumni.isEmpty) {
            window.location.href= "petInventory.html";
        }
    }
    void playMusic(String locationWithoutExtension) {
        print("starting music $locationWithoutExtension");
        try {
            bgMusic.loop = true;
            if (bgMusic
                .canPlayType("audio/mpeg")
                .isNotEmpty)
                bgMusic.src = "music/${locationWithoutExtension}.mp3";
            if (bgMusic
                .canPlayType("audio/ogg")
                .isNotEmpty)
                bgMusic.src = "music/${locationWithoutExtension}.ogg";
            bgMusic.play().catchError((Error error) {
                window.console.error("error playing $locationWithoutExtension but ignoring");
            });
        }catch(e) {
            window.console.error("error playing $locationWithoutExtension but ignoring $e");
        }
    }

    void playMusicOnce(String locationWithoutExtension)  {
        print("starting music $locationWithoutExtension");
        try {
            bgMusic.loop = false;
            if (bgMusic
                .canPlayType("audio/mpeg")
                .isNotEmpty)
                bgMusic.src = "music/${locationWithoutExtension}.mp3";
            if (bgMusic
                .canPlayType("audio/ogg")
                .isNotEmpty)
                bgMusic.src = "music/${locationWithoutExtension}.ogg";
            bgMusic.play().catchError((Error error) {
                window.console.error("error playing $locationWithoutExtension but ignoring ");
            });
        }catch(e) {
            window.console.error("error playing $locationWithoutExtension but ignoring $e");
        }
    }

    void stopMusic() {
        print("stopping music");
        bgMusic.pause();
    }


    void reset() {
        player = new Player(new HomestuckTrollDoll());
        player.save();
        window.location.href= "index.html";
    }

    List<Troll> get last12Alumni {

        return player.petInventory.last12Alumni;

    }

    Future<Null> preloadManifest() async {
        // pl changed this await Loader.loadManifest();
        print ("loader returned");
        return;
    }

    void save() {
        //print("saving game, inventory is ${player.itemInventory.numItems}");
        //TODO if this gets too big, compress with LZString or equivalent.
        player.save();
    }

    void removePet(Pet pet) {
        print("trying to remove pet ${pet.name}");
        player.removePet(pet);
        save();
    }

    void addPet(Pet pet) {
        player.addPet(pet);
        save();
    }

    void load() {
        player.loadFromJSON(jsonDecode(window.localStorage[Player.DOLLSAVEID]));
        print("loading game, inventory is ${player.itemInventory.numItems}");

    }

    static void storeCard(String card) {
        String key = "LIFESIMFOUNDCARDS";
        if(window.localStorage.containsKey(key)) {
            String existing = window.localStorage[key];
            List<String> parts = existing.split(",");
            if(!parts.contains(card)) window.localStorage[key] = "$existing,$card";
        }else {
            window.localStorage[key] = card;
        }
    }


    Future<Null> drawPlayer(Element container) async {
        CanvasElement canvas = await player.draw();
        container.append(canvas);
    }

    void drawAGraduatingTroll(Element container) {
        Troll t = player.petInventory.getGraduatingTroll();
        if(t != null) {
            print("graduating ${t.name} with doll of ${t.doll.toDataBytesX()}");
            player.petInventory.drawPet(container, t);
            player.petInventory.graduate(t);
            //ppl occasionally have glitches where it fails to graduate
            //and they dont' relize you can refresh the page here.
            //so do all.
            if(player.petInventory.getGraduatingTroll() != null) {
                drawAGraduatingTroll(container);
            }else {
                save();
            }

        }else {
            container.setInnerHtml("No Trolls Found!");
        }
    }

    void drawPetInventory(Element container) {
        player.petInventory.drawInventory(container);
    }

    void drawAlumni(Element container) {
        player.petInventory.drawAlumni(container);
    }

    void makeOverAlumni() {
        player.petInventory.makeOverAlumni();
    }

    void drawSigns(Element container) {
        player.petInventory.drawSigns(container);
    }

    void drawShop(Element container) {
        player.itemInventory.drawShop(container);
    }

    void drawItemInventory(Element container) {
        player.itemInventory.drawInventory(container);
    }

    void drawAdoptables(Element container) {
        player.petInventory.drawAdoptables(container);
    }

    void drawStarters(Element container) {
        player.petInventory.drawStarters(container);
    }

    Future<Null> drawPlayerIntroShit(Element container) async {
        player.displayloadBoxAndText(container);
    }

    void parseLoadData(String loadData) {
        //if it's not in the format I expect, error out. window.alert.
        try {
            print("trying to load from json");
            player.loadFromJSON(jsonDecode(loadData));
        }catch(e,trace) {
            print("something went wrong with json, so trying to load from lzstring, $e, $trace");
            player.loadFromJSON(jsonDecode(LZString.decompressFromEncodedURIComponent(loadData)));
        }
        save();
        window.location.reload();
    }

    void drawSaveLink(Element container) {
        //print("save data is: $saveData");
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
        writeSaveBackup(container);


    }

    void writeSaveBackup(Element container) {
        String saveData =  player.toJSON().toString();
        DivElement linkContainer = new DivElement();
        linkContainer.style.padding = "10px";
        AnchorElement saveLink = new AnchorElement();
        saveLink.href = new UriData.fromString(saveData, mimeType: "text/plain", encoding: new Utf8Codec()).toString();
        saveLink.target = "_blank";
        saveLink.download = "wigglerSimData.txt";
        saveLink.setInnerHtml("Download Save Backup?");
        DivElement suggestion = new DivElement();
        suggestion.setInnerHtml( "(If anything goes wrong with save data try the <a href = 'meteors.html'>Meteor</a> page to get raw save data.");
        linkContainer.append(saveLink);
        linkContainer.append(suggestion);

        container.append(linkContainer);
    }

}