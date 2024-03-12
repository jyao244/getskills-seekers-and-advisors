import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';

/*
* Author：Leon
* Description：Widget for showing and editing bio in advisor profile page.
* Date: 22/10/2
*/
class AdvisorBioWidget extends StatefulWidget {
  const AdvisorBioWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AdvisorBioWidget> createState() => _AdvisorBioWidgetState();
}

class _AdvisorBioWidgetState extends State<AdvisorBioWidget> {
  late AppUser user;
  final TextEditingController _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

// Show bio editor dialog
  Future<void> _updateBio() async {
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
                  controller: _bioController,
                  autofocus: true,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () {
                    String bio = _bioController.text;
                    updateAdvisorProfile('bio', bio)
                        .then((value) => user.setAdvisor());
                    _bioController.text = '';
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Advisor Bio",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _updateBio();
                // print(_bio);
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              alignment: Alignment.centerLeft, child: Text(user.advisor!.bio)),
        ],
      ),
    );
  }
}
