import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:token_system/Entities/user.dart';
import 'package:token_system/Entities/shop.dart';
import 'package:token_system/Entities/authority.dart';
import 'package:token_system/Services/miscServices.dart';
import 'package:token_system/Services/userService.dart';
import 'package:token_system/Services/shopService.dart';
import 'package:token_system/Services/authorityService.dart';
import 'package:token_system/components/async_builder.dart';
import 'package:token_system/components/title.dart';
import 'package:token_system/screens/login.dart';
import 'package:token_system/utils.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  String _name = '';
  String _email = '';
  String _mobile = '';
  String _aadhaar = '------------';
  String _pincode = '';

  // FIXED: State and district dropdown menu. To be handled on backend.

  // Required for Shops
  String _ownerName = '';
  String _address = '';
  String _landmark = 'Not provided';
  Tuple2<int, String> _shopType;
  SignAs _selected = SignAs.user;

  String successMessage(int statusCode) {
    if (statusCode == 201)
      return 'Registration successful.';
    else if (statusCode == 409)
      return 'This E-mail address already exists!';
    else if (statusCode == 412)
      return 'Bad pincode!';
    else
      return 'Registration failed!';
  }

  String validateConfirmPassword(String value) {
    if (value.isEmpty) return 'Enter confirm password';
    var password = _passKey.currentState.value;
    if (!(value == password)) return 'Confirm Password mismatch';
    return null;
  }

  bool isShop() {
    if (_selected == SignAs.shop) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Call the Shop Categories API
    var onReceiveJson = (snapshot) {
      List<Tuple2<int, String>> shopTypes = [];
      // Construct List of Categories
      for (var item in snapshot.data['result']) {
        shopTypes.add(Tuple2(item['id'], item['shopType']));
      }
      return shopTypes;
    };

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                TitleWidget(),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Register as : ',
                        style: TextStyle(fontSize: 20),
                      ),
                      DropdownButton<SignAs>(
                        value: _selected,
                        icon: Icon(
                          Icons.arrow_downward,
                          color: Colors.blueGrey,
                        ),
                        iconSize: 24,
                        elevation: 8,
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 20,
                        ),
                        onChanged: (SignAs result) {
                          setState(() {
                            _selected = result;
                          });
                        },
                        items: <DropdownMenuItem<SignAs>>[
                          const DropdownMenuItem<SignAs>(
                            child: Text('User'),
                            value: SignAs.user,
                          ),
                          const DropdownMenuItem<SignAs>(
                            child: Text('Shop'),
                            value: SignAs.shop,
                          ),
                          const DropdownMenuItem<SignAs>(
                            child: Text('Authority'),
                            value: SignAs.authority,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: isShop() ? 'Shop Name' : 'Name',
                        ),
                        validator: (value) {
                          if (value.isEmpty || value.trim() == '')
                            return isShop()
                                ? 'Please enter your Shop name'
                                : 'Please enter your name';
                          else
                            return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Shop Owner Name',
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.trim() == '')
                              return 'Please enter your name';
                            else
                              return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _ownerName = value;
                            });
                          },
                        ),
                      ),
                      visible: isShop(),
                    ),
                    Visibility(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1.0, style: BorderStyle.solid, color: Colors.blueGrey),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            ),
                          ),
                          child: AsyncBuilder(
                            future: MiscService.getShopTypesApi(),
                            builder: (shopTypes) {
                              List<DropdownMenuItem> items = [];
                              for (var index = 0; index < shopTypes.length; index++) {
                                items.add(DropdownMenuItem(
                                  child: Text(shopTypes[index].item2),
                                  value: shopTypes[index],
                                ));
                              }
                              return DropdownButton(
                                iconDisabledColor: Colors.blueGrey,
                                iconEnabledColor: Colors.blue,
                                hint: Text('Shop Type'),
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                underline: Container(height: 0),
                                isExpanded: true,
                                items: items,
                                value: _shopType,
                                onChanged: (value) {
                                  setState(() {
                                    _shopType = value;
                                  });
                                },
                              );
                            },
                            onReceiveJson: onReceiveJson,
                            size: 40,
                          ),
                        ),
                      ),
                      visible: isShop(),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                        validator: validateEmail,
                        onSaved: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mobile number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validateMobile,
                        onSaved: (value) {
                          setState(() {
                            _mobile = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Aadhaar number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validateAadhaar,
                        onSaved: (value) {
                          setState(() {
                            _aadhaar = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Pincode',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validatePincode,
                        onSaved: (value) {
                          setState(() {
                            _pincode = value;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Address',
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.trim() == '')
                              return 'Please enter your address';
                            else
                              return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _address = value;
                            });
                          },
                        ),
                      ),
                      visible: isShop(),
                    ),
                    Visibility(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Landmark',
                          ),
                          validator: null,
                          onSaved: (value) {
                            setState(() {
                              _landmark = value;
                            });
                          },
                        ),
                      ),
                      visible: isShop(),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextFormField(
                        key: _passKey,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                        validator: (value) {
                          if (value.isEmpty) return 'Please Enter password';
                          if (value.length < 6) return 'Password should be atleast 6 characters';
                          return null;
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm password',
                        ),
                        validator: validateConfirmPassword,
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Builder(builder: (BuildContext context) {
                        return RaisedButton(
                            textColor: Colors.white,
                            color: Colors.blueGrey,
                            child: Text('Register'),
                            onPressed: () {
                              // FIXED: add validation function
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                String _password = _passKey.currentState.value;

                                if (_selected == SignAs.user) {
                                  User newUser = new User(
                                    name: _name.trim(),
                                    email: _email.trim(),
                                    mobileNumber: _mobile.trim(),
                                    aadhaarNumber: _aadhaar.trim(),
                                    pincode: _pincode.trim(),
                                  );
                                  UserService.registerApi(newUser, _password).then((code) {
                                    final snackbar = SnackBar(
                                      content: Text(successMessage(code)),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    // Pop screen if successful
                                    if (code == 201) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                } else if (_selected == SignAs.shop) {
                                  Shop newShop = new Shop(
                                      shopName: _name.trim(),
                                      ownerName: _ownerName.trim(),
                                      email: _email.trim(),
                                      mobileNumber: _mobile.trim(),
                                      aadhaarNumber: _aadhaar.trim(),
                                      address: _address.trim(),
                                      landmark: _landmark.trim(),
                                      shopType: _shopType.item2,
                                      pincode: _pincode.trim());
                                  ShopService.registerApi(newShop, _password, _shopType.item1)
                                      .then((code) {
                                    print('Inside Api call');
                                    final snackbar = SnackBar(
                                      content: Text(successMessage(code)),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    // Pop screen if successful
                                    if (code == 201) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                } else {
                                  Authority newAuth = new Authority(
                                    name: _name.trim(),
                                    email: _email.trim(),
                                    mobileNumber: _mobile.trim(),
                                    aadhaarNumber: _aadhaar.trim(),
                                    pincode: _pincode.trim(),
                                  );
                                  AuthorityService.registerApi(newAuth, _password).then((code) {
                                    final snackbar = SnackBar(
                                      content: Text(successMessage(code)),
                                    );
                                    Scaffold.of(context).showSnackBar(snackbar);
                                    // Pop screen if successful
                                    if (code == 201) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                }
                              }
                            });
                      }),
                    )
                  ]),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text('Already have an account?'),
                    FlatButton(
                      textColor: Colors.blue,
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        //Login screen
                        Navigator.pop(context);
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )));
  }
}
