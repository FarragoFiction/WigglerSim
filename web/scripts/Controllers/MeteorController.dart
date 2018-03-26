import 'dart:html';
import 'package:DollLibCorrect/DollRenderer.dart';
import 'dart:async';
import '../GameShit/GameObject.dart';
import "../Player/Player.dart";
import "navbar.dart";

GameObject game;
void main() {
    loadNavbar();
    start();
}

void start() {
    ButtonElement button =  new ButtonElement();
    button.text = "destroy your save data?";
    querySelector('#output').append(button);

    button.onClick.listen((e) {
        if(window.confirm("Are you sure? You can't undo this...")) {
            window.localStorage.remove(Player.DOLLSAVEID);
            window.location.href = "index.html";
        }
    });

    if(window.localStorage.containsKey(Player.DOLLSAVEID)) {
        AnchorElement saveLink = new AnchorElement();
        saveLink.href = new UriData.fromString(window.localStorage[Player.DOLLSAVEID], mimeType: "text/plain").toString();
        saveLink.target = "_blank";
        saveLink.download = "recoverFileWigglerSim.txt";
        saveLink.setInnerHtml("Download Last Minute Backup/Recover file?");
        querySelector('#output').append(saveLink);
    }


}