import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:SeekersAndAdvisors/pages/advisor_function/advisor_info_page.dart';
import 'package:SeekersAndAdvisors/pages/advisor_function/advisor_register_page.dart';
import 'package:provider/provider.dart';

/*
* Author：Leon
* Description：Widget for showing and changing caregories in advosor profile page.
* Date: 22/10/2
*/
class AdvisorCategories extends StatefulWidget {
  const AdvisorCategories({super.key});

  @override
  State<AdvisorCategories> createState() => _AdvisorCategoriesState();
}

class _AdvisorCategoriesState extends State<AdvisorCategories> {
  late AppUser user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "My Categories",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: TextButton(
              child: const Text('Apply for another'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdvisorRegisterPage()));
              },
            ),
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
                itemCount: user.advisor!.categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text('${user.advisor!.categories[index]} '),
                    // ButtonBox(
                    //   text: user.advisor!.categories[index],
                    //   background: Colors.blueAccent,
                    // ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
