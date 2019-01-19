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

    static GameObject instance;
    Element infoElement;
    AudioElement bgMusic = new AudioElement();


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
        instance = this;
        if(window.localStorage.containsKey(Player.DOLLSAVEID)) {
            //window.localStorage.remove(Player.DOLLSAVEID);
            player = new Player.fromJSON(window.localStorage[Player.DOLLSAVEID]);
            player.save();
            print("loading player ${player} from local storage");
        }else {
            player = new Player(new HomestuckTrollDoll());
            player.save();
            print("creating new player");
        }
        new MoneyHandler(querySelector("#output"));
        querySelector("#output").append(infoElement);

        if(player.name != player.doll.dollName) {
            window.location.href= "converstion.html";
        }else if(redirect && player.petInventory.pets.isEmpty && player.petInventory.alumni.isEmpty) {
            window.location.href= "petInventory.html";
        }
    }
    void playMusic(String locationWithoutExtension) {
        print("starting music $locationWithoutExtension");
        bgMusic.loop  = true;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "music/${locationWithoutExtension}.ogg";
        bgMusic.play();
    }

    void playMusicOnce(String locationWithoutExtension) {
        print("starting music $locationWithoutExtension");
        bgMusic.loop  = false;
        if(bgMusic.canPlayType("audio/mpeg").isNotEmpty) bgMusic.src = "music/${locationWithoutExtension}.mp3";
        if(bgMusic.canPlayType("audio/ogg").isNotEmpty) bgMusic.src = "music/${locationWithoutExtension}.ogg";
        bgMusic.play();
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
        await Loader.loadManifest();
        print ("loader returned");
        return;
    }

    void save() {
        print("saving game");
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
        player.loadFromJSON(window.localStorage[Player.DOLLSAVEID]);
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
            player.loadFromJSON(loadData);
        }catch(e,trace) {
            print("something went wrong with json, so trying to load from lzstring, $e, $trace");
            player.loadFromJSON(LZString.decompressFromEncodedURIComponent(loadData));
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
        String saveData =  player.toJson().toString();
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