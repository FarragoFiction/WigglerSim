import 'package:DollLibCorrect/DollRenderer.dart';

class Sign {
/*
    TODO: Signs have lunar sway, caste and aspect.

    static var that has all created signs in a big stupid pile.

    can filter signs by lunar sway, case and aspect (three x where combob?)


 */

    static String PROSPIT = "PROSPIT";
    static String DERSE = "DERSE";
    static String TIME = "TIME";
    static String BREATH = "BREATH";
    static String DOOM = "DOOM";
    static String BLOOD = "BLOOD";
    static String HEART = "HEART";
    static String SPACE = "SPACE";
    static String MIND = "MIND";
    static String LIGHT = "LIGHT";
    static String VOID = "VOID";
    static String RAGE = "RAGE";
    static String HOPE = "HOPE";
    static String LIFE = "LIFE";
    // let these come from HomestuckTrollDoll
    static String BURGUNDY = HomestuckTrollDoll.BURGUNDY;
    static String BRONZE = HomestuckTrollDoll.BRONZE;
    static String GOLD = HomestuckTrollDoll.GOLD;
    static String LIME = HomestuckTrollDoll.LIME;
    static String OLIVE = HomestuckTrollDoll.OLIVE;
    static String JADE = HomestuckTrollDoll.JADE;
    static String TEAL = HomestuckTrollDoll.TEAL;
    static String CERULEAN = HomestuckTrollDoll.CERULEAN;
    static String INDIGO = HomestuckTrollDoll.INDIGO;
    static String PURPLE = HomestuckTrollDoll.PURPLE;
    static String VIOLET = HomestuckTrollDoll.VIOLET;
    static String FUCHSIA = HomestuckTrollDoll.FUCHSIA;

    //convinience
    static int signNumber = 1;

    //each time i make a sign just blindly add it here
    static List<Sign> allSigns = new List<Sign>();

    String caste;
    String lunarSway;
    String aspect;
    int imgNum;

    Sign(this.caste, this.aspect, this.lunarSway) {
        //easier than always adding by hand.
        imgNum = Sign.signNumber;
        Sign.signNumber ++;
        allSigns.add(this);
    }

    //http://hs.hiveswap.com/ezodiac/
    //http://farragofiction.com/DollSim/image_browser.html?canonsymbols=true
    static initAllSigns() {
        //pattern is, start with this castes canon aspect and moon
        //then keep moon constant till you run out of aspects (then repeat aspects in same order with other moon)
        //aspect order is canon caste order, backwards. so after time is life, after life is hope etc.
        new Sign(Sign.BURGUNDY, Sign.TIME, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.LIFE, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.HOPE, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.RAGE, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.VOID, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.LIGHT, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.MIND, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.SPACE, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.HEART, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.BLOOD, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.DOOM, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.BREATH, Sign.DERSE);
        new Sign(Sign.BURGUNDY, Sign.TIME, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.LIFE, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.HOPE, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.RAGE, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.VOID, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.LIGHT, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.MIND, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.SPACE, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.HEART, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.BLOOD, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.DOOM, Sign.PROSPIT);
        new Sign(Sign.BURGUNDY, Sign.BREATH, Sign.PROSPIT);

    }

}