// ignore_for_file: avoid_print

import 'package:chat_app/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/custom_button.dart';
import '../components/custom_text_form_field.dart';
import '../components/show_snack_bar.dart';
import 'login_screen.dart';

// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;

  String? password;


  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                // const Spacer(
                //   flex: 2,
                // ),
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  kLogo,
                  height: 100,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Scholar Chat',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontFamily: 'pacifico',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // const Spacer(
                //   flex: 2,
                // ),
                const SizedBox(
                  height: 40,
                ),
                const Row(
                  children: [
                    Text(
                      'REGISTER',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        // fontFamily: 'pacifico',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  
                  hintText: 'Name',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  hintText: 'Phone',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  onChanged: (value) {
                    email = value;
                  },
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  onChanged: (value) {
                    password = value;
                  },
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 10,
                ),
                // CustomTextField(
                //   hintText: 'Confirm Password',
                // ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onTap: () async {
                    var auth = FirebaseAuth.instance;
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        UserCredential userCredential =
                            await registerUser(auth);

                        print(userCredential.user!.email);
                        // ignore: use_build_context_synchronously
                        showSnackBar(
                          context,
                          'Success',
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(
                          context,
                          LoginScreen.id,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(
                            context,
                            'The password provided is too weak.',
                          );
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(
                            context,
                            'The account already exists for that email.',
                          );
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        showSnackBar(
                          context,
                          e.toString(),
                        );
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                  text: 'REGISTER',
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'do have an account ?',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '   Login',
                        style: TextStyle(
                          color: Color(
                            0xffC7EDE6,
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // const Spacer(
                //   flex: 3,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential> registerUser(FirebaseAuth auth) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    return userCredential;
  }
}
