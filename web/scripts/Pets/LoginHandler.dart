import 'dart:convert';
import 'dart:html';

abstract class LoginHandler {
    static String LOGINLOCATION = "WIGGLERSIMLOGIN";


    static bool hasLogin() {
        return window.localStorage.containsKey(LOGINLOCATION);
    }

    static void storeLogin(String login, String password) {
        window.localStorage[LOGINLOCATION] = new LoginInfo(login, password).toJSON();
    }

    static void clearLogin() {
        window.localStorage.remove(LOGINLOCATION);
    }

    //either who you are currently logged in as and an option to log out
    //or a form for logging in.
    static DivElement loginStatus() {
        if(hasLogin()) {
            return displayLoginDetails();
        }else {
            return displayLogin();

        }
    }

    //the controler itself will handle checking if the info is valid
    static DivElement displayLoginDetails() {
        LoginInfo yourInfo = LoginHandler.fetchLogin();
        DivElement ret = new DivElement()..text = "Greetings, ${yourInfo.login}.";
        ret.style.textAlign = "left";
        ButtonElement button = new ButtonElement()..text = "Log Out";
        ret.append(button);
        return ret;
    }

    static DivElement displayLogin() {
        DivElement ret = new DivElement()..text = "Login to Sweepbook (or create a login).";
        DivElement first = new DivElement()..style.padding="10px";
        ret.append(first);

        LabelElement labelLogin = new LabelElement()..text = "Login:";
        InputElement login = new InputElement();
        first.append(labelLogin);
        first.append(login);
        LabelElement labelPW = new LabelElement()..text = "Password:";
        InputElement pw = new PasswordInputElement();
        first.append(labelPW);
        first.append(pw);
        ButtonElement button = new ButtonElement()..text = "Login to Sweepbook";
        ret.append(button);
        ret.append(new DivElement()..text = "(This is required to engage with the TIMEHOLE now, by Emperial decree.)");
        ret.append(new DivElement()..text = "(WARNING: This is very simple, don't put passwords you use other places here.)");

        button.onClick.listen((Event e)
        {
            storeLogin(login.value, pw.value);
            //when logged in should probably refresh the page.
            window.location.href = window.location.href;

        });

        return ret;

    }

    static LoginInfo fetchLogin() {
        return LoginInfo.fromJSON(window.localStorage[LOGINLOCATION]);
    }
}

class LoginInfo{
    String login;
    String password;
    int id;
    LoginInfo(String this.login, String this.password);

    @override
    String toJSON() {
        return jsonEncode({"login":login, "password":password});
    }

    LoginInfo.fromJSON(String json){
        var tmp = jsonDecode(json);
        login = tmp["login"];
        password = tmp["password"];
    }

    Future<bool> confirmedInfo()async {
        //TODO send my info to the server to confirm it.
        //its a get on caretakers/caretakeridbylogin and i pass login and password. i'll get a true/false back
        return false;
    }

}