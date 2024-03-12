import 'package:SeekersAndAdvisors/utils/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

/*
* Author：Leon
* Description：Widget for showing and editing contact info in seeker and advisor profile page.
* Date: 22/9/16
*/
class ContactWidget extends StatefulWidget {
  const ContactWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ContactWidget> createState() => _ContactWidgetState();
}

class _ContactWidgetState extends State<ContactWidget> {
  late AppUser user;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

// Show contact editor dialog
  Future<void> _updateContact() async {
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextField(
                    controller: _phoneController,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintText:
                          'start with \'+\', no spaces, not begin with \'0\'',
                    ),
                  ),
                  trailing: ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () {
                        String phone = _phoneController.text;
                        if (phone[0] != '+' || phone.length < 10) {
                          // show a popup windows
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                    title:
                                        const Text('Wrong phone number format'),
                                    content: const Text(
                                        "Phone number must start with '+' and has no spaces and no '0' in the beginning"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ));
                          phone = user.phone!;
                        }
                        updateUserProfile('phone', phone).then((value) {
                          user.setAppUser();
                        });
                        _phoneController.text = '';
                        Navigator.of(context).pop();
                      }),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextField(
                    controller: _emailController,
                    maxLines: 1,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      _emailController.text = _emailController.text.trim();
                      String email = _emailController.text;
                      if (!emailValidator(_emailController.text)) {
                        // show a popup windows
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  // content: const Text("Email must be an university email"),
                                  content: const Text("Wrong Email Format"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ));
                        email = user.email!;
                      }
                      updateUserProfile('email', email).then((value) {
                        user.setAppUser();
                      });
                      _emailController.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: TextField(
                    controller: _contactController,
                    maxLines: null,
                    decoration:
                        const InputDecoration(labelText: 'Other Contact'),
                  ),
                  trailing: ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      String contact = _contactController.text;
                      updateUserProfile('Contact_Detail', contact)
                          .then((value) {
                        user.setAppUser();
                      });
                      _contactController.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                ),
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
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              "Contact Details",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            trailing: IconButton(
                onPressed: () {
                  _updateContact();
                },
                icon: const Icon(Icons.edit)),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.phone,
                  ),
                  Text(user.phone!),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(Icons.email_outlined),
                  Text(user.email!),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  const Icon(Icons.contact_page_outlined),
                  Text(
                    user.contactDetail ?? "",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 72, 157, 199)),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
