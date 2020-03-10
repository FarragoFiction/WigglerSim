import 'dart:html';
import 'package:CommonLib/Compression.dart';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import '../Pets/Egg.dart';
import "../Player/Player.dart";
import "navbar.dart";


GameObject game;
void main() {
    loadNavbar();
    start();
    testWrite();
    GameObject.storeCard("N4Igzg9grgTgxgUxALhAdQJYHMsBsEwDKGAtgAQCyCALghDGCADQgB2AhiUqgOI1kBhKLnwATZiFoAPaihAAxemTgxSCMGXZZ2GVmGplqACwRkAoiQAOGGAiZkyEAO6sCCDlxhkMGuMLEAdBIARuxwANZYMNCsogBynNwgfNQ8MFDBwQiiAEIY1HBGAZasWBLUqjgEAkbsrIhyAAwBAKwSYIiuYAAqEACqrLgQEXIA2gC6ErZgwtRghNTsc2PAADpsievI6wAyAJLyZoQAgn0CZutM6wBu7LhQCFvrALQAjI3rAL6TLBXYWAQFkswDt1GACGMfpJKgCiIs5mkEEsIahRmsNlwniAcjtjoQAAoACTMFAA8gANACalxudweWIAbAAOL5Qv5VOHAswARygd0hIE+QA");
}

Future<void> testWrite() async {
    await Doll.loadFileData();
    print("hey, i'm going to test writing to json");
    Doll doll = new HomestuckGrubDoll(HomestuckTrollDoll.randomBurgundySign);
    print("hey, i made a doll");
    Egg egg = new Egg(doll);
    print ("hey i made and egg");
    print(egg.toJSON());

    print(GameObject.instance.player.toJSON());
}

void start() {
    DivElement hiddenShot = new DivElement();
    ButtonElement button = new ButtonElement();
    button.text = "Click Here if None of those Links Work";
    hiddenShot.append(button);
    querySelector('#output').append(hiddenShot);


    button.onClick.listen((e) {
        DivElement lastShot = new DivElement()
            ..setInnerHtml(
                "Okay. If the links don't work at all (likely in IE), you can manually copy this and save it to a .txt file. Here's hoping.");
        TextAreaElement saveAea = new TextAreaElement();
        saveAea.value = LZString.compressToEncodedURIComponent(
            window.localStorage[Player.DOLLSAVEID]);
        lastShot.append(saveAea);
        querySelector('#output').append(lastShot);
    });

    button = new ButtonElement();
    button.text = "destroy your save data?";
    querySelector('#output').append(button);

    button.onClick.listen((e) {
        if (window.confirm("Are you sure? You can't undo this...")) {
            window.localStorage.remove(Player.DOLLSAVEID);
            window.location.href = "index.html";
        }
    });

    try {
        if (window.localStorage.containsKey(Player.DOLLSAVEID)) {
            AnchorElement saveLink = new AnchorElement();
            saveLink.href = new UriData.fromString(
                window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain")
                .toString();
            saveLink.target = "_blank";
            saveLink.download = "recoverFileWigglerSimDefault.txt";
            saveLink.setInnerHtml(
                "<br>Download Last Minute Backup/Recover file?");
            querySelector('#output').append(saveLink);

            try {
                AnchorElement saveLink2 = new AnchorElement();
                //saveLink2.href = new UriData.fromString(window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain").toString();
                String string = window.localStorage[Player.DOLLSAVEID];
                Blob blob = new Blob(
                    [string]); //needs to take in a list o flists
                saveLink2.href = Url.createObjectUrl(blob).toString();
                saveLink2.target = "_blank";
                saveLink2.download = "recoverFileWigglerSimObjectURL.txt";
                saveLink2.setInnerHtml(
                    "<br>(Alternative data format if  First Link Doesn't Work");
                querySelector('#output').append(saveLink2);
            } catch (e) {
                DivElement error = new DivElement();
                error.style.color = "red";
                error.setInnerHtml(
                    "Error attempting to make Object URL for alternative back up url. $e");
                querySelector('#output').append(error);
            }
        }
    } catch (e) {
        DivElement error = new DivElement();
        error.style.color = "red";
        error.setInnerHtml(
            "Error attempting to make Normal URL for alternative back up url. $e");
        querySelector('#output').append(error);
    }

    //stupidly
    try {
        AnchorElement saveLink3 = new AnchorElement();
        saveLink3.href = new UriData.fromString(
            LZString.compressToEncodedURIComponent(
                window.localStorage[Player.DOLLSAVEID]), mimeType: "text/plain")
            .toString();
        saveLink3.target = "_blank";
        saveLink3.download = "recoverFileWigglerSimDefaultLZ.txt";
        saveLink3.setInnerHtml(
            "<br>Compressed Save Data (Roughly 70% smaller file)");
        querySelector('#output').append(saveLink3);
    } catch (e) {
        DivElement error = new DivElement();
        error.style.color = "red";
        error.setInnerHtml(
            "Error attempting to make Compressed URL for alternative back up url. $e");
        querySelector('#output').append(error);
    }

    try {
        AnchorElement saveLink4 = new AnchorElement();
        //saveLink2.href = new UriData.fromString(window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain").toString();
        String string = LZString.compressToEncodedURIComponent(
            window.localStorage[Player.DOLLSAVEID]);
        Blob blob = new Blob([string]); //needs to take in a list o flists
        saveLink4.href = Url.createObjectUrl(blob).toString();
        saveLink4.href = (Url.createObjectUrl(blob).toString());
        saveLink4.target = "_blank";
        saveLink4.download = "recoverFileWigglerSimObjectUrlLZ.txt";
        saveLink4.setInnerHtml(
            "<br>(Alternative data format if compressed link doesn't work.");
        querySelector('#output').append(saveLink4);
    } catch (e) {
        DivElement error = new DivElement();
        error.style.color = "red";
        error.setInnerHtml(
            "Error attempting to make Compressed Alt URL for alternative back up url. $e");
        querySelector('#output').append(error);
    }
}
