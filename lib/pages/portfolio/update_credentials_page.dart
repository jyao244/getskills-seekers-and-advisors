import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/utils/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class UpdateCredentialsPage extends StatefulWidget {
  const UpdateCredentialsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateCredentialsPage> createState() => _UpdateCredentialsPageState();
}

class _UpdateCredentialsPageState extends State<UpdateCredentialsPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  late String oldEmail;
  bool newPasswordDisplay = true;
  bool oldPasswordDisplay = true;
  bool isLoading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newEmailController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  showErr(String err) {
    setState(() {
      isLoading = false;
    });
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Error'),
              content: Text(err),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  showSuccess(String category) {
    setState(() {
      isLoading = false;
    });
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Success'),
              content: Text('$category has been updated successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  clearCtl() {
    _oldPasswordController.clear();
    _newEmailController.clear();
    _newPasswordController.clear();
  }

  write() {
    String newEmail = _newEmailController.text;
    String newPassword = _newPasswordController.text;

    if (newEmail.isEmpty) {
      if (newPassword.isEmpty) {
        setState(() {
          isLoading = false;
        });
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Info'),
                  content: const Text('No change made.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ));
      } else {
        FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword)
            .then((value) => {
                  showSuccess('Password'),
                })
            .catchError(
                (error) => {showErr("Failed to update password: $error")});
      }
    } else {
      if (emailValidator(newEmail)) {
        if (newPassword.isEmpty) {
          FirebaseAuth.instance.currentUser!
              .updateEmail(newEmail)
              .then((value) => {
                    updateUserProfile('email', newEmail).then((value) {
                      Provider.of<AppUser>(context, listen: false).setAppUser();
                    }),
                    showSuccess('Email'),
                  })
              .catchError(
                  (error) => {showErr("Failed to update email: $error")});
        } else {
          // update email and password
          FirebaseAuth.instance.currentUser!
              .updateEmail(newEmail)
              .then((value) => {
                    updateUserProfile('email', newEmail).then((value) {
                      Provider.of<AppUser>(context, listen: false).setAppUser();
                    }),
                    showSuccess('Email'),
                  })
              .catchError(
                  (error) => {showErr("Failed to update email: $error")});
          FirebaseAuth.instance.currentUser!
              .updatePassword(newPassword)
              .then((value) => {
                    showSuccess('Password'),
                  })
              .catchError(
                  (error) => {showErr("Failed to update password: $error")});
        }
      } else {
        showErr("Wrong Email Format");
        setState(() {
          isLoading = false;
        });
      }
    }
    clearCtl();
  }

  update() async {
    _newEmailController.text = _newEmailController.text.trim();
    setState(() {
      isLoading = true;
    });

    if (_oldPasswordController.text.isEmpty) {
      showErr('Please enter your old password');
      setState(() {
        isLoading = false;
      });
    } else {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: FirebaseAuth.instance.currentUser!.email!,
              password: _oldPasswordController.text,
            ),
          )
          .then((value) => write())
          .onError((error, stackTrace) => showErr(error.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    oldEmail = Provider.of<AppUser>(context).email!;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: const Color.fromARGB(255, 53, 99, 233),

        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Update Credentials',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              const Text(
                'Re-login may be required before and after updating.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _oldPasswordController,
                obscureText: oldPasswordDisplay,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Old Password *',
                  suffix: IconButton(
                    onPressed: () {
                      //add Icon button at end of TextField
                      setState(() {
                        oldPasswordDisplay = !oldPasswordDisplay;
                      });
                    },
                    icon: Icon(oldPasswordDisplay
                        ? Icons.remove_red_eye
                        : Icons.password),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _newEmailController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'New Email'),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: newPasswordDisplay,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffix: IconButton(
                    onPressed: () {
                      //add Icon button at end of TextField
                      setState(() {
                        newPasswordDisplay = !newPasswordDisplay;
                      });
                    },
                    icon: Icon(newPasswordDisplay
                        ? Icons.remove_red_eye
                        : Icons.password),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () => update(), child: const Text('Update')),
            ],
          ),
        ),
      ),
    );
  }
}
