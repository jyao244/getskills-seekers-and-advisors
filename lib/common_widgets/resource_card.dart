import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/utils/global_theme.dart';

class ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String number;
  final String imageUrl;
  final Function onTap;
  const ResourceCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.number,
      required this.imageUrl,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.only(right: 20),
        width: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(color: titleColor),
            ),
            Image(
              image: AssetImage(imageUrl),
            ),
            Text(
              number,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
