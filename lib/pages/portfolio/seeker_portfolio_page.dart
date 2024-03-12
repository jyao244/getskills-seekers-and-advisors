import 'package:SeekersAndAdvisors/pages/portfolio/update_credentials_page.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/models/user.dart';
import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:SeekersAndAdvisors/daos/level_system_methods.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/avatar_widget.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/background_widget.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/profession_widget.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/role_model_widget.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/bio_widget.dart';
import 'widgets/contact_widget.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';
import 'package:SeekersAndAdvisors/pages/login/login_page.dart';

import 'package:carousel_slider/carousel_slider.dart';

/*
* Authors：Siwei, Leon, Johnny, Qunzhi, Raymond
* Description：seeker profile page.
* Date: 22/10/12
*/

class SeekerPortfolioPage extends StatefulWidget {
  const SeekerPortfolioPage({super.key});

  @override
  State<SeekerPortfolioPage> createState() => _SeekerPortfolioPageState();
}

class _SeekerPortfolioPageState extends State<SeekerPortfolioPage> {
  //9.18 create
  // late TextEditingController? _bioEditingController;
  late TextEditingController? _nameEditingController;

  late String documentId = "";
  late UserModel user;
  bool _isLoading = false;
  int total = 100;
  int maxwidth = 160;
  double pess = 0.0;

  late final bool updateCredentialsButton;

  var initialPage = 1;
  CarouselController onDemandCarouselController = CarouselController();

  @override
  void initState() {
    // _bioEditingController = TextEditingController();
    _nameEditingController = TextEditingController();
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    var res = await AuthMethods().getUserDetails();
    setState(() {
      pess = (res.experiencePoint! / maxwidth) * 10;
      user = res;
      // _bioEditingController?.text = user.bio!;
      _isLoading = false;
    });
    // if the user is registed by email, then show the update credentials button
    updateCredentialsButton = FirebaseAuth.instance.currentUser!.providerData
        .any((element) => element.providerId == 'password');
  }

  @override
  void dispose() {
    // _bioEditingController?.dispose();
    _nameEditingController?.dispose();
    super.dispose();
  }

  void signOut() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text("Are you sure you want to sign out?"),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await AuthMethods().signOut(context);
              setState(() {
                _isLoading = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              });
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, 'No');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateName() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameEditingController,
                  autofocus: true,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () {
                    String name = _nameEditingController!.text;

                    updateUserProfile('username', name).then((value) {
                      Provider.of<AppUser>(context, listen: false).setAppUser();
                      _nameEditingController!.text = '';
                      Navigator.of(context).pop();
                    });
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.grey.shade300,
        backgroundColor: const Color.fromARGB(255, 53, 99, 233),

        elevation: 0.0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.20,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: const <Widget>[
                        BackgroundWidget(),
                        AvatarWidget(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Selector<AppUser, String>(
                                  selector:
                                      (BuildContext context, AppUser appUser) =>
                                          appUser.user!.username,
                                  builder: (context, username, child) {
                                    return Text(
                                      username,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.orange[100]!),
                                      padding:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0)),
                                      shape: MaterialStateProperty.resolveWith(
                                          (states) => RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32))),
                                    ),
                                    onPressed: null,
                                    child: Text(
                                      LevelSystem()
                                          .getLvMsg(user.experiencePoint!),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    color: Colors.grey[600],
                                    onPressed: () {
                                      _updateName();
                                    },
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              LevelSystem().getExpMsg(user.experiencePoint!),
                              style: const TextStyle(),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: 200,
                              child: LinearProgressIndicator(
                                value: LevelSystem()
                                    .getPercent(user.experiencePoint!),
                                backgroundColor: indicatorBackgroundColor,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                    indicatorColor),
                                minHeight: 10,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            const BioWidget(),
                            const Profession(),
                            const RoleModel(),
                            const ContactWidget(),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 255, 50, 50)),
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 20)),
                                    shape: MaterialStateProperty.resolveWith(
                                        (states) => RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32))),
                                  ),
                                  onPressed: () {
                                    signOut();
                                  },
                                  child: const Text(
                                    "Sign out",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: updateCredentialsButton
                                        ? MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 36, 102, 224))
                                        : MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 170, 170, 170)),
                                    padding: MaterialStateProperty.resolveWith(
                                        (states) => const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 20)),
                                    shape: MaterialStateProperty.resolveWith(
                                        (states) => RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32))),
                                  ),
                                  onPressed: updateCredentialsButton
                                      ? () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UpdateCredentialsPage(),
                                            ),
                                          );
                                        }
                                      : null,
                                  child: const Text(
                                    "Update Credentials",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
