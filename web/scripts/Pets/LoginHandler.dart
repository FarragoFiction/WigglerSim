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

    //either who you are currently logged in as and an option to log out
    //or a form for logging in.
    static DivElement loginStatus() {
        DivElement ret = new DivElement();
        if(hasLogin()) {
            //first i need to confirm my login info is valid
            ret.text = "TODO: DISPLAY LOGIN DETAILS AND A BUTTON TO LOG OUT";

        }else {
            return displayLogin();

        }

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
    }

}