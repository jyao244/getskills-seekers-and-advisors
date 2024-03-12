import 'package:flutter/material.dart';
import 'package:SeekersAndAdvisors/pages/category_detail/widgets/post_cards.dart';
import 'package:SeekersAndAdvisors/utils/size_config.dart';

import 'package:SeekersAndAdvisors/models/app_user.dart';
import 'package:provider/provider.dart';
import 'advisor_cards.dart';

class Body extends StatefulWidget {
  final int categoryID;
  const Body({Key? key, required this.categoryID}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    final List<String> tabs = <String>['Materials', 'Advisors'];

    return Consumer<AppUser>(
      builder: (BuildContext context, data, Widget? child) {
        return DefaultTabController(
          length: tabs.length, // This is the number of tabs.
          child: Scaffold(
            body: NestedScrollView(
              // floatHeaderSlivers: true,

              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // These are the slivers that show up in the "outer" scroll view.
                return <Widget>[
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                    sliver: SliverAppBar(
                      // pinned: true,
                      // floating: true,
                      // snap: true,
                      backgroundColor: Colors.white70,
                      automaticallyImplyLeading: false,
                      expandedHeight: 360.0,

                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: const <StretchMode>[
                          StretchMode.zoomBackground,
                          StretchMode.blurBackground,
                          StretchMode.fadeTitle,
                        ],
                        background: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            children: <Widget>[
                              const Positioned.fill(
                                child: Image(
                                  image: AssetImage(
                                      'assets/images/BGbackground.png'),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        getProportionateScreenWidth(20)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: getProportionateScreenHeight(50),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text.rich(
                                        TextSpan(
                                          style: const TextStyle(
                                              color: Colors.white),
                                          children: [
                                            // TextSpan(text: "${data.categoriesData.Name}\n"),
                                            TextSpan(
                                              text:
                                                  "${data.categoriesData.intro}",
                                              // text: "Mathematics are the result of mysterious powers which no one understands, and which the unconscious recognition of beauty must play an important part. Out of an infinity of designs a mathematician chooses one pattern for beauty’s sake and pulls it down to earth. — David Hilbert, German mathematician",
                                              style: TextStyle(
                                                fontSize:
                                                    getProportionateScreenWidth(
                                                        18),
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(40),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      forceElevated: innerBoxIsScrolled,
                      bottom: TabBar(
                        controller: _tabController,
                        tabs:
                            tabs.map((String name) => Tab(text: name)).toList(),
                      ),
                    ),
                  ),
                ];
              },

              body: OverflowBox(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    PostCards(
                      categoryID: widget.categoryID,
                    ),
                    AdvisorCards(category: data.categoriesData.Name!),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
