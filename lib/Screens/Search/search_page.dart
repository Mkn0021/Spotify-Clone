import 'package:flutter/material.dart';
import 'package:spotify/CustomWidgets/const.dart';
import 'package:spotify/CustomWidgets/section_builder.dart';
import 'package:spotify/CustomWidgets/svg_button.dart';
import 'package:spotify/Screens/Search/search.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({super.key});

  @override
  _SearchPageScreenState createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen>{

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 20, 27),
                  child: Row(
                    children: [
                      GestureDetector(
                    onTap: () {
                      // Open the SettingsPage here
                      Navigator.pushNamed(
                        context,
                        '/setting',
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      backgroundImage: AssetImage('assets/profile_pic.jpg'),
                    ),
                  ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Search',
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Raleway',
                          fontStyle: FontStyle.normal,
                          fontSize: 23.0,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 26,
                      ),
                    ],
                  ),
                ),
              ),
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 56,
                floating: true,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  centerTitle: true,
                  titlePadding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchPage(
                            query: '',
                            fromHome: true,
                            autofocus: true,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 52,
                      decoration:  const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: const Row(
                        children: [
                          SvgIconButton(
                            selectedSVG: 'assets/search_outline.svg',
                            iconSize: 26,
                            selectedColor: Color(0xff191919),
                            unselectedColor: Color(0xff191919),
                          ),
                          Text(
                            'What do you want to listen to?',
                            style: TextStyle(
                              color: Color(0xff535353),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Raleway',
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 18, left: 16, right: 16, bottom: 50,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionBuilder(
                        sectionTitle: 'Browse All',
                        fontSize: 16,
                        padding: EdgeInsets.zero,
                        titlePadding: const EdgeInsets.only(bottom: 18),
                        sectionBodyBuilder: (context) {
                          return SearchSectionItemBuilder(
                            list: kAllSearh,
                          );
                        },
                      ),
                      SectionBuilder(
                        sectionTitle: 'Playlist Added',
                        fontSize: 16,
                        titlePadding: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.only(bottom: 16),
                        sectionBodyBuilder: (context) {
                          return SearchSectionItemBuilder(
                            list: kPlaylistSdded,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}

class SearchSectionItemBuilder extends StatelessWidget {
  const SearchSectionItemBuilder({
    super.key,
    required this.list,
  });

  final List list;

  @override
  Widget build(BuildContext context) {
    final List<Color> sectionColors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.greenAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.yellowAccent,
      Colors.tealAccent,
      Colors.pinkAccent,
      Colors.cyanAccent,
      Colors.indigoAccent,
      Colors.amberAccent,
      Colors.deepOrangeAccent,
    ];
    return SizedBox(
      height: 120 * (list.length ~/ 2).toDouble(),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 11,
        ),
        itemCount: list.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, index) {
          return Container(
            decoration: BoxDecoration(
              color: sectionColors[index%12],
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -15,
                  bottom: -10,
                  child: RotationTransition(
                    turns: const AlwaysStoppedAnimation(25 / 360),
                    child: SizedBox(
                      width: 83,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                        ),
                        child: Image.asset(
                          'assets/album.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 11),
                  child: Text(
                    'Example',
                    style: TextStyle(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Raleway',
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
