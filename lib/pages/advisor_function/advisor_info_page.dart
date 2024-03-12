// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/advisor_account_methods.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/models/user.dart';
import 'package:SeekersAndAdvisors/pages/chat/chat_page.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';

import 'package:SeekersAndAdvisors/daos/chat_method.dart';

class AdvisorInfoPage extends StatefulWidget {
  final Advisor advisor;
  const AdvisorInfoPage({super.key, required this.advisor});

  @override
  State<AdvisorInfoPage> createState() => AdvisorInfoPageState();
}

class AdvisorInfoPageState extends State<AdvisorInfoPage> {
  late UserModel advisorUserModel;
  bool _isLoading = true;

  //get user info
  _initUser() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.advisor.id.trim())
        .get();
    UserModel advisorUser = UserModel.fromSnap(snapshot);
    // var userData = snapshot.data()!;
    // UserModel advisorUser = UserModel(
    //     username: userData['username'],
    //     uid: widget.advisor.id.trim(),
    //     email: userData['email'],
    //     phone: userData['phone'],
    //     avatar: userData['avatar'],
    //     background: userData['background'],
    //     categories: userData['categories'],
    //     experiencePoint: userData['Experience_Point'],
    //     contactDetail: userData['Contact_Detail'],
    //     bio: userData['Bio']);
    // widget.advisor.setUser = user;
    advisorUserModel = advisorUser;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getGifts();
    _initUser();
  }

  List<Map<String, dynamic>?> gifts = [];

  //get gifts
  void getGifts() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    var res = await firestore.collection("gift").get();

    for (var element in res.docChanges) {
      gifts.add(element.doc.data());
    }
    setState(() {});
  }

  /// sender gift
  Future<void> addGiftRecord(
      {required int price, required String type, required String rid}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User currentUser = auth.currentUser!;
    final data = {
      "price": price,
      "type": type,
      "sender": currentUser.uid,
      "receiver": rid
    };
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    firestore
        .collection("giftGiveReceiveRecord")
        .add(data)
        .then((documentSnapshot) {
      // print("Added Data with ID: ${documentSnapshot.id}");
      AdvisorAccountMethods().addGift(type, rid);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              // backgroundColor: Colors.grey.shade300,
              backgroundColor: const Color.fromARGB(255, 53, 99, 233),

              elevation: 0.0,
            ),
            body: Column(
              children: [
                SizedBox(
                  height: size.height * 0.20,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/BGbackground.png'), // NetworkImage(advisorUserModel.background),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      userAvatarBuilder(),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              advisorUserModel.username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                width: 160,
                                height: 60,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: const [
                                    SizedBox(
                                      width: 200,
                                      child: LinearProgressIndicator(
                                        value: 0.3,
                                        backgroundColor:
                                            indicatorBackgroundColor,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                indicatorColor),
                                        minHeight: 10,
                                      ),
                                    ),
                                  ],
                                )),
                            // const Text(
                            //   "Reloaded 1 of 587 libraries in 170ms.",
                            //   style: TextStyle(fontSize: 14, color: Colors.grey),
                            // ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Advisor Bio",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(widget.advisor.bio),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Profession",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(advisorUserModel.profession ?? ''),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Role Model",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(advisorUserModel.roleModel ?? ''),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Favourite Charity",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(widget.advisor.favouriteCharity ?? ''),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Advisor Fields",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  SizedBox(
                                    width: 3000.0,
                                    height: 30.0,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.advisor.categories.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        const Color.fromARGB(
                                                            255, 36, 102, 224)),
                                                padding: MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        const EdgeInsets
                                                                .symmetric(
                                                            vertical: 1.0,
                                                            horizontal: 8.0)),
                                                shape: MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                        )),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                widget
                                                    .advisor.categories[index],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            ),
                                            // Text(
                                            //     '${widget.advisor.categories[index]} '),
                                            // ButtonBox(
                                            //   text: widget
                                            //       .advisor.categories[index],
                                            //   background: Colors.blueAccent,
                                            // ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Contact Details",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.phone,
                                          ),
                                          Text(advisorUserModel.phone),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.email_outlined),
                                          Text(advisorUserModel.email),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                              Icons.contact_page_outlined),
                                          Text(
                                            advisorUserModel.contactDetail ??
                                                "",
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ButtonBox(
                                      text: "Start a Chat",
                                      background: Colors.blue,
                                      radius: 0,
                                      onTap: () => {
                                        if (widget.advisor.isOn)
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatPage.createByUser(
                                                            partner:
                                                                advisorUserModel)))
                                          }
                                        else
                                          {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'The advisor does not have chat enabled. Please try consulting another advisors.')))
                                          }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: ButtonBox(
                                          onTap: () {
                                            if (widget.advisor.isOn) {
                                              giftAction();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'The advisor is not activated. Please try consulting another advisors.')));
                                            }
                                          },
                                          text: "Buy Him/Her a Gift",
                                          background: Colors.blue,
                                          radius: 0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
  }

  Widget userAvatarBuilder() {
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          alignment: Alignment.center,
          // color: Colors.grey.shade300,
          child: CircleAvatar(
            minRadius: 20,
            maxRadius: 60,
            backgroundImage: NetworkImage(advisorUserModel.avatar),
          ),
        ));
  }
}

extension Action on AdvisorInfoPageState {
  //gift dialog
  //Send gifts to users based on the selection index
  Future giftAction() async {
    var index = await showDialog<int>(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ListTile(
                    title: Text(
                      "What to send?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  ),
                  Column(
                    children: List.generate(
                        gifts.length,
                        (index) => ListTile(
                              onTap: (() => Navigator.pop(context, index)),
                              title: Text("${gifts[index]!["type"]}"),
                              subtitle: Text(
                                  "${gifts[index]!["price"]} reward points"),
                              trailing: const Icon(Icons.keyboard_arrow_right),
                            )),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      style: TextStyle(
                          color: Colors.red, fontStyle: FontStyle.italic),
                      'This functionality is currently  an intension and will only send a special message to the advisor, to be further developed in the future'),
                ],
              ),
            ));
    if (index != null) sendTxt(index);
  }

  //After the gift is successfully sent, a message is sent to the user
  sendTxt(int index) async {
    // return;
    // late final String text = textEditingController.value.text.trim();
    late final Timestamp time = Timestamp.fromDate(DateTime.now());
    String? toUid = widget.advisor.id;
    String toName = widget.advisor.name;
    String toAvatar = widget.advisor.avatar;

    await addGiftRecord(
        price: gifts[index]!["price"], type: gifts[index]!["type"], rid: toUid);

    String text =
        "Hi, $toName, I have bought you an ${gifts[index]!["type"]}, hoping you like it! ";
    sendMessage(toUid, toName, toAvatar, text, time);
  }
}

class ButtonBox extends StatelessWidget {
  final String text;
  final double paadingSize;
  final Color color;
  final Color background;
  final double radius;
  final Function? onTap;
  const ButtonBox({
    Key? key,
    required this.text,
    this.paadingSize = 16.0,
    this.color = Colors.white,
    this.background = Colors.pink,
    this.radius = 32,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.resolveWith(
              (states) => EdgeInsets.symmetric(vertical: paadingSize)),
          textStyle: MaterialStateProperty.resolveWith<TextStyle>(
              (states) => TextStyle(color: color)),
          backgroundColor:
              MaterialStateProperty.resolveWith<Color>((states) => background),
          shape: MaterialStateProperty.resolveWith((states) =>
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius))),
        ),
        onPressed: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Text(text));
  }
}
