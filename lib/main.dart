import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import'package:newapp/mpesa_pay/initializer.dart';
import 'package:newapp/keys.dart';
import 'package:newapp/mpesa_pay/payment_enums.dart';
void main() {
  MpesaFlutterPlugin.setConsumerKey(KConsumerKey);
  MpesaFlutterPlugin.setConsumerSecret(KConsumerSecret);



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _AmountNo = TextEditingController();
  TextEditingController _NumberPhone = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool circular = false;
  Future<dynamic> LipaNaMpesa({required var amount, required String phone}) async {
    dynamic transactionInitialisation;;
    //Wrap it with a try-catch
    try {
      //Run it
      transactionInitialisation = await MpesaFlutterPlugin.initializeMpesaSTKPush(
          businessShortCode: "174379",
          transactionType: TransactionType.CustomerPayBillOnline,
          amount: amount,
          partyA: phone,
          partyB: "174379",
          callBackURL: Uri(scheme: "https", host : "my-app.herokuapp.com", path: "/callback"),
          accountReference: "payment",
          phoneNumber: phone,
          baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
          transactionDesc: "demo",
          passKey: "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919");
      print("RESULT: "+transactionInitialisation.toString());
      return transactionInitialisation;

    } catch (e) {
      //you can implement your exception handling here.
      //Network unreachability is a sure exception.
      print("CAUGHT EXCEPTION: " + e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,

        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                  height: 80
              ),
              Padding(
                padding: EdgeInsets.only(right: 30, left: 30),
                child: Container(

                  height: 200,
                  width: 400,
                  child: Container(
                      width: 200,
                      child: ListView(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 240, left: 5, top:0),
                            child: Text('Miguta',  style: TextStyle(fontSize:30, fontWeight: FontWeight.bold, ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 250, left: 5, top:10),
                            child: Text('Tithe', style: TextStyle(fontSize:30, fontWeight: FontWeight.bold, ),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 240, left: 5, top:10),
                            child: Text('Portal', style:TextStyle(fontSize:30, fontWeight: FontWeight.bold, )),
                          )
                        ],
                      )
                  ),
                  decoration: BoxDecoration(

                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    image: DecorationImage(
                      colorFilter:
                      ColorFilter.mode(Colors.green.withOpacity(0.5),
                          BlendMode.dstATop),
                      image: AssetImage("assets/Tithe-Box.jpg",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 30
              ),


              Container(
                padding: EdgeInsets.only(right: 30, left: 30, top: 40),
                child: TextFormField(
                  controller: _NumberPhone,

                  decoration: InputDecoration(

                    prefixIcon: Icon(CupertinoIcons.phone, color: Colors.black, ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 40.0),
                    labelText: "Mpesa Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.length < 10) {
                      return 'This is not a valid number';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 30, left: 30, top:30),
                child: TextFormField(


                  decoration: InputDecoration(
                    prefixIcon: Icon(CupertinoIcons.money_dollar, color: Colors.black,),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 40.0),
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please inPut this field';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(30.0))),
                  label: Text(
                    'Lets Go',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  textColor: Colors.white,
                  splashColor: Colors.white,
                  color: Colors.black,
                  onPressed: () async{
                    try {
                      final isValid = _formKey.currentState!.validate();
                      setState(() {
                        circular = true;
                      });

                      LipaNaMpesa(
                        phone: _NumberPhone.text,
                        amount:  double.parse(_AmountNo.text),
                      );
                    } catch (e) {
                      print("CAUGHT EXCEPTION: " + e.toString());
                    }
                  }
              ),
            ],
          ),
        )
    );
  }
}
