/*
 * Developed by Ajmal Muhammad P
 * Contact me @ support@erratums.com
 * https://erratums.com
 * Date created: 21-April-2021
 */

import 'package:es_drawer_controller/es_drawer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'es_app_theme.dart';

class ESDrawer<T> extends StatefulWidget {
  final String assetLogo;
  final String? title;
  final String? subTitle;
  final List<ESDrawerItem> drawerList;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  const ESDrawer({
    required this.screenIndex,
    required this.iconAnimationController,
    required this.callBackItem,
    required this.drawerList,
    this.assetLogo = '',
    this.title = '',
    this.subTitle = '',
    this.titleStyle,
    this.subTitleStyle,
    Key? key,
  }) : super(key: key);

  final AnimationController iconAnimationController;
  final T screenIndex;
  final Function(ESDrawerItem?) callBackItem;

  @override
  _ESDrawerState<T> createState() => _ESDrawerState<T>();
}

class _ESDrawerState<T> extends State<ESDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ESAppTheme.notWhite.withOpacity(0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _animatedLogo(widget.assetLogo),
                  if (widget.title != null && widget.title!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 4),
                      child: Text(widget.title!, style: widget.titleStyle),
                    ),
                  if (widget.subTitle != null && widget.subTitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 4),
                      child:
                          Text(widget.subTitle!, style: widget.subTitleStyle),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 1),
          Divider(height: 1, color: ESAppTheme.grey.withOpacity(0.6)),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: widget.drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                switch (widget.drawerList[index].type) {
                  case eDrawerItemType.ditDivider:
                    return Divider(
                        height: 1, color: ESAppTheme.grey.withOpacity(0.6));

                  default:
                    return inkwell(widget.drawerList[index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder _animatedLogo(final String assetImage) {
    return AnimatedBuilder(
      animation: widget.iconAnimationController,
      builder: (BuildContext context, _) {
        return ScaleTransition(
          scale: AlwaysStoppedAnimation<double>(
              1.0 - (widget.iconAnimationController.value) * 0.2),
          child: RotationTransition(
            turns: AlwaysStoppedAnimation<double>(
                Tween<double>(begin: 0.0, end: 96.0)
                        .animate(CurvedAnimation(
                            parent: widget.iconAnimationController,
                            curve: Curves.fastOutSlowIn))
                        .value /
                    180),
            child: Container(
              height: 72,
              width: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: ESAppTheme.grey.withOpacity(0.6),
                      offset: const Offset(2.0, 4.0),
                      blurRadius: 8)
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                child: Image.asset(assetImage),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget inkwell(ESDrawerItem drawerItem) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () => navigationtoScreen(drawerItem),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 6.0, height: 46.0),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  if (drawerItem.imageName.isNotEmpty)
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Image.asset(drawerItem.imageName,
                          color: widget.screenIndex == drawerItem.index
                              ? Colors.blue
                              : ESAppTheme.nearlyBlack),
                    )
                  else
                    Icon(drawerItem.iconData,
                        color: widget.screenIndex == drawerItem.index
                            ? Colors.blue
                            : ESAppTheme.nearlyBlack),
                  const Padding(padding: EdgeInsets.all(4.0)),
                  Text(
                    drawerItem.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == drawerItem.index
                          ? Colors.blue
                          : ESAppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            if (widget.screenIndex == drawerItem.index)
              AnimatedBuilder(
                animation: widget.iconAnimationController,
                builder: (BuildContext context, _) {
                  return Transform(
                    transform: Matrix4.translationValues(
                        (MediaQuery.of(context).size.width * 0.75 - 64) *
                            (1.0 - widget.iconAnimationController.value - 1.0),
                        0.0,
                        0.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.75 - 64,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            else
              const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(ESDrawerItem? item) async =>
      widget.callBackItem(item);
}
