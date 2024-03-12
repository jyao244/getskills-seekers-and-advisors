import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/advisor.dart';
import 'package:SeekersAndAdvisors/pages/category_detail/widgets/advisor_item.dart';
import 'package:SeekersAndAdvisors/utils/size_config.dart';

/*
* Author：Siwei
* Description：Advisor card in category detail page
* Date: 22/10/12
*/

class AdvisorCards extends StatelessWidget {
  final String category;
  const AdvisorCards({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: getProportionateScreenWidth(35)),
        advisorTag(),
        SizedBox(height: getProportionateScreenWidth(20)),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('advisors')
                  .where('authenticated', isEqualTo: true)
                  .where('categories', arrayContains: category)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var docList = List.from(snapshot.data!.docs);

                return docList.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'No More Advisor!',
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: docList.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docSnapshot = docList[index];
                          Advisor advisor =
                              Advisor.fromFirestore(docSnapshot, null);
                          return AdvisorItem(advisor: advisor);
                        });
              }),
        ),
      ],
    );
  }

  Container advisorTag() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Our Best advisors",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
