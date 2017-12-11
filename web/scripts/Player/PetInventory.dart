//just a list of pets that i have. making it more than just a list in case i need it to.
import "../Pets/PetLib.dart";
import 'package:DollLibCorrect/DollRenderer.dart';

class PetInventory {
    List<Pet> pets = new List<Pet>();

    void addRandomGrub() {
        pets.add(new Grub(new HomestuckGrubDoll()));
    }

}