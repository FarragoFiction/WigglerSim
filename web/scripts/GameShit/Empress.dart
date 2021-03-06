import '../Controllers/navbar.dart';
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import "../GameShit/AIItem.dart";
import "../Player/ItemInventory.dart";
import 'dart:html';
import 'dart:async';
import 'dart:math' as Math;
import 'package:LoaderLib/Loader.dart';
import 'package:RenderingLib/src/Rendering/Renderer.dart';




/*
    Empresses control basic facts about the session.
    How much money you get per Empire Funding.
    How frequently the Empire Funding is.
    How many grubs you can raise at once.
    The price of different castes to adopt/graduate. (mutants are either zero or high. no in between)
    Odds of violent death.
    Special items.
    MAYBE eventually a "sauce" button.

    With this feature...you're kind of playing as Doc Scratch, aren't you?
 */
class Empress {
    static Empress _instance;
    int textHeight = 1000;
    int textWidth = 800;

    //if there is no empress we use the default one.
    static Empress get  instance

    {
        if(_instance == null) new Empress(null);
        return _instance;
    }

    //TROLL CAN BE NULL, IF SO DEFAULT AMOUNTS.
    Troll troll;
    Empress(this.troll) {
        _instance = this;
        ///print("Empress loaded with wigglerhood friends ${troll.hatchmatesString}");

    }





    //in seconds
    int get timeBetweenFunding {
        int defaultAmount = 6 * 60 * 60; //6 hours;
        if(troll == null) return defaultAmount;
        //if(window.location.hostname.contains("localhost")) defaultAmount = 3;
        defaultAmount += (2*60*60 * troll.patience.value/Stat.MEDIUM).round();
        defaultAmount += (60*60 * troll.energetic.value/Stat.HIGH).round();


        return Math.max(60*60, defaultAmount);
    }

    int get fundingAmount {
        //external because they are thinking of other trolls and shit
        int defaultAmount = 413;
        if(troll == null) return defaultAmount;
        defaultAmount += (100 * troll.external.value/Stat.MEDIUM).round();
        defaultAmount += (50 * troll.loyal.value/Stat.HIGH).round();

        return Math.max(1, defaultAmount);
    }


    //max of six possible normally for either end.
    //doesn't effect base heiress death rate tho. that shit's biological
    int get argumentsForViolentDeath {
        int defaultAmount = 0;
        if(troll == null) return defaultAmount;

        int ratio = (troll.idealistic.value/Stat.MEDIUM).round();
        ratio += (troll.patience.value/Stat.HIGH).round();

        if(ratio <0) {
            defaultAmount += ratio.abs();
        }
        return Math.min(6, defaultAmount);
    }

    bool isCorruptOrPure() {
        if(troll == null) return false;
        if(troll.corrupt || troll.purified) {
            return true;
        }
        return false;
    }

    String moneyImageLocation() {
        if(isCorruptOrPure()) {
            return "images/Segundian_Mark_Sm.png";
        }
        return "images/tinyMoney.png";
    }

    bool allowsSpeculation() {
        if(troll == null) return false;
        if(troll.isIdealistic || getParameterByName("cheater",null) == "jrbutitsforareallygoodpurpose") return true;
        return false;
    }

    bool allowsFundingTrees() {
        if(troll == null) return false;
        if(troll.isPatient || getParameterByName("cheater",null) == "jrbutitsforareallygoodpurpose") return true;
        return false;

    }

    bool allowsImportingMutants() {
        if(troll == null) return false;
        if(troll.isCalm || getParameterByName("cheater",null) == "jrbutitsforareallygoodpurpose" || (troll.corrupt || troll.purified)) return true;
        return false;

    }

    bool allowsRenaming() {
        if(troll == null) return false;
        if(troll.isCurious) return true;
        return false;
    }



    bool allowsGambling() {
        if(troll == null) return false;
        if(troll.isCurious) return true;
        return false;
    }

    bool allowHairDressing() {
        //wanting to have reason to have diff types of empresses
        if(troll == null) return false;
        if(troll.isCalm) return true;
        return false;
    }

    bool allowTIMEHOLE() {
        //wanting to have reason to have diff types of empresses
        if(getParameterByName("trade",null) == "wonder") return true;
        if(troll == null) return false;
        if(troll.isCurious || troll.isPatient) return true;
        return false;
    }

    bool allowsAbdicatingWigglersToTIMEHOLE() {
        //wanting to have reason to have diff types of empresses
        if(getParameterByName("trade",null) == "wonder") return true;
        if(troll == null) return false;
        if(troll.isFreeSprited) return true;
        return false;
    }

