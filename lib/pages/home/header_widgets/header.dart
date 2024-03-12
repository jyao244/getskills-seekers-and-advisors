import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/seeker_portfolio_page.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';
import 'package:SeekersAndAdvisors/pages/advisor_function/advisor_register_page.dart';
import 'package:SeekersAndAdvisors/pages/chat/chat_list_page_advisor.dart';
import 'package:SeekersAndAdvisors/daos/level_system_methods.dart';
import 'package:provider/provider.dart';

/*
* Author：Johnny
* Description：The header component of the home page
* Date: 22/10/16
*/
class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late AppUser user;
  bool isLoading = false;
  var percent = 0.0;
  late String avatar;
  String lvMsg = '';
  String expMsg = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    percent = LevelSystem().getPercent(user.experiencePoint!);
    lvMsg = LevelSystem().getLvMsg(user.experiencePoint!);
    expMsg = LevelSystem().getExpMsg(user.experiencePoint!);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: headerBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SeekerPortfolioPage()))
                },
                child: CircleAvatar(
                  key: const ValueKey('avatar'),
                  backgroundImage: NetworkImage(user.avatar!.trim()),
                  radius: 15,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                ('Hello, ${user.name}'),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
              TextButton(
                key: const ValueKey('switch_advisor_view'),
                onPressed: () {
                  user.setAppUser().then((value) {
                    if (user.isAdvisor as bool) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdvisorChatListPage()));
                    }
                    //not an advisor, go to registration page
                    else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdvisorRegisterPage()));
                    }
                  });
                },
                child: const Text(
                  'Switch Advisor View',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: percent,
                      backgroundColor: indicatorBackgroundColor,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(indicatorColor),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    expMsg,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orange[100]!),
                      padding: MaterialStateProperty.resolveWith((states) =>
                          const EdgeInsets.symmetric(vertical: 16.0)),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32))),
                    ),
                    onPressed: null,
                    child: Text(
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        lvMsg)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
