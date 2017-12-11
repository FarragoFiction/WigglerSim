
/*
    A wiggler is a type of pet. So is an egg, and a coccoon.
    maybe other things, in the future. consorts?

    A pet has stats (what stats? hunger at least)

    A pet has a name.

    A pet knows how to save and load itself.

    A pet has an id.

    A pet has a birthday.
    A pet has a "time last fed".
    A pet has a "time last played with".

 */
abstract class Pet {

    int health = 100;
    int boredom = 0;
    String name = "ZOOSMELL POOPLORD";
    //when make a new pet, give it an id that isn't currently in the player's inventory. just increment numbers till you find one.
    int id;



}