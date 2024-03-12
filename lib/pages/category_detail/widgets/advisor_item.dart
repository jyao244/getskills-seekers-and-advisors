import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';

import 'package:SeekersAndAdvisors/utils/size_config.dart';
import 'package:SeekersAndAdvisors/pages/advisor_function/advisor_info_page.dart';

/*
* Author：Leon
* Description：Advisor card widget in advisor list of category detail page.
* Date: 22/9/28
*/
class AdvisorItem extends StatelessWidget {
  final Advisor advisor;
  const AdvisorItem({super.key, required this.advisor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdvisorInfoPage(advisor: advisor),
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: 44.0,
                    width: 45.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        advisor.avatar,
                      ),
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(advisor.name),
                      Text(advisor.title),
                    ],
                  ),
                )),
                // const Text("Active 2 days ago")
              ],
            ),
            SizedBox(height: getProportionateScreenWidth(10)),
            Container(
              margin: const EdgeInsets.only(left: 68),
              child: Text(advisor.bio,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}
