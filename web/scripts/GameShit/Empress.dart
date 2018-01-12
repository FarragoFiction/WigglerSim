import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';
import "../GameShit/AIItem.dart";

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
        int defaultAmount = 24 * 60 * 60; //24 hours;
        return defaultAmount;
    }

    int get fundingAmount {
        //TODO raise or lower this based on external. don't let it go below 1.
        //external because they are thinking of other trolls and shit
        int defaultAmount = 413;
        return defaultAmount;
    }

    //TODO: for display
    double get violentDeathRatio {
        return argumentsForViolentDeath/argumentsAgainstViolentDeath;
    }

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

}


