import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitaldocumentid/models/address.dart';
import 'package:digitaldocumentid/widget/pickers/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_state_city_pickers/country_state_city_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserDetailForm extends StatefulWidget {
  UserDetailForm({
    Key? key,
    required this.submitdata,
    required this.isInitialScreen,
  }) : super(key: key);
  final bool isInitialScreen;

  final Function(
      {required String userFname,
      required String userLastName,
      required String useMiddleName,
      required String userGender,
      required DateTime usaeDOB,
      required String userAadharNo,
      required XFile userCurrentImage,
      required String userEmail,
      required Address userAddress}) submitdata;

  @override
  State<UserDetailForm> createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm> {


  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _LastName = TextEditingController();
  final TextEditingController _MiddleName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _userAadharNo = TextEditingController();
  final TextEditingController _ploatNo = TextEditingController();
  final TextEditingController _PINcode = TextEditingController();
  final TextEditingController _addressName = TextEditingController();
  final TextEditingController _addressByNear = TextEditingController();
  final TextEditingController _village = TextEditingController();
  final TextEditingController _DOB = TextEditingController();

  String? _gender;
  String? city;
  String? state;
  String? country;

  var _image;
  var _selecteDate = DateTime.now();

  String? NetworkImage;
  var _loadding = false;
  var addresEdit=false;


  _pickUserImage(imagePath) {
    _image = imagePath;
  }

  final _userDataKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  _submit() {

    if(_gender==null)
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please Select Gender')));
        return;
      }if(_image==null)
      {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please Pick Image')));
        return;
      }
    final b = _userDataKey.currentState!.validate();

    if (b) {
      widget.submitdata(
          userFname: _firstName.text,
          userLastName: _LastName.text,
          useMiddleName: _MiddleName.text,
          userGender: _gender!,
          usaeDOB: _selecteDate,
          userAadharNo: _userAadharNo.text,
          userCurrentImage: _image,
          userEmail: _email.text,
          userAddress: Address(
              ploatNo: int.parse(_ploatNo.text),
              PINcode: int.parse(_PINcode.text),
              addressName: _addressName.text,
              addressByNear: _addressByNear.text,
              village: _village.text,
              city: city!,
              state: state!,
              contry: country!));
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selecteDate,
      firstDate: DateTime(1947),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          _selecteDate = value;
        });
      }
    });
  }

  Future<void> setValues() async {
    setState(() {
      _loadding = true;
    });

    final UserData = await _fireStore
        .collection('user')
        .doc('${_auth.currentUser!.uid}')
        .collection('user_details')
        .doc('${_auth.currentUser!.uid}')
        .get();

    _selecteDate = DateTime.parse(UserData['usaeDOB']);
    _firstName.text = UserData['userFname'];
    _LastName.text = UserData['userLastName'];
    _MiddleName.text = UserData['useMiddleName'];
    _gender=UserData['gender'];
    _email.text = UserData['userEmail'];
    _userAadharNo.text = UserData['userAadharNo'];
    final _userAddress = await jsonDecode(UserData['userAddress']);
    print(_userAddress);
    _ploatNo.text = _userAddress['ploatNo'].toString();
    print(_ploatNo.text);
    _addressName.text = _userAddress['addressName'];
    _addressByNear.text = _userAddress['addressByNear'];
    _village.text = _userAddress['village'];
    city = _userAddress['city'];
    state = _userAddress['state'];
    country = _userAddress['contry'];
    _PINcode.text = _userAddress['PINcode'].toString();
    NetworkImage = UserData['userCurrentImage'];

    print(UserData.data());
    setState(() {
      _loadding = false;
    });
  }

  void initState() {
    if (!widget.isInitialScreen) {
      setValues();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loadding
        ? Center(child: CircularProgressIndicator())
        : Container(
            margin: EdgeInsets.all(10),
            child: Card(
              borderOnForeground: true,
              elevation: 2,
              clipBehavior: Clip.hardEdge,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  key: _userDataKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                          child: UserImagePiker(
                              pickUserImage: _pickUserImage,
                              imgeUrl: NetworkImage)),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Your Full Name',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      buildTextFormField(_firstName, 'First Name', (value) {
                        if (value.toString().isEmpty) return 'Required';
                      }),
                      buildTextFormField(_LastName, 'Last Name', (value) {
                        if (value.toString().isEmpty) return 'Required';
                      }),
                      buildTextFormField(_MiddleName, 'Middle Name', (value) {
                        if (value.toString().isEmpty) return 'Required';
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your gender',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      Row(
                        children: [
                          Expanded(child: ListTile(
                            title: const Text('Male'),
                            leading: Radio(
                              value: 'male',
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value as String?;
                                });
                              },
                            ),
                          ),
                          ),
                          Expanded(child: ListTile(
                            title: const Text('Female'),
                            leading: Radio(
                              value: 'female',
                              groupValue: _gender,
                              onChanged: (value) {
                                setState(() {
                                  _gender = value as String?;
                                });
                              },
                            ),
                          ),
                          )
                        ],
                      ),

                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your E-mail Address',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      buildTextFormField(_email, 'E-Mail', (value) {
                        if (!value.toString().contains('@gmail.com') ||
                            (value.toString().length < 10)) {
                          return 'Enter valid Email';
                        }
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your aadhar card number',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      buildTextFormFieldFonNumber(
                          _userAadharNo, 'Aadhar Card Number', (value) {
                        if (value.toString().length != 12) {
                          return 'Enter the valid Pin code';
                        }
                      }),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your birth Date',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      TextFormField(
                        cursorWidth: 0,
                        cursorColor: Colors.white,
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          _presentDatePicker();
                        },
                        onChanged: (_) {
                          _DOB.text =
                              DateFormat('dd-MM-yyyy').format(_selecteDate);
                          FocusScope.of(context).unfocus();
                        },
                        controller: _DOB,
                        decoration: InputDecoration(
                          hintText:
                              DateFormat('dd-MM-yyyy').format(_selecteDate),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Your address below',
                        textScaleFactor: 1.2,
                      ),
                      Divider(
                        color: Colors.blue,
                        thickness: 1,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: buildTextFormFieldFonNumber(
                                      _ploatNo, 'No.', (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Required';
                                    }
                                  })),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 8,
                              child: buildTextFormField(
                                _addressName,
                                'Address',
                                (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Required';
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      buildTextFormField(_addressByNear, 'Near By', (value) {
                        if (value.toString().isEmpty) {
                          return 'Required';
                        }
                      }),
                      buildTextFormField(_village, "Village", (value) {
                        if (value.toString().isEmpty) {
                          return 'Required';
                        }
                      }),
                      buildTextFormFieldFonNumber(_PINcode, 'PIN code Number',
                          (value) {
                        if (value!.length != 6) {
                          return 'the valid Pin code';
                        }
                      }),
                      if(!widget.isInitialScreen)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text('Turn On If Change In City and State'),
                          Switch(value: addresEdit, onChanged: (_){
                            setState(() {
                              addresEdit=!addresEdit;
                            });
                          }),
                        ],
                      ),
                      if(widget.isInitialScreen||addresEdit)
                      CountryStateCityPicker(
                        initialCountry: '🇮🇳India',
                        onCityChanged: (value) {
                          setState(() {
                            city = value;
                          });
                        },
                        onCountryChanged: (val) {
                          country = val;
                        },
                        onStateChanged: (value) {
                          state = value;
                        },
                      ),
                      RaisedButton(
                        onPressed: _submit,
                        child: Text('Submit'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  buildTextFormField(_controller, _hint, _validator) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: _validator,
        controller: _controller,
        decoration: InputDecoration(
          hintText: _hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        keyboardType:
            _hint == 'E-Mail' ? TextInputType.emailAddress : TextInputType.name,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  buildTextFormFieldFonNumber(_controller, _hint, _validator) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: _validator,
        controller: _controller,
        decoration: InputDecoration(
          hintText: _hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        ),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      ),
    );
  }
}
