import 'dart:async';
import 'dart:html';


import 'package:CommonLib/NavBar.dart';
import 'package:CommonLib/Random.dart';
import 'package:DollLibCorrect/DollRenderer.dart';

Element output = querySelector('#output');

Future<Null> main() async {
    await loadNavbar();
    await Doll.loadFileData();

    start();
}

void start() {
    TableElement table = new TableElement()..classes.add("container");
    output.append(table);
    new FAQ(table, "What do I do with these eggs?", "Wait for them to hatch! It should take about a half hour for an egg to hatch.");

    new FAQ(table, "Why won't my egg/coccoon hatch? Its been hours!", "This is one of those 'check back every so often' idle games. You're meant to leave and come back (or at least refresh the page) to get the 'hatch'/'pupate' buttons to show up." );
    new FAQ(table, "Why is my egg/grub/cocoon saying it's laid in the FUTURE?","The timehole is a mysterious thing. If you get your grub before its been born, it kind of stays in a weird stasis till its caught up till its 'present'. Just be patient, or chuck it back into the timehole and hope it comes out somewhere in its own future.");

    new FAQ(table, "Why did Items suddenly get so expensive???", "Items stats are based on the last few Wigglers you've pupated! And their prices are based on their stats!<br><br>The good news is this means if you want to get specific kinds of items (some are only low stat items, some are only high stat), you can control that via controlling your wiggler's stats. ");

    new FAQ(table, "Why can't I use the TIMEHOLE/Change WigglerHair/Import Grubs?", "You'll need to breed an Empress who allows it.");
    new FAQ(table, "What kind of Empress allows X?", "That's the puzzle, isn't it? You can also read the <a href ='http://wigglersim.wikia.com/wiki/WigglerSim_Wiki'>Wiki</a> if you want hints.");
    new FAQ(table, "My grubs vanished!", "Chances are you had multiple tabs open, and a tab from the past just saved over something you did in the future. WigglerSim is a one tab only game, sorry 'bout that.");
    new FAQ(table, "No seriously, my grubs are gone or I'm otherwise worried my game is corrupt!", "The <a href='meteors.html'>Meteor</a> page should work no matter what, and will let you download a back up of your save. Send it to me (jadedResearcher at gmail.com, or join our <a href = 'https://discord.gg/KPunMPc'>Discord</a> server)  and I'll see what I can do.  ");
    new FAQ(table, "I have suggestions or feedback!", "Sweet! Obviously not all ideas in the ideas pile bare fruit, but you're welcome to let us know on our <a href = 'https://discord.gg/KPunMPc'>Discord</a> server. ");
    new FAQ(table, "How can I help?", "First and foremost, thanks for playing! Tell your friends, submit <a href = 'http://farragofiction.com/FridgeSim/?WigglerSim=true'>FanArt</a>!<br><br>But if you really would like to help us keep going, check out our <a href='http://www.patreon.com/FarragoFiction'>Patreon</a>, our <a href = 'https://farrago-fiction.myshopify.com/collections/wigglersim'>Merch</a> or our Definitely-Not-SBURB-Fan-Session, <a href = 'https://store.steampowered.com/app/929640/Farragnarok/'>Farragnarok</a> on Steam! It definitely is completely unrelated to WigglerSim ;)");


}

class FAQ {
    TableRowElement me;
    TableCellElement consortElement;
    TableCellElement textElement;
    String question;
    String answer;

    FAQ(TableElement table, String this.question, String this.answer, [bool secret = false]) {

        me = new TableRowElement();

        table.append(me);
        Random rand = new Random();

        consortElement = new TableCellElement()..classes.add("consortStrip");
        consortElement.style.backgroundPosition = "${rand.nextInt(100)}% 0%";
        loadGrub();
        textElement = new TableCellElement()..classes.add("faqWrapper");
        textElement.style.verticalAlign = "top";
        DivElement header = new DivElement()..text = "Q: $question"..classes.add("questionHeader");

        DivElement content = new DivElement()..setInnerHtml("A: $answer",treeSanitizer: NodeTreeSanitizer.trusted,validator: new NodeValidatorBuilder()..allowElement("a"))..classes.add("answerBody");
        textElement.append(header);
        textElement.append(content);
        textElement.colSpan = 4;

        if(rand.nextBool()) {
            me.append(consortElement);
            me.append(textElement);
        }else {
            me.append(textElement);
            me.append(consortElement);
        }


    }

    void loadGrub() async {
        HomestuckGrubDoll grub = new HomestuckGrubDoll();
        CanvasElement canvas = await grub.getNewCanvas();
        consortElement.append(canvas);
    }


}
