import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';

/*
* Author：Leon
* Description：Widget for showing and editing profession in seeker profile page.
* Date: 22/11/24
*/
class FavouriteCharity extends StatefulWidget {
  const FavouriteCharity({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouriteCharity> createState() => _FavouriteCharityState();
}

class _FavouriteCharityState extends State<FavouriteCharity> {
  late AppUser user;
  final TextEditingController _charityController = TextEditingController();

  @override
  void dispose() {
    _charityController.dispose();
    super.dispose();
  }

// Show editor dialog
  Future<void> _updateCharity() async {
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
                controller: _charityController,
                autofocus: true,
                maxLines: null,
                decoration:
                    const InputDecoration(labelText: 'Favourite Charity'),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: const Text('Update'),
                onPressed: () {
                  String charity = _charityController.text;
                  updateAdvisorProfile('favourite_charity', charity)
                      .then((value) => user.setAdvisor());
                  _charityController.text = '';
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
              "Favourite Charity",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _updateCharity();
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
                  appUser.advisor!.favouriteCharity!,
              builder: (context, charity, child) {
                return Text(charity);
              },
            ),
          ),
        ],
      ),
    );
  }
}
