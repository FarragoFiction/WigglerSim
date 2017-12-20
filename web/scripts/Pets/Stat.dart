import 'package:DollLibCorrect/DollRenderer.dart';

class Stat {
    static int HIGH = 20;
    static int LOW = 0;
    static int MEDIUM = 10;
    static int VERYFUCKINGHIGH = 50;  //TODO figure out what's a rare but obtainable value once there's gameplay

    int value;
    String positiveName;
    String negativeName;

    //all flavor arrays will have default so doesn't sum to zero
    static StatFlavor defaultFlavor;
    static StatFlavor patienceFlavor;
    static StatFlavor energeticFlavor;
    static StatFlavor idealisticFlavor;
    static StatFlavor curiousFlavor;
    static StatFlavor loyalFlavor;
    static StatFlavor externalFlavor;
    static StatFlavor impatienceFlavor;
    static StatFlavor calmFlavor;
    static StatFlavor realisticFlavor;
    static StatFlavor acceptingFlavor;
    static StatFlavor freeFlavor;
    static StatFlavor internalFlavor;

    //flavor will keep high, low, mediumm, very high, and caste shit
    StatFlavor positiveFlavor;
    StatFlavor negativeFlavor;

    //expect the template to look like "They "resented their role as a wiggler caretaker" and "stayed under the radar".
    static void makeFlavors() {
        Random rand = new Random();

        defaultFlavor = new StatFlavor()
            ..jade = <String>["resented their role as a wiggler caregiver","cared for wigglers in the Caverns","flourished in their role as a wiggler caregiver","discovered they were a Rainbow Drinker after a tragic accident"]
            ..fuchsia = <String>["lived a life of hedonistic ${rand.pickFrom(<String>["cake baking","movie stardom","hilarious culling"])} ","reformed ${rand.pickFrom(<String>["culling policies","education","warfare"])}","helped the citizens of the empire as best they can","planned their rebellion against the Empress"]
            ..purple = <String>["learned how to be a devout member of the Dark Carnival","memorized scripture on the Mirthful Messiahs","ignored the Juggalo Church entirely", "subjuggulated the lower bloods", "excelled as a Laughsassin"]
            ..mutant = <String>["dodged culling drones","hid their blood color at all costs","were terrified and miserable"]
            ..veryHigh = <String>["revolutionized the entire field of politics","changed the way trolls view romance for generations","mastered the art of slam poetry "]
            ..high = <String>["were a Archeradicator commander","pursued interesting cases as a Legislacerator","lead a team of Doctorerrorists","published breakthrough SCIENCE as a Researchafer"]
            ..medium = <String>["learned to be a flexgrappler","playing arena stickball professionally","were a prestegious Ruffiannihilator","made a name for themselves as a Cavalreaper"]
            ..low = <String>["stayed under the radar","were unremarkable","lived a normal life"];

        //these only have the fields that would be interesting to have
        //TODO give them more than empty lists
        energeticFlavor = new StatFlavor();
        idealisticFlavor = new StatFlavor();
        curiousFlavor = new StatFlavor();
        loyalFlavor = new StatFlavor();
        externalFlavor = new StatFlavor();
        impatienceFlavor = new StatFlavor();
        calmFlavor = new StatFlavor();
        realisticFlavor = new StatFlavor();
        acceptingFlavor = new StatFlavor();
        freeFlavor = new StatFlavor();
        internalFlavor = new StatFlavor();
    }

    Stat(this.value, this.positiveName, this.negativeName, this.positiveFlavor, this.negativeFlavor) {
        if(value == null) {
            Random rand = new Random();
            value = rand.nextIntRange(-1* HIGH, HIGH); //won't go above medium normally except rarely
        }

        if(Stat.defaultFlavor == null) {
            makeFlavors();
        }
    }

    WeightedList<String> getPossibleFlavors(WeightedList<String> output, String colorWorld) {
        if(value >=0) {
            return positiveFlavor.addWeightedFlavor(output, value, colorWorld);
        }else {
            return negativeFlavor.addWeightedFlavor(output, value, colorWorld);
        }
    }



    int get normalizedValue => value.abs();

    String get stringValue {
        if(normalizedValue > VERYFUCKINGHIGH) return "Insanely High";
        if(normalizedValue > HIGH) return "High";
        if(normalizedValue > MEDIUM) return "Medium";
        if(normalizedValue >= LOW) return "Low";
        return "GLITCHED??? $normalizedValue";
    }

    @override
    String toString() {
        if(value >= 0) {
            return "$positiveName: $stringValue";
        }else {
            return "$negativeName: $stringValue";
        }
    }

}

/*
    Jumbled thoughts:

    Make some static premade vars of this for each stat type to have, one for pos, one for neg.

    when it's time to get middle, have a method that takes all stats and figures out
    which arrays to pick from.

 */
class StatFlavor {

    static double HIGHWEIGHT = 2.0;
    static double LOWWEIGHT = 0.5;
    static double MEDIUMWEIGHT = 1.0;
    static double VERYFUCKINGHIGHWEIGHT = 10.0;
    //any of these can be empty. it's okay. don't worry about it.
    List<String> high = new List<String>();
    List<String> medium = new List<String>();
    List<String> low = new List<String>();
    List<String> veryHigh = new List<String>();
    List<String> jade = new List<String>();
    List<String> fuchsia = new List<String>();
    List<String> purple = new List<String>();
    List<String> mutant = new List<String>();



    WeightedList<String> addWeightedFlavor(WeightedList<String> output, int value, String colorWord, [bool isDefault]) {
        double multiplier = 1.0;
        if(isDefault) multiplier = 0.01; //don't go for default if you have any better options
        output = processTier(output, value, Stat.LOW, low, LOWWEIGHT,multiplier);
        output = processTier(output, value, Stat.MEDIUM, medium, MEDIUMWEIGHT,multiplier);
        output = processTier(output, value, Stat.HIGH, high, HIGHWEIGHT,multiplier);
        output = processTier(output, value, Stat.VERYFUCKINGHIGH, veryHigh, VERYFUCKINGHIGHWEIGHT,multiplier);

        output =  processColor(output, colorWord, HomestuckTrollDoll.JADE, jade, multiplier);
        output = processColor(output, colorWord, HomestuckTrollDoll.PURPLE, purple, multiplier);
        output = processColor(output, colorWord, HomestuckTrollDoll.FUCHSIA, fuchsia, multiplier);
        return output;
    }

    //if you are bigger or equal to the threshold, add yourself at the right weight.
    //so if you have high skills, you might only get a low tier event, don't always live up to potential. but mostly you will.
    WeightedList<String> processTier(WeightedList<String> output, int value, int thresholdComparator, List<String> results, double weight, double multiplier) {
        if(value >= thresholdComparator) {
            for(String s in results) {
                output.add(s, weight*multiplier);
            }
        }
        return output;
    }

    //if you are the right color, add the color shit.
    WeightedList<String> processColor(WeightedList<String> output, String colorWord, String targetWord, List<String> results,double multiplier) {
        double weight = HIGHWEIGHT; //your blood color matters as much as any skills you have up to medium.
        if(colorWord == targetWord) {
            for (String s in results) {
                output.add(s, weight * multiplier);
            }
        }
        return output;
    }




}