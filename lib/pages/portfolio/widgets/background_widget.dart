import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';

// import 'package:SeekersAndAdvisors/daos/storage_methods.dart';
import 'package:SeekersAndAdvisors/daos/user_interest_methods.dart';
import 'package:SeekersAndAdvisors/daos/user_profile_methods.dart';

import 'package:carousel_slider/carousel_slider.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  late AppUser user;
  late String background;
  // Uint8List? newBackground;

  final backgroundList = <String>[
    'assets/images/BGbackground.png',
    'assets/images/BGbackground1.jpg',
    'assets/images/BGbackground2.jpg'
  ];

  var initialPage = 0;
  late int _currentIndex;
  CarouselController onDemandCarouselController = CarouselController();

  Future<void> _updateBackground() async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SizedBox(
            height: 36,
            width: double.infinity,
            child: ElevatedButton(
              child: const Text('Update'),
              onPressed: () async {
                // final ByteData bytes =
                //     await rootBundle.load(backgroundList[_currentIndex - 1]);
                // print(_currentIndex);
                // Uint8List im = bytes.buffer.asUint8List();

                setState(() {
                  // newBackground = im;
                  Navigator.of(context).pop();
                });

                // if (newBackground != null) {
                //   background = await StorageMethods()
                //       .uploadImageToStorage("background", newBackground!);
                //   updateUserProfile('background', background)
                //       .then((value) => user_interest_methods()
                //           .saveUserInfo({"background": background}))
                //       .then((value) => user.setAppUser())
                //       .then((value) => setState(() {
                //             newBackground = null;
                //           }));
                // }
                updateUserProfile(
                        'background', backgroundList[_currentIndex - 1])
                    .then((value) => user_interest_methods().saveUserInfo(
                        {"background": backgroundList[_currentIndex - 1]}))
                    .then((value) => user.setAppUser());
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    user = Provider.of<AppUser>(context);
    background = user.background!;
    return GestureDetector(
      // onLongPress: () {
      //   final RenderBox overlay =
      //       Overlay.of(context)?.context.findRenderObject() as RenderBox;
      //   showMenu(
      //     context: context,
      //     position: RelativeRect.fromRect(
      //         _tapPosition & const Size(40, 40), // smaller rect, the touch area
      //         Offset.zero & overlay.size // Bigger rect, the entire screen
      //         ),
      //     shape: const RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(4.0))),
      //     items: <PopupMenuEntry>[
      //       const PopupMenuItem<String>(
      //         // padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      //         enabled: true,

      //         child: Text('Change Background Image'),
      //       )
      //     ],
      //   );
      // },

      //https://pub.dev/packages/carousel_slider
      child: CarouselSlider(
        carouselController: onDemandCarouselController,
        options: CarouselOptions(
          initialPage: initialPage,
          enlargeCenterPage: false,
          autoPlay: false,
          // aspectRatio: 16 / 9,
          height: size.height * 0.20,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          viewportFraction: 1,
          onPageChanged: (index, reason) {
            _currentIndex = index;

            _updateBackground();
            setState(() {});
          },
        ),
        items: [
          Container(
            // margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                // image: NetworkImage(background),
                image: AssetImage(background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('assets/images/BGbackground.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('assets/images/BGbackground1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('assets/images/BGbackground2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
