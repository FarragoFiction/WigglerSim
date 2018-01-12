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
 */
class Empress {
    static Empress instance;

    Troll troll;
    Empress(this.troll) {
        instance = this;
    }

    int get timeBetweenAllowence {
        return 24 * 60 * 60 * 1000; //24 hours
    }


}