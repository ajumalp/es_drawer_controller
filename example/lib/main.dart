import 'package:es_drawer_controller/es_drawer_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainNavigation(),
    );
  }
}

// Sample home page screen { Ajmal }
class HomePage extends StatelessWidget {
  final String title;
  const HomePage({required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title), centerTitle: true));
}

// 1st you need to add an enumaration to represent your menus in the drawer
enum eDrawerIndex {
  diDivider, // This is to be used when ever you need a divider
  diHome,
  diProfile,
  diShare,
  diRateApp,
  diAboutUS,
}

// Now create a class for Navigation Drawer as below
class MainNavigation extends StatefulWidget {
  // This field is where you need to add your menu items { Ajmal }
  final List<ESDrawerItem> _cDrawerList = <ESDrawerItem>[
    const ESDrawerItem(type: eDrawerItemType.ditMenu, index: eDrawerIndex.diHome, labelName: 'Home', iconData: Icons.home),
    const ESDrawerItem(type: eDrawerItemType.ditMenu, index: eDrawerIndex.diProfile, labelName: 'My Profile', iconData: Icons.person),
    const ESDrawerItem(type: eDrawerItemType.ditDivider, index: eDrawerIndex.diDivider), // Add a divider here
    const ESDrawerItem(type: eDrawerItemType.ditShareLink, index: eDrawerIndex.diShare, labelName: 'Share', iconData: Icons.share, launchURL: 'www.erratums.com'),
    const ESDrawerItem(
      type: eDrawerItemType.ditLink,
      index: eDrawerIndex.diAboutUS,
      labelName: 'About US',
      iconData: Icons.group,
      // Please note: LaunchURL won't work. Can't open in package without activity { Ajmal }
      launchURL: '',
    ),
  ];

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  Widget screenView = HomePage(title: 'Home Page');
  eDrawerIndex drawerIndex = eDrawerIndex.diHome;

  DateTime lastBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ESDrawerController<eDrawerIndex>(
      assetLogo: 'assets/images/ic_launcher.png',
      title: 'Test Application',
      subTitle: 'www.erratums.com',
      screenView: screenView,
      screenIndex: drawerIndex,
      drawerList: widget._cDrawerList,
      drawerWidth: MediaQuery.of(context).size.width * 0.75,
      // When user click on the menu, onDrawerCall is triggered
      onDrawerCall: (ESDrawerItem drawerItem) => _changeIndex(drawerItem),
    );
  }

  void _changeIndex(ESDrawerItem drawerItem) {
    // If user click on the same menu which is not marked as link/share then no need to create the same class again
    if (drawerItem.type == eDrawerItemType.ditMenu && (drawerIndex == drawerItem.index || !mounted)) return;

    // Update new drawer index
    drawerIndex = drawerItem.index;
    switch (drawerIndex) {
      case eDrawerIndex.diHome:
        setState(() => screenView = HomePage(title: 'Home Page'));
        break;
      case eDrawerIndex.diProfile:
        setState(() => screenView = HomePage(title: 'Profile Page'));
        break;

      case eDrawerIndex.diAboutUS:
        setState(() => launch('https://erratums.com'));
        break;

      default:
        break;
    }
  }
}
