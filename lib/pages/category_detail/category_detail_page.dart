import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'widgets/body.dart';

class CategoryDetailPage extends StatelessWidget {
  final int categoryID;
  const CategoryDetailPage({Key? key, required this.categoryID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 53, 99, 233),
          elevation: 0.0,
          centerTitle: true,
          title: Consumer<AppUser>(
            builder: (context, value, child) =>
                Text("${value.categoriesData.Name}"),
          )),
      body: Body(categoryID: this.categoryID),
    );
  }
}
