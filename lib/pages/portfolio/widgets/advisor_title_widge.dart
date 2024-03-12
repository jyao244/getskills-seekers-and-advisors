import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';

/*
* Author：Leon
* Description：Widget for showing and editing title in advisor profile page.
* Date: 22/10/2
*/
class AdvisorTitleWidget extends StatefulWidget {
  const AdvisorTitleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AdvisorTitleWidget> createState() => _AdvisorTitleWidgetState();
}

class _AdvisorTitleWidgetState extends State<AdvisorTitleWidget> {
  late AppUser user;
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _updateTitle() async {
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
                  controller: _titleController,
                  autofocus: true,
                  maxLines: null,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () {
                    String title = _titleController.text;
                    updateAdvisorProfile('title', title)
                        .then((value) => user.setAdvisor());
                    _titleController.text = '';
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
              "Title",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _updateTitle();
                // print(_bio);
              },
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(user.advisor!.title)),
        ],
      ),
    );
  }
}