    bool allowsAdoptingWigglersfromTIMEHOLE() {
        //wanting to have reason to have diff types of empresses
        if(getParameterByName("trade",null) == "wonder") return true;
        if(troll == null) return false;
        if(troll.isLoyal) return true;
        return false;
    }

    //meenah decided how all of alternia was going to dress, so can you.
    bool allowClothesStyling() {
        //wanting to have reason to have diff types of empresses
        if(troll == null) return false;
        if(troll.isInternal) return true;
        return false;
    }



    int get argumentsAgainstViolentDeath {
        int defaultAmount = 0;
        if(troll == null) return defaultAmount;

        int ratio = (troll.idealistic.value/Stat.MEDIUM).round();
        ratio += (troll.patience.value/Stat.HIGH).round();

        if(ratio >0) {
            defaultAmount += ratio.abs();
        }
        return Math.min(6, defaultAmount);
    }

    int get maxGrubs {
        int defaultAmount = 6;
        if(troll == null) return defaultAmount;
        defaultAmount += (troll.energetic.value/Stat.MEDIUM).round();
        defaultAmount += (troll.external.value/Stat.HIGH).round();

        defaultAmount =  Math.max(2, defaultAmount);
        return Math.min(12,defaultAmount);
    }

    //how much will it cost to adopt this troll
    //or how much will you get for having raised it.
    int priceOfTroll(Pet p) {
        int base = p.totalStatsABS;
        double multiplier = 1.0;
        int divisor = 1;
        if(p.colorWord == HomestuckTrollDoll.BURGUNDY) multiplier = priceBurgundy/divisor;
        if(p.colorWord == HomestuckTrollDoll.BRONZE) multiplier = priceBronze/divisor;
        if(p.colorWord == HomestuckTrollDoll.GOLD) multiplier = priceGold/divisor;
        if(p.colorWord == HomestuckTrollDoll.LIME) multiplier = priceLime/divisor;
        if(p.colorWord == HomestuckTrollDoll.OLIVE) multiplier = priceOlive/divisor;
        if(p.colorWord == HomestuckTrollDoll.JADE) multiplier = priceJade/divisor;
        if(p.colorWord == HomestuckTrollDoll.TEAL) multiplier = priceTeal/divisor;
        if(p.colorWord == HomestuckTrollDoll.CERULEAN) multiplier = priceCerulean/divisor;
        if(p.colorWord == HomestuckTrollDoll.INDIGO) multiplier = priceIndigo/divisor;
        if(p.colorWord == HomestuckTrollDoll.PURPLE) multiplier = pricePurple/divisor;
        if(p.colorWord == HomestuckTrollDoll.VIOLET) multiplier = priceViolet/divisor;
        if(p.colorWord == HomestuckTrollDoll.FUCHSIA) multiplier = priceFuchsia/divisor;
        if(p.colorWord == HomestuckTrollDoll.MUTANT) multiplier = priceMutant/divisor;

        return  Math.min((base * multiplier/12).round(),1025);

    }

