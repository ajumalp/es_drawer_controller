/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 23-April-2021
 */

import 'package:flutter/material.dart';
import 'package:es_drawer_controller/es_home_drawer.dart';
import 'package:es_drawer_controller/es_drawer_controller.dart';

import 'homeScreen.dart';

enum eDrawerIndex {
  diDivider,
  diHome,
  diProfile,
  diShare,
  diRateApp,
  diAboutUS,
}

extension eDrawerIndexExtn on eDrawerIndex {
  bool get isSelectable {
    switch (this) {
      case eDrawerIndex.diHome:
      case eDrawerIndex.diProfile:
        return true;

      default:
        return false;
    }
  }
}

class MainNavigation extends StatefulWidget {
  static final List<ESDrawerItem> _cDrawerList = <ESDrawerItem>[
    const ESDrawerItem(type: eDrawerItemType.ditMenu, index: eDrawerIndex.diHome, labelName: 'Home', iconData: Icons.home),
    const ESDrawerItem(type: eDrawerItemType.ditMenu, index: eDrawerIndex.diProfile, labelName: 'My Profile', iconData: Icons.person),
    const ESDrawerItem(type: eDrawerItemType.ditDivider, index: eDrawerIndex.diDivider),
    const ESDrawerItem(type: eDrawerItemType.ditLink, index: eDrawerIndex.diShare, labelName: 'Share', iconData: Icons.share),
    const ESDrawerItem(type: eDrawerItemType.ditLink, index: eDrawerIndex.diRateApp, labelName: 'Rate App', iconData: Icons.star_rate),
    const ESDrawerItem(type: eDrawerItemType.ditLink, index: eDrawerIndex.diAboutUS, labelName: 'About US', iconData: Icons.group),
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
      drawerList: MainNavigation._cDrawerList,
      drawerWidth: MediaQuery.of(context).size.width * 0.75,
      onDrawerCall: (eDrawerIndex drawerIndexdata) => _changeIndex(drawerIndexdata),
    );
  }

  void _changeIndex(eDrawerIndex drawerIndexdata) {
    if (drawerIndex.isSelectable && (drawerIndex == drawerIndexdata || !mounted)) return;

    drawerIndex = drawerIndexdata;
    switch (drawerIndex) {
      case eDrawerIndex.diHome:
        setState(() => screenView = HomePage(title: 'Home Page'));
        break;
      case eDrawerIndex.diProfile:
        setState(() => screenView = HomePage(title: 'Profile Page'));
        break;

      default:
        break;
    }
  }
}
