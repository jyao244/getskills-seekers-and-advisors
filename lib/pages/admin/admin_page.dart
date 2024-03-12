import 'package:SeekersAndAdvisors/daos/auth_methods.dart';
import 'package:SeekersAndAdvisors/pages/login/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/daos/admin_methods.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final Stream<QuerySnapshot> _applicationStrem =
      FirebaseFirestore.instance.collection('advisorApplications').snapshots();

  @override
  void initState() {
    super.initState();
  }

  renderCards() {
    return StreamBuilder<QuerySnapshot>(
        stream: _applicationStrem,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Column(
            children: snapshot.data!.docs.map((app) {
              return Container(
                child: Card(
                  key: const ValueKey('card'),
                  child: ListTile(
                    title: Text(app['name']),
                    subtitle: Text(app['category'] + "\n" + app['supplyInfo']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 53, 99, 233),
                          ),
                          child: const Icon(Icons.approval),
                          onPressed: () {
                            handleApplication(
                                app.id, app['name'], app['category'], true);
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 53, 99, 233),
                          ),
                          child: const Icon(Icons.delete),
                          onPressed: () {
                            handleApplication(
                                app.id, app['name'], app['category'], false);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        });
  }

  handleApplication(
      String id, String name, String category, bool isApproved) async {
    if (isApproved) {
      AdminMethods()
          .approveApplication(uid: id, name: name, category: category);
    } else {
      AdminMethods().rejectApplication(uid: id, name: name, category: category);
    }
  }

  void signOut() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text("Are you sure you want to sign out?"),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              // setState(() {
              //   _isLoading = true;
              // });
              await AuthMethods().signOut(context);
              setState(() {
                // _isLoading = false;
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              });
            },
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, 'No');
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        backgroundColor: const Color.fromARGB(255, 53, 99, 233),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(238, 238, 238, 238),
          padding: const EdgeInsets.all(10),
          child: renderCards(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.logout),
        onPressed: () {
          signOut();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class Application {
  String name, category, supplyInfo;
  Application(
      {required this.name, required this.category, required this.supplyInfo});
}
