import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rakuten_demo/main.dart';
import 'package:rakuten_demo/pages/homePage.dart';
import 'package:rakuten_demo/services/apiService.dart' as API;
import 'package:rakuten_demo/services/authentication_error.dart';

// アカウント登録ページ
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String newEmail = ""; // 入力されたメールアドレス
  String newPassword = ""; // 入力されたパスワード
  String newUserId = ""; // 入力されたパスワード
  String infoText = ""; // 登録に関する情報を表示
  bool pswd_OK = false; // パスワードが有効な文字数を満たしているかどうか

  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? result;
  User? user;

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 30.0),
                child: Text('新規アカウントの作成',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),

            // ユーザIDの入力フォーム
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "ユーザID"),
                  onChanged: (String value) {
                    newUserId = value;
                  },
                )),

            // メールアドレスの入力フォーム
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    newEmail = value;
                  },
                )),

            // パスワードの入力フォーム
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child: TextFormField(
                  decoration: InputDecoration(labelText: "パスワード（8～20文字）"),
                  obscureText: true, // パスワードが見えないようRにする
                  maxLength: 20, // 入力可能な文字数
                  onChanged: (String value) {
                    if (value.length >= 8) {
                      newPassword = value;
                      pswd_OK = true;
                    } else {
                      pswd_OK = false;
                    }
                  }),
            ),

            // 登録失敗時のエラーメッセージ
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child: Text(
                infoText,
                style: TextStyle(color: Colors.red),
              ),
            ),

            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: ElevatedButton(
                child: Text(
                  '登録',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (pswd_OK) {
                    try {
                      await API.apiService.isUsedUserId(newUserId);
                      setState(() {
                        infoText = '既に使われている「ユーザID」です。';
                      });
                    } catch (e) {
                      try {
                        // メール/パスワードでユーザー登録
                        result = await auth.createUserWithEmailAndPassword(
                          email: newEmail,
                          password: newPassword,
                        );

                        // 登録成功
                        // 登録したユーザー情報
                        user = result?.user;

                        API.User api_user = API.User(
                          uid: user!.uid,
                          user_id: newUserId,
                        );

                        List<API.CleaningSetting> settings = [
                          API.CleaningSetting(
                              user_uid: user!.uid,
                              spot: '風呂',
                              remind_interval: 1),
                          API.CleaningSetting(
                              user_uid: user!.uid,
                              spot: 'リビング',
                              remind_interval: 1),
                          API.CleaningSetting(
                              user_uid: user!.uid,
                              spot: 'トイレ',
                              remind_interval: 1),
                        ];
                        await API.apiService
                            .addUserWithCleaningSettings(api_user, settings);
                        cleaningSettings = settings;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                title: 'Home',
                                user_id: user!.uid,
                              ),
                            ));
                      } catch (e) {
                        // 登録に失敗した場合
                        setState(() {
                          infoText =
                              auth_error.register_error_msg(e.toString());
                        });
                      }
                    }
                  } else {
                    setState(() {
                      infoText = 'パスワードは8文字以上です。';
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonTheme(
            minWidth: 350.0,
            // height: 100.0,
            child: ElevatedButton(
                child: Text(
                  'ログイン',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                // ボタンクリック後にアカウント作成用の画面の遷移する。
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
        ),
      ]),
    );
  }
}
