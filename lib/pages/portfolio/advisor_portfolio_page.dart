import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/models/user.dart';
import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:SeekersAndAdvisors/daos/level_system_methods.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/advisor_bio_widge.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/advisor_categories_widge.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/advisor_favourite_charity.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/advisor_gifts_widget.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/advisor_title_widge.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/profession_widget.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/widgets/role_model_widget.dart';
import 'package:provider/provider.dart';

import 'widgets/contact_widget.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';

/*
* Author：Leon
* Description：Advisor profile page.
* Date: 22/10/2
*/
class AdvisorPortfolioPage extends StatefulWidget {
  const AdvisorPortfolioPage({super.key});

  @override
  State<AdvisorPortfolioPage> createState() => _AdvisorPortfolioPageState();
}

class _AdvisorPortfolioPageState extends State<AdvisorPortfolioPage> {
  late TextEditingController? _bioController;

  late String documentId = "";
  bool _isLoading = false;

  Uint8List? _image;
  String? _imageURL;

  @override
  void initState() {
    _bioController = TextEditingController();
    super.initState();
    loadData();
  }

  late UserModel user;
  late AppUser appUser;

  int total = 100;
  //
  int maxwidth = 160;

  double pess = 0.0;

  loadData() async {
    setState(() {
      _isLoading = true;
    });
    var res = await AuthMethods().getUserDetails();
    setState(() {
      pess = (res.experiencePoint! / maxwidth) * 10;
      user = res;
      _isLoading = false;
      _imageURL = res.avatar;
    });
  }

  @override
  void dispose() {
    _bioController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    appUser = Provider.of<AppUser>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade300,
        elevation: 0.0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: size.height,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    color: Colors.grey.shade300,
                    child: _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : InkWell(
                            child: CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(_imageURL!),
                          )),
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
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.orange[100]!),
                                          padding: MaterialStateProperty
                                              .resolveWith((states) =>
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0)),
                                          shape: MaterialStateProperty
                                              .resolveWith((states) =>
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32))),
                                        ),
                                        onPressed: null,
                                        child: Text(
                                          LevelSystem()
                                              .getLvMsg(user.experiencePoint!),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
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
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          indicatorColor),
                                  minHeight: 10,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const AdvisorTitleWidget(),
                              const AdvisorBioWidget(),
                              const AdvisorGifts(),
                              const Profession(),
                              const RoleModel(),
                              const FavouriteCharity(),
                              const ContactWidget(),
                              const SizedBox(
                                height: 10.0,
                              ),
                              const AdvisorCategories()
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
    );
  }
}
