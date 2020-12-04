

import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:timer_button/timer_button.dart';

import 'authservice.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {

      return new MaterialApp(debugShowCheckedModeBanner: false,
        supportedLocales: [
        Locale('en'),
    Locale('it'),
    Locale('fr'),
    Locale('es'),
    Locale('de'),
    Locale('pt'),
    Locale('ko'),
    Locale('zh'),
    ],
    localizationsDelegates: [
    CountryLocalizations.delegate,
    // GlobalMaterialLocalizations.delegate,
    // GlobalWidgetsLocalizations.delegate,
    ],
    home: new Scaffold(
      body: Form(
          key: formKey,
          child: Padding(padding:EdgeInsets.only(top: 48),child:Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text("LOGIN", style: TextStyle(color: Colors.blue, fontSize: 24),),
              Padding(padding:EdgeInsets.only(top:14,left:14),child:Row(children:[Text("Please enter your phone number", style: TextStyle(color: Colors.black, fontSize: 18),)])),
              Padding(padding: EdgeInsets.only(top: 14, left:6),child:IntlPhoneField(
             decoration: InputDecoration( labelText: 'Phone Number',
               border: OutlineInputBorder(
                 borderSide: BorderSide(),),),
              initialCountryCode: 'IN',
              onChanged: (val) {
                setState(() {
                  this.phoneNo = val.completeNumber;
                });
                print(val.completeNumber);
              },
            )),
              codeSent ? Padding(
                  padding: EdgeInsets.only(top:14,left: 14.0, right: 14.0),
                  child: TextFormField(maxLength: 6,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Enter OTP', counterText: "",   border: OutlineInputBorder(
                      borderSide: BorderSide(),), ),
                    onChanged: (val) {
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  )) : Container(),
              Row(mainAxisAlignment:MainAxisAlignment.end,children:[new TimerButton(
                label: "Resend OTP",
                timeOutInSeconds: 60,
                onPressed: () {},
                // buttonType: ButtonType.RaisedButton,
                color:Colors.white,
                disabledTextStyle: TextStyle(color:Colors.grey),
                activeTextStyle: TextStyle(color: Colors.blue),

              )]),
              Padding(
                  padding: EdgeInsets.only(left: 90.0, right: 90.0),
                  child: MaterialButton(elevation: 4,color: Colors.blue,
                      child: Center(child: codeSent ? Text('Login', style: TextStyle(color: Colors.white),):Text('Verify',style: TextStyle(color: Colors.white),)),
                      onPressed: () {
                        codeSent ? AuthService().signInWithOTP(smsCode, verificationId):verifyPhone(phoneNo);
                      })),

            ],
          ))),
    ));
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };


    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout,
    );
  }
}