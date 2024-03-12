import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:SeekersAndAdvisors/daos/storage_methods.dart';
import 'package:SeekersAndAdvisors/daos/user_interest_methods.dart';
import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';
import 'package:SeekersAndAdvisors/utils/index.dart';

/*
* Author：Siwei
* Description：Widget for showing and editing avatar in seeker profile page.
* Date: 22/10/12
*/

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late AppUser user;
  late String avatar;
  Uint8List? newAvatar;

  Future<void> _updateAvatar() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                Uint8List im = await pickImage(ImageSource.gallery);
                setState(() {
                  newAvatar = im;
                  Navigator.of(context).pop();
                });

                if (newAvatar != null) {
                  avatar = await StorageMethods()
                      .uploadImageToStorage("avatar", newAvatar!);
                  updateUserProfile('avatar', avatar)
                      .then((value) => user_interest_methods()
                          .saveUserInfo({"avatar": avatar}))
                      .then((value) => user.setAppUser())
                      .then((value) => setState(() {
                            newAvatar = null;
                          }));
                }
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppUser>(context);
    avatar = user.avatar!;
    return GestureDetector(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          alignment: Alignment.center,
          child: newAvatar != null
              ? CircleAvatar(
                  minRadius: 20,
                  maxRadius: 60,
                  backgroundImage: MemoryImage(newAvatar!),
                )
              : InkWell(
                  onTap: _updateAvatar,
                  child: CircleAvatar(
                    minRadius: 20,
                    maxRadius: 60,
                    backgroundImage: NetworkImage(avatar),
                  ),
                ),
        ),
      ),
    );
  }
}
