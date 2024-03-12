import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/*
* Author：Leon
* Description：Widget for showing gifts in advisor profile page.
* Date: 22/10/2
*/
class AdvisorGifts extends StatefulWidget {
  const AdvisorGifts({
    Key? key,
  }) : super(key: key);

  @override
  State<AdvisorGifts> createState() => _AdvisorGiftsState();
}

class _AdvisorGiftsState extends State<AdvisorGifts> {
  // late AppUser user;

  @override
  Widget build(BuildContext context) {
    // user = Provider.of<AppUser>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "My Received Gifts",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('advisors')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.apple,
                        ),
                        Text('${snapshot.data!['gifts'][0]}'),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.coffee),
                        Text('${snapshot.data!['gifts'][1]}'),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
