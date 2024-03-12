import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/home/home_screen_page.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/portfolio/advisor_portfolio_page.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';
import 'package:SeekersAndAdvisors/daos/advisor_account_methods.dart';
import 'package:provider/provider.dart';

const List<Widget> toggles = <Widget>[Text('ON'), Text('OFF')];
const List<bool> toggleValues = [true, false];

/*
* Author：Raymond
* Description：The header component for the advisor view, which included the mute button
* Date: 22/10/16
*/
class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late AppUser user;
  late Advisor advisor;
  bool isLoading = false;
  late String avatar;

  List<bool> selectedToggle = <bool>[true, false];

  @override
  void initState() {
    _getAdvisorInfo();
    super.initState();
  }

  void _getAdvisorInfo() async {
    AppUser user =
        await Provider.of<AppUser>(context, listen: false).setAdvisor();
    setState(() {
      advisor = user.advisor!;
      selectedToggle = [advisor.isOn, !advisor.isOn];
    });
  }

  void setIsOn(String uid, bool isOn, int index) async {
    AdvisorAccountMethods().setIsOn(uid: user.uid!, isOn: toggleValues[index]);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    // selectedToggle = [advisor.isOn, !advisor.isOn];

    // selectedToggle = <bool>[user]
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: headerBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AdvisorPortfolioPage()))
                  },
                  child: CircleAvatar(
                    key: const ValueKey('avatar'),
                    backgroundImage: NetworkImage(user.avatar!.trim()),
                    radius: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ('Hello, ${user.name}'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: const Text(
                    'Switch Seeker View',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: indicatorBackgroundColor,
              valueColor: const AlwaysStoppedAnimation<Color>(indicatorColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Active Hours: 56 hours 32 minutes',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ToggleButtons(
                direction: Axis.horizontal,
                onPressed: (int index) {
                  setState(() {
                    // The button that is tapped is set to true, and the others to false.
                    for (int i = 0; i < toggles.length; i++) {
                      selectedToggle[i] = i == index;
                    }
                    setIsOn(user.uid!, advisor.isOn, index);
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: selectedToggle,
                children: toggles,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
