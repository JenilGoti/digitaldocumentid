import 'dart:ui';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EnterPhoneNumberScreen extends StatefulWidget {
  @override
  State<EnterPhoneNumberScreen> createState() => _EnterPhoneNumberScreenState();
}

class _EnterPhoneNumberScreenState extends State<EnterPhoneNumberScreen> {
  final TextEditingController _phoneNo = TextEditingController();

  final TextEditingController _otp = TextEditingController();
  bool a = true;
  bool _loadingOtp = false;
  FirebaseAuth? _auth;
  late PhoneAuthCredential _credential;
  String? _verificationId;
  final _formKey = GlobalKey<FormState>();
  bool _phonNoFild = true;
  bool Loading = false;
  String? phoneNo;

  initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (a) {
      _auth = FirebaseAuth.instance;

      super.didChangeDependencies();
      a = false;
    }
  }

  dispose() {
    a = true;

    super.dispose();
  }

  void verifyPhonNo(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await _auth!.verifyPhoneNumber(
      phoneNumber: phoneNo ?? '+91${_phoneNo.text}',
      timeout: Duration(seconds: 100),
      verificationCompleted: (PhoneAuthCredential credential) async {
        _credential = credential;
        setState(() {
          phoneNo = '+91${_phoneNo.text}';
          Loading = false;
        });
      },
      verificationFailed: (FirebaseAuthException e) async {
        print('error');
        setState(() {
          Loading = false;
        });
        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text(e.message.toString())));
      },
      codeSent: (String verificationId, int? resendToken) async {
        _verificationId = verificationId;

        _scaffoldKey.currentState!
            .showSnackBar(SnackBar(content: Text('OTP sended')));

        setState(() {
          // SmsAutoFill().listenForCode;

          _phonNoFild = false;
        });
        await SmsAutoFill().listenForCode;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (_phonNoFild) {
          return;
        }
        setState(() {
          Loading = false;
        });
        return;
      },
    );
  }

  logIn() async {
    if (_otp.text.length < 6) {
      setState(() {
        _loadingOtp = false;
      });
      return;
    }
    FocusScope.of(context).unfocus();
    PhoneAuthCredential newcredential = await PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: _otp.text);

    try {
      await FirebaseAuth.instance
          .signInWithCredential(newcredential)
          .then((value) {
        print(value);
        setState(() {
          _loadingOtp = false;
        });
      });
    } on FirebaseAuthException catch (e) {
      _scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      setState(() {
        _loadingOtp = false;
      });
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            elevation: 5,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: _phonNoFild
                      ? Column(
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  'Continues With Phone Number',
                                  textScaleFactor: 1.4,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child:
                                  Image.asset('assets/phone_verification.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  'You Will Receive 6 Digit  Code to Verify Next',
                                  textScaleFactor: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value != null && value.length != 10) {
                                  setState(() {
                                    Loading = false;
                                  });
                                  return 'Enter the 10 Digit phone number';
                                }
                              },
                              maxLength: 10,
                              controller: _phoneNo,
                              decoration: InputDecoration(
                                hintText: 'Enter Phone Number',
                                icon: Icon(Icons.phone),
                                prefixText: '+91',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              keyboardType: TextInputType.phone,
                              onEditingComplete: () {
                                verifyPhonNo(context);
                              },
                            ),
                            Loading
                                ? CircularProgressIndicator()
                                : FittedBox(
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          Loading = true;
                                        });
                                        verifyPhonNo(context);
                                      },
                                      child: Text('send otp'),
                                    ),
                                  ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Verify Phone Number',
                              textScaleFactor: 1.4,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Code is Send To ${_phoneNo.text}',
                                  textScaleFactor: 1.1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.black38)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PinFieldAutoFill(
                              autoFocus: true,
                              // controller: _otp,

                              keyboardType: TextInputType.number,
                              onCodeChanged: (val) {
                                _otp.text = val!;
                                if (_otp.text.length == 6) {
                                  logIn();
                                }
                              },
                              codeLength: 6,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: FlatButton(
                                      onPressed: Loading
                                          ? null
                                          : () {
                                              verifyPhonNo(context);
                                              setState(() {
                                                Loading = true;
                                              });
                                            },
                                      child: Text('resend OTP')),
                                ),
                                Expanded(
                                  child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _phonNoFild = true;
                                          Loading = false;
                                        });
                                      },
                                      child: Text('Edit phon number')),
                                ),
                              ],
                            ),
                            _loadingOtp
                                ? CircularProgressIndicator()
                                : RaisedButton(
                                    onPressed: () {
                                      setState(() {
                                        _loadingOtp = true;
                                      });
                                      logIn();
                                    },
                                    child: Text('verify otp'),
                                  ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
