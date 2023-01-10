import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}


class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIDRecived = "";
  bool otpCodeVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BlackCoffer'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user,size: 70.0,),
              const SizedBox(
                height: 10,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              Visibility(
                visible: otpCodeVisible,
                child: TextField(
                  decoration: const InputDecoration(labelText: "One Time Password"),
                  controller: otpController,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(onPressed: (){
                if(otpCodeVisible){
                  verifyOtp();
                }else{
                  verifyNumber();
                }
              }, child: Text(otpCodeVisible ? "Login":"Verify")),
              Visibility(
                  visible: otpCodeVisible,
                  child: TextButton(onPressed: verifyNumber, child: Text("Resend Otp?")))
            ],
          ),
        ),
    );
  }
  void verifyNumber(){
    auth.verifyPhoneNumber(phoneNumber: phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential){
        auth.signInWithCredential(credential).then((value)=>{
          print("You are loggged in successfully")
        });
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception.message);
        },
        codeSent: (String verificationID,int? resendToken){
          verificationIDRecived = verificationID;
          otpCodeVisible = true;
          setState(() {

          });

        },
        codeAutoRetrievalTimeout: (String verificationID){}
    );
  }

  void verifyOtp() async{
    PhoneAuthCredential credential =   PhoneAuthProvider.credential(verificationId: verificationIDRecived, smsCode: otpController.text);
    await auth.signInWithCredential(credential).then((value){
      print("You are logged in successfully");
    });
  }
}

