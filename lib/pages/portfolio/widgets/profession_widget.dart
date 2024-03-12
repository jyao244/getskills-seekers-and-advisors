import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';

/*
* Author：Leon
* Description：Widget for showing and editing profession in seeker profile page.
* Date: 22/11/24
*/
class Profession extends StatefulWidget {
  const Profession({
    Key? key,
  }) : super(key: key);

  @override
  State<Profession> createState() => _ProfessionState();
}

class _ProfessionState extends State<Profession> {
  late AppUser user;
  final TextEditingController _professionController = TextEditingController();

  @override
  void dispose() {
    _professionController.dispose();
    super.dispose();
  }

  // Show editor dialog
  Future<void> _updateProfession() async {
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
                controller: _professionController,
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(labelText: 'Profession'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  String profession = _professionController.text;
                  updateUserProfile('profession', profession)
                      .then((value) => user.setAppUser());
                  _professionController.text = '';
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Profession",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _updateProfession();
              },
            ),
          ),
          const SizedBox(
            height: 1.0,
          ),
          Container(
            alignment: Alignment.centerLeft,
            height: 25,
            child: Selector<AppUser, String>(
              selector: (BuildContext context, AppUser appUser) =>
                  appUser.profession!,
              builder: (context, profession, child) {
                return Text(profession);
              },
            ),
          ),
        ],
      ),
    );
  }
}
