import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import "../GameShit/AIItem.dart";
import 'dart:html';
import 'dart:async';



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

    TODO: page summarizing effect current empress has on sim
 */
class Empress {
    static Empress _instance;
    int textHeight = 800;
    int textWidth = 420;

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
    }

    //in seconds
    int get timeBetweenFunding {
        //TODO raise or lower this based on patience.
        int defaultAmount = 12 * 60 * 60; //12 hours;
        //if(window.location.hostname.contains("localhost")) defaultAmount = 3;

        return defaultAmount;
    }

    int get fundingAmount {
        //TODO raise or lower this based on external. don't let it go below 1.
        //external because they are thinking of other trolls and shit
        int defaultAmount = 413;
        return defaultAmount;
    }


    //max of six possible normally for either end.
    //doesn't effect base heiress death rate tho. that shit's biological
    int get argumentsForViolentDeath {
        //TODO raise or lower this based on idealistic.
        int defaultAmount = 0;
        return defaultAmount;
    }

    int get argumentsAgainstViolentDeath {
        //TODO raise or lower this based on idealistic.
        int defaultAmount = 0;
        return defaultAmount;
    }

    int get maxGrubs {
        //TODO raise or lower this based on energetic. (if it's very high, +6, if very low, -4).  (2 min)
        int defaultAmount = 6;
        return defaultAmount;
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

        return  (base * multiplier/12).round();;

    }

    //loyal is all caste prices. more loyal you are the more you are hemoist since you are loyal to your in group.
    int get priceBurgundy {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 1;
        return defaultAmount;
    }

    int get priceBronze {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 2;
        return defaultAmount;
    }
    int get priceGold {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 3;
        return defaultAmount;
    }
    int get priceLime {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 4;
        return defaultAmount;
    }
    int get priceOlive {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 5;
        return defaultAmount;
    }
    int get priceJade {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 6;
        return defaultAmount;
    }
    int get priceTeal {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 7;
        return defaultAmount;
    }
    int get priceCerulean {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 8;
        return defaultAmount;
    }
    int get priceIndigo {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 9;
        return defaultAmount;
    }
    int get pricePurple {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 10;
        return defaultAmount;
    }
    int get priceViolet {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 11;
        return defaultAmount;
    }
    int get priceFuchsia {
        //TODO raise or lower this based on loyal.
        int defaultAmount = 24;
        return defaultAmount;
    }
    int get priceMutant {
        //TODO raise or lower this based on loyal. either worth the most or the least
        int defaultAmount = 0;
        return defaultAmount;
    }

    //what about curious? items available.
    List<AIItem> get items {
        //TODO: at lowest curiosity (highest acceptance) no items.
        //at max curiosity, ALL items.
        //what items are possible are based on empress stats though
        List<AIItem> defaultItems = new List<AIItem>();
        return defaultItems;

    }

    Future<Null> drawDecrees(Element container) async {
        //picture.
        //decrees
        CanvasElement canvas = new CanvasElement(width: textWidth, height: textHeight);

        CanvasElement textCanvas = await drawStats();
        canvas.context2D.drawImage(textCanvas,0,0);

        //this is the thing we'll hang on. so do it last.
        CanvasElement grubCanvas = await troll.draw();
        canvas.context2D.drawImage(grubCanvas,10,10);
        container.append(canvas);
    }

    Future<CanvasElement> drawStats() async {
        //never cache
        CanvasElement textCanvas = new CanvasElement(width: textWidth, height: textHeight);
        textCanvas.context2D.fillStyle = "#d27cc9";
        textCanvas.context2D.strokeStyle = "#2c002a";

        textCanvas.context2D.lineWidth = 3;


        textCanvas.context2D.fillRect(0, 0, textWidth, textHeight);
        textCanvas.context2D.strokeRect(0, 0, textWidth, textHeight);

        textCanvas.context2D.fillStyle = "#2c1900";

        int fontSize = 20;
        textCanvas.context2D.font = "${fontSize}px Strife";
        int y = 330;
        int x = 10;
        Renderer.wrap_text(textCanvas.context2D, troll.name, x, y, fontSize, 400, "center");

        y = y + fontSize * 2;
        fontSize = 12;

        int buffer = 10;
        /*

        timeBetweenFunding
        fundingAmount
        violentDeathRatio
        maxGrubs
        priceBurgundy
        numItems
         */

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Time To Fund: ${new Duration(seconds: timeBetweenFunding)}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Fund Amount: ${fundingAmount}", x, y, fontSize + buffer, 275, "left");

        y = y + fontSize + buffer;
        Renderer.wrap_text(textCanvas.context2D, "Violent Death Ratio: ${argumentsForViolentDeath}/${argumentsAgainstViolentDeath}", x, y, fontSize + buffer, 275, "left");

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
        Renderer.wrap_text(textCanvas.context2D, "Mutant Value: ${priceMutant}", x, y, fontSize + buffer, 275, "left");

        return textCanvas;
    }


}