    //loyal is all caste prices. more loyal you are the more you are hemoist since you are loyal to your in group.
    int get priceBurgundy {
        int defaultAmount = 1;
        if(troll == null) return defaultAmount;

        if(troll.isLoyal) {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.BURGUNDY)).round();
        }else {
            //intent is to make it NOT enough to make up for the normal prejudice. you're trying, but you still think you're better.
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }

    int get priceBronze {
        int defaultAmount = 2;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.BRONZE)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceGold {
        int defaultAmount = 3;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.GOLD)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceLime {
        int defaultAmount = 4;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.LIME)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceOlive {
        int defaultAmount = 5;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.OLIVE)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceJade {
        int defaultAmount = 6;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.JADE)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceTeal {
        int defaultAmount = 7;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.TEAL)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }

    int get priceCerulean {
        int defaultAmount = 8;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.CERULEAN)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceIndigo {
        int defaultAmount = 9;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.INDIGO)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get pricePurple {
        int defaultAmount = 10;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.PURPLE)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceViolet {

        int defaultAmount = 11;
        if(troll == null) return defaultAmount;

        if(!troll.isLoyal) {
            defaultAmount += (12/defaultAmount * troll.loyal.value/Stat.MEDIUM).round();
        }else {
            defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.VIOLET)).round();
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }
        return Math.max(1, defaultAmount);
    }
    int get priceFuchsia {
        int defaultAmount = 24; //never changes. she doesn't want an heiress.
        if(troll == null) return defaultAmount;

        if(troll.isLoyal) {
            defaultAmount += (defaultAmount/6 * troll.loyal.value/Stat.MEDIUM).round();
        }

        if(troll.isRealistic) defaultAmount += -100; //realistically, you can't let there be other heiresses.
        return Math.max(-1,defaultAmount);
    }
    int get priceMutant {
        int defaultAmount = 0;

        if(troll == null) return defaultAmount;
        //for mutants, if you grew up with them you'll at  least value them a bit,whether loyal or not
        defaultAmount += (10 * troll.percentHatchMatesWithCaste(HomestuckTrollDoll.MUTANT)).round();
        print("after memory, default amount is $defaultAmount");
        if(!troll.isLoyal) {
            defaultAmount += (24 * troll.loyal.value/Stat.MEDIUM).round();
        }else {
        }

        return Math.max(0, defaultAmount);
    }

    //what about curious? items available.
    List<AIItem> get items {
        //at max curiosity, ALL items.
        List<AIItem> defaultItems = new List<AIItem>();
        if(troll == null) return defaultItems;

        //space is associated with creation, too
        if(troll.isPatient) {
            defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Goldblood Doll", "GoldbloodDoll.png")],loyal_value: troll.loyal.value, energetic_value: -1*troll.energetic.value.abs()));
            defaultItems.add(new AIItem(413, <ItemAppearance>[new ItemAppearance("${troll.name}'s Jadeblood Doll", "JadebloodDoll.png")],patience_value: troll.patience.value, energetic_value: -1*troll.energetic.value.abs()));

        }
        if(troll.isCurious) {
            defaultItems.add(new AIItem(114, <ItemAppearance>[new ItemAppearance("${troll.name}'s Glow Bug", "flyfulamber.png")], energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs()), loyal_value: troll.loyal.value, curious_value: troll.curious.value.abs()));
            defaultItems.add(new AIItem(118, <ItemAppearance>[new ItemAppearance("${troll.name}'s Honorable Tyranny Blood", "better_than_bleach.png")],curious_value: troll.curious.value, external_value: troll.external.value.abs(),loyal_value: troll.loyal.value.abs()));

            if(troll.curious.value > Stat.VERYFUCKINGHIGH) {
                defaultItems.add(new AIItem(121, <ItemAppearance>[new ItemAppearance("${troll.name}'s Cosbytop", "Cosbytop.png")], curious_value: troll.curious.value,external_value: troll.external.value.abs()));
                defaultItems.add(new AIItem(120, <ItemAppearance>[new ItemAppearance("${troll.name}'s SCIENCE 3-DENT", "wiredent.png")],curious_value: troll.curious.value, idealistic_value: ItemInventory.makeNegative(troll.idealistic.value.abs())));
                defaultItems.add(new AIItem(113, <ItemAppearance>[new ItemAppearance("${troll.name}'s Alien Specimen", "MisterTFetus.png")],curious_value: troll.curious.value, idealistic_value: ItemInventory.makeNegative(troll.idealistic.value.abs())));
            }
            if(troll.curious.value > Stat.HIGH) {
                defaultItems.add(new AIItem(115, <ItemAppearance>[new ItemAppearance("${troll.name}'s PCHOOOES", "pchoooes.png")], curious_value: troll.curious.value, patience_value:ItemInventory.makeNegative(troll.patience.value.abs()), energetic_value: troll.energetic.value.abs()));
                defaultItems.add(new AIItem(119, <ItemAppearance>[new ItemAppearance("${troll.name}'s Husktop", "skaiatop.png")],curious_value: troll.curious.value, external_value: ItemInventory.makeNegative(troll.external.value.abs())));

            }
            if(troll.curious.value > Stat.MEDIUM) {
                defaultItems.add(new AIItem(116, <ItemAppearance>[new ItemAppearance("${troll.name}'s Picture Box", "jpgcamera.png")],curious_value: troll.curious.value, patience_value: troll.patience.value, external_value: troll.external.value.abs()));
                defaultItems.add(new AIItem(117, <ItemAppearance>[new ItemAppearance("${troll.name}'s Zap Cube", "skaianbattery.png")],curious_value: troll.curious.value, energetic_value: ItemInventory.makeNegative(troll.energetic.value.abs())));
            }
        }

        return defaultItems;

    }

    Future<Null> drawDecrees(Element container) async {
        //picture.
        //decrees
        CanvasElement canvas = new CanvasElement(width: textWidth, height: textHeight);

        CanvasElement textCanvas = await drawStats();
        canvas.context2D.drawImage(textCanvas,0,0);

        //this is the thing we'll hang on. so do it last.
        if(troll != null) {
            CanvasElement grubCanvas = await troll.draw();
            canvas.context2D.drawImage(grubCanvas, 10, 10);
        }else {
            ImageElement placeHolder = await Loader.getResource("images/nameless_empress_CROP.png");
            canvas.context2D.drawImage(placeHolder,10,10);
        }
        container.append(canvas);

    }



    Future<CanvasElement> drawStats() async {
        //never cache
        CanvasElement textCanvas = new CanvasElement(width: textWidth, height: textHeight);
        textCanvas.context2D.fillStyle = "#d27cc9";
        textCanvas.context2D.strokeStyle = "#2c002a";
        if(troll != null && troll.corrupt) {
            textCanvas.context2D.strokeStyle = "#00ff00";
            textCanvas.context2D.fillStyle = "#d27cc9";
        }
        if(troll != null && troll.purified) {
            textCanvas.context2D.strokeStyle = "#8ccad6";
            textCanvas.context2D.fillStyle = "#d27cc9";
        }

        textCanvas.context2D.lineWidth = 3;


        textCanvas.context2D.fillRect(0, 0, textWidth, textHeight);
        textCanvas.context2D.strokeRect(0, 0, textWidth, textHeight);

        textCanvas.context2D.fillStyle = "#2c1900";
        if(troll != null && troll.corrupt) {
            textCanvas.context2D.fillStyle = "#00ff00";
        }

        if(troll != null && troll.purified) {
            textCanvas.context2D.fillStyle = "#8ccad6";
        }

        int fontSize = 20;
        textCanvas.context2D.font = "${fontSize}px Strife";
        int y = 330;
        int x = 10;
        String name = "Nameless Empress";
        if(troll != null) name = troll.name;
        Renderer.wrap_text(textCanvas.context2D, name, x, y, fontSize, 400, "center");

        y = y + fontSize * 2;
        fontSize = 12;

        int buffer = 10;

        if(troll != null) {
            for (Stat s in troll.stats) {
                y = y + fontSize + buffer;
                Renderer.wrap_text(textCanvas.context2D, "${s.toString()}", x, y, fontSize + buffer, 275, "left");
            }
        }

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "", x, y, fontSize + buffer, 275, "left");


        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Time To Fund: ${new Duration(seconds: timeBetweenFunding)}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Fund Amount: ${fundingAmount}", x, y, fontSize + buffer, 275, "left");


        if(argumentsForViolentDeath >0) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Violent Death Bonus: ${argumentsForViolentDeath}", x, y, fontSize + buffer, 275, "left");
        }else {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Peaceful Death Odds: ${argumentsAgainstViolentDeath}", x, y, fontSize + buffer, 275, "left");
        }
        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Max Grubs: ${maxGrubs}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Number Bonus Items: ${items.length}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Burgundy Multiplier: ${priceBurgundy}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Bronze Multiplier: ${priceBronze}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Gold Multiplier: ${priceGold}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Lime Multiplier: ${priceLime}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Olive Multiplier: ${priceOlive}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Jade Multiplier: ${priceJade}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Teal Multiplier: ${priceTeal}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Cerulean Multiplier: ${priceCerulean}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Indigo Multiplier: ${priceIndigo}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Purple Multiplier: ${pricePurple}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Violet Multiplier: ${priceViolet}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Fuchsia Multiplier: ${priceFuchsia}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Mutant Multiplier: ${priceMutant}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        String hs = "";
        if(troll != null) hs = troll.hatchmatesString;
        Renderer.wrap_text(textCanvas.context2D, "Hatchmates: ${hs}", x, y, fontSize + buffer, 275, "left");

        //allows
        y = 365;
        x = 400;

        if(allowsGambling()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Gambling", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsRenaming()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Renaming", x, y, fontSize + buffer, 275, "left");
        }

        if(allowTIMEHOLE()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows TIMEHOLE Trading", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsAbdicatingWigglersToTIMEHOLE()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows TIMEHOLE Abdicating", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsAdoptingWigglersfromTIMEHOLE()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows TIMEHOLE Adopting", x, y, fontSize + buffer, 275, "left");
        }

        if(allowClothesStyling()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Clothes Styling", x, y, fontSize + buffer, 275, "left");
        }

        if(allowHairDressing()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Hair Styling", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsFundingTrees()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Tree Funding", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsImportingMutants()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Severe Mutants", x, y, fontSize + buffer, 275, "left");
        }

        if(allowsSpeculation()) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Allows Speculating", x, y, fontSize + buffer, 275, "left");
        }


        if(items.isNotEmpty) {
            y = y + fontSize + buffer;
            Renderer.wrap_text(textCanvas.context2D, "Invents Things", x, y, fontSize + buffer, 275, "left");
        }

        if(troll != null) {
            y = y + fontSize*3 + buffer;
            Renderer.wrap_text(textCanvas.context2D, "${troll.epilogue}", x, y, fontSize + buffer, 275, "left");
        }

        return textCanvas;
    }


}


