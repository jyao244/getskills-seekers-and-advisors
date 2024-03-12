import 'package:flutter/material.dart';

class MessageCard extends StatelessWidget {
  final String title;
  final String message;
  final String imageUrl;
  final String time;
  const MessageCard(
      {Key? key,
      required this.title,
      required this.message,
      required this.imageUrl,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image(
            width: 55,
            height: 55,
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 25),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  maxLines: 2,
                ),
              ]),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(time, style: const TextStyle(color: Colors.grey)),
      ]),
    );
  }
}
