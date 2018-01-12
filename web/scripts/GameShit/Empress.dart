import "../Pets/PetLib.dart";
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

    int get timeBetweenFunding {
        //TODO raise or lower this based on patience.
        int defaultAmount = 24 * 60 * 60 * 1000; //24 hours;
        return defaultAmount;
    }

    int get fundingAmount {
        //TODO raise or lower this based on external.
        int defaultAmount = 413;
        return defaultAmount;
    }

    double get oddsViolentDeath {
        //TODO raise or lower this based on idealistic.
        double defaultAmount = 0.5;
        return defaultAmount;
    }

    int get maxGrubs {
        //TODO raise or lower this based on curious. (if it's very high, +6, if very low, -4).  (2 min)
        int defaultAmount = 6;
        return defaultAmount;
    }
    //What to do for loyal and energetic? 

}


}