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

    //flavor will keep high, low, mediumm, very high, and caste shit and causes of death
    StatFlavor positiveFlavor;
    StatFlavor negativeFlavor;



    //expect the template to look like "They "resented their role as a wiggler caretaker" and "stayed under the radar".
    static void makeFlavors() {
        Random rand = new Random();
        //if a stat is VERY high, easter egg where it claims they played sburb?
        defaultFlavor = new StatFlavor(0)
            ..death = <String>["of a mysterious illness","suddenly and with no warning"]
            ..jade = <String>["resented their role as a wiggler caregiver","cared for wigglers in the Caverns","flourished in their role as a wiggler caregiver","discovered they were a Rainbow Drinker after a tragic accident"]
            ..fuchsia = <String>["lived a life of hedonistic ${rand.pickFrom(<String>["cake baking","movie stardom","hilarious culling"])} ","reformed ${rand.pickFrom(<String>["culling policies","education","warfare"])}","helped the citizens of the empire as best they could","planned their rebellion against the Empress"]
            ..purple = <String>["learned how to be a devout member of the Dark Carnival","memorized scripture on the Mirthful Messiahs","ignored the Juggalo Church entirely", "subjuggulated the lower bloods", "excelled as a Laughsassin"]
            ..mutant = <String>["dodged culling drones","hid their blood color at all costs","were terrified and miserable"]
            ..veryHigh = <String>["revolutionized the entire field of politics","changed the way trolls view romance for generations","mastered the art of slam poetry "]
            ..high = <String>["were a Archeradicator commander","pursued interesting cases as a Legislacerator","lead a team of Doctorerrorists","published breakthrough SCIENCE as a Researchafer"]
            ..medium = <String>["learned to be a flexgrappler","played arena stickball professionally","were a prestegious Ruffiannihilator","made a name for themselves as a Cavalreaper"]
            ..low = <String>["stayed under the radar","were unremarkable","lived a normal life"];

        //these only have the fields that would be interesting to have
        patienceFlavor = new StatFlavor(-3)
            ..medium = <String>["gained a reputation for slow and steady excellence"];
        energeticFlavor = new StatFlavor(0)
            ..medium = <String>["brought a vibrant energy to everything they did"];
        idealisticFlavor = new StatFlavor(1)
            ..death  = <String>["fighting for what they believed in","trying to change the world","trying to change the empire"]
             ..medium = <String>["inspired the trolls around them with their ideals"];
        curiousFlavor = new StatFlavor(1)
            ..death  = <String>["asking the wrong questions","probing into things better left alone","exposing the wrong Highblood's secrets"]
            ..medium = <String>["never stopped asking questions"];
        loyalFlavor = new StatFlavor(1)
            ..death  = <String>["fighting the Empire's enemies","protecting their friends","putting down rebels and traitors"]
            ..medium = <String>["were a staunch supporter of the Empire"];
        externalFlavor = new StatFlavor(1)
            ..death  = <String>["getting into other troll's business too much","trying to manipulate the wrong Highblood","bugging and fussing and meddling with the wrong Highblood"]
            ..medium = <String>["investigated the world around them constantly"];
        impatienceFlavor = new StatFlavor(1)
            ..death  = <String>["skipping critical steps in a dangerous procedure","failing to read the instructions","trying to gain power too quickly"]
            ..medium = <String>["always rushed ahead to the next big thing"];
        calmFlavor = new StatFlavor(-3)
            ..medium = <String>["made sure not to get too excited about unlikely possibilities"];
        realisticFlavor = new StatFlavor(0)
            ..medium = <String>["always strove to see the world for how it truly was"];
        acceptingFlavor = new StatFlavor(-3)
            ..medium = <String>["collected unsolved mysteries"];
        freeFlavor = new StatFlavor(1)
            ..death  = <String>["rebelling against the empire","without any friends beside them","betraying the wrong Highblood"]
            ..medium = <String>["never stayed in any one place long"];
        internalFlavor = new StatFlavor(0)
            ..medium = <String>["learned to be their true self"];
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

    StatFlavor get flavor {
        if(value >=0) {
            return positiveFlavor;
        }else {
            return negativeFlavor;
        }
    }

    WeightedList<String> getPossibleFlavors(WeightedList<String> output, String colorWorld) {
       // print("~~~~positive flavor is ${positiveFlavor} for ${positiveName} and negative is ${negativeFlavor} for ${negativeName}");
        return flavor.addWeightedFlavor(output, value, colorWorld);
    }

    WeightedList<String> getPossibleDeathFlavors(WeightedList<String> output) {
        return flavor.addDeathFlavor(output, value);
    }



    int get normalizedValue => value.abs();

    //useful to know how 'big' this stat is
    double get percentOfHighValue => (normalizedValue/Stat.HIGH);

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

    //they died X "fighting the empire" "of a mysterious illness" etc.
    List<String> death = new List<String>();

    //if you're patient, reduces, if you're impatient,increases, etc
    int oddsOfViolentDeath = 0;

    StatFlavor(this.oddsOfViolentDeath) {

    }

    static double getWeightByValue(int value) {
        if(value >= Stat.VERYFUCKINGHIGH) return VERYFUCKINGHIGHWEIGHT;
        if(value >= Stat.HIGH) return HIGHWEIGHT;
        if(value >= Stat.MEDIUM) return MEDIUMWEIGHT;
        if(value >= Stat.LOW) return LOWWEIGHT;
        return 0.01;
    }


    WeightedList<String> addDeathFlavor(WeightedList<String> output, int value,[bool isDefault = false]) {
        double multiplier = 1.0;
        if(isDefault) multiplier = 0.01; //don't go for default if you have any better options
        double weight = 0.0;
        //start low, end high
        if(value >= Stat.LOW) weight = LOWWEIGHT;
        if(value >= Stat.MEDIUM) weight = MEDIUMWEIGHT;
        if(value >= Stat.HIGH) weight = HIGHWEIGHT;
        if(value >= Stat.VERYFUCKINGHIGH) weight = VERYFUCKINGHIGHWEIGHT;

        //will always add any death at the correct weight, with a possible default multiplier
        output = processTier(output, value, 0, death, weight,multiplier);

        return output;
    }

    WeightedList<String> addWeightedFlavor(WeightedList<String> output, int value, String colorWord, [bool isDefault = false]) {
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