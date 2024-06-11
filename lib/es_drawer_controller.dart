/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 21-April-2021
 */

import 'package:flutter/material.dart';

import 'es_app_theme.dart';
import 'es_home_drawer.dart';

enum eDrawerItemType {
  ditDivider,
  ditMenu,
  ditLink,
}

class ESDrawerItem<T> {
  final T index;
  final eDrawerItemType type;
  final String labelName;
  final IconData? iconData;
  final String imageName;

  const ESDrawerItem({
    required this.index,
    required this.type,
    this.iconData,
    this.labelName = '',
    this.imageName = '',
  });
}

class ESDrawerController<T> extends StatefulWidget {
  final double drawerWidth;
  final Function(ESDrawerItem) onDrawerCall;
  final Widget screenView;
  final Function(bool)? drawerIsOpen;
  final AnimatedIconData animatedIconData;
  final Widget? menuView;
  final T screenIndex;
  final String assetLogo;
  final String? title;
  final String? subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;
  final List<ESDrawerItem> drawerList;

  ESDrawerController({
    required this.onDrawerCall,
    required this.screenView,
    required this.screenIndex,
    required this.drawerList,
    this.menuView,
    this.drawerIsOpen,
    this.animatedIconData = AnimatedIcons.arrow_menu,
    this.drawerWidth = 250,
    this.assetLogo = '',
    this.title = '',
    this.subTitle = '',
    this.titleStyle = const TextStyle(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
        color: ESAppTheme.grey,
        fontSize: 18),
    this.subTitleStyle = const TextStyle(
        decoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
        color: ESAppTheme.grey,
        fontSize: 12),
    Key? key,
  }) : super(key: key);

  @override
  _ESDrawerControllerState<T> createState() => _ESDrawerControllerState<T>();
}

class _ESDrawerControllerState<T> extends State<ESDrawerController>
    with TickerProviderStateMixin {
  double scrolloffset = 0.0;

  late final ScrollController scrollController;
  late final AnimationController animationController;
  late final AnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    iconAnimationController =
        AnimationController(vsync: this, duration: const Duration());
    iconAnimationController.animateTo(1.0,
        duration: const Duration(), curve: Curves.fastOutSlowIn);
    scrollController =
        ScrollController(initialScrollOffset: widget.drawerWidth);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        if (scrolloffset != 1.0) {
          if (mounted) {
            setState(() {
              scrolloffset = 1.0;
              try {
                final Function(bool)? function = widget.drawerIsOpen;
                if (function != null) function(true);
              } catch (_) {}
            });
          }
        }
        iconAnimationController.animateTo(0.0,
            duration: const Duration(), curve: Curves.fastOutSlowIn);
      } else if (scrollController.offset < widget.drawerWidth.floor()) {
        iconAnimationController.animateTo(
            (scrollController.offset * 100 / (widget.drawerWidth)) / 100,
            duration: const Duration(),
            curve: Curves.fastOutSlowIn);
      } else {
        if (scrolloffset != 0.0) {
          if (mounted) {
            setState(() {
              scrolloffset = 0.0;
              try {
                final Function(bool)? function = widget.drawerIsOpen;
                if (function != null) function(false);
              } catch (_) {}
            });
          }
        }
        iconAnimationController.animateTo(1.0,
            duration: const Duration(), curve: Curves.fastOutSlowIn);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => getInitState());
  }

  @override
  void dispose() {
    scrollController.dispose();
    animationController.dispose();
    iconAnimationController.dispose();
    super.dispose();
  }

  Future<bool> getInitState() async {
    scrollController.jumpTo(widget.drawerWidth);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ESAppTheme.white,
      child: SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width + widget.drawerWidth,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: widget.drawerWidth,
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: iconAnimationController,
                  builder: (BuildContext context, _) {
                    return Transform(
                      transform: Matrix4.translationValues(
                          scrollController.offset, 0.0, 0.0),
                      child: ESDrawer<T>(
                        assetLogo: widget.assetLogo,
                        title: widget.title,
                        subTitle: widget.subTitle,
                        titleStyle: widget.titleStyle,
                        subTitleStyle: widget.subTitleStyle,
                        drawerList: widget.drawerList,
                        screenIndex: widget.screenIndex,
                        iconAnimationController: iconAnimationController,
                        callBackItem: (drawItem) {
                          onDrawerClick();
                          try {
                            if (drawItem != null) widget.onDrawerCall(drawItem);
                          } catch (e) {
                            debugPrint('drawer_user_controller?.dart: $e');
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Container(
                  decoration: BoxDecoration(
                    color: ESAppTheme.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: ESAppTheme.grey.withOpacity(0.6),
                          blurRadius: 24),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      IgnorePointer(
                        ignoring: scrolloffset == 1 || false,
                        child: widget.screenView,
                      ),
                      if (scrolloffset == 1.0)
                        GestureDetector(onTap: () => onDrawerClick()),
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 8,
                            left: 8),
                        child: SizedBox(
                          width: AppBar().preferredSize.height - 8,
                          height: AppBar().preferredSize.height - 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                  AppBar().preferredSize.height),
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                onDrawerClick();
                              },
                              child: Center(
                                // if you use your own menu view UI you add form initialization
                                child: widget.menuView ??
                                    AnimatedIcon(
                                        icon: widget.animatedIconData,
                                        progress: iconAnimationController),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDrawerClick() {
    if (scrollController.offset != 0.0) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController.animateTo(
        widget.drawerWidth,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}
