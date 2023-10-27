import 'dart:ui';

import 'package:crm/utils/app_colors.dart';
import 'package:crm/utils/utils.dart';
import 'package:flutter/material.dart';

class AsBottomNav extends StatefulWidget {
  final List<Widget> screens;
  final List<AsNavItem> menuItem;
  EdgeInsets? margin;
  Color? backgroundColor;
  Color? selectedIconColor;
  Color? unselectedIconColor;
  bool? topCoverEnabled;
  BorderRadius? borderRadius;
  double? blur;
  bool? itemHorizontalBouncing;
  Border? border;
  double? axisSpacingItems;
  Curve? curve;
  Duration? animationDuration;
  BoxFit? fitIcon;
  double? iconSize;
  double? height;

  AsBottomNav({
    super.key,
    required this.screens,
    required this.menuItem,
    this.margin,
    this.backgroundColor,
    this.selectedIconColor,
    this.unselectedIconColor,
    this.topCoverEnabled,
    this.borderRadius,
    this.blur,
    this.itemHorizontalBouncing,
    this.border,
    this.axisSpacingItems,
    this.curve,
    this.animationDuration,
    this.fitIcon,
    this.iconSize,
    this.height,
  });

  @override
  AsBottomNavState createState() => AsBottomNavState();
}

class AsBottomNavState extends State<AsBottomNav> {
  var currentIndex = 0;
  int itemCount = 0;

  @override
  void initState() {
    itemCount = widget.screens.length;
    super.initState();
  }

  double delta() {
    // if(getScreenWidth(context)*.01>pow(itemCount,itemCount/2.0).toDouble()){
    //   return pow(itemCount,itemCount/2.0).toDouble();
    // }else{
    //   return 30;
    // }
    if (widget.axisSpacingItems != null) {
      return widget.axisSpacingItems!;
    } else if (itemCount == 2) {
      return 351;
    } else if (itemCount == 3) {
      return isLandscape(context) ? 300 : 370.5;
    } else if (itemCount == 4) {
      return isLandscape(context) ? 327.5 : 382;
    } else if (itemCount == 5) {
      return isLandscape(context) ?341:388;
    } else if (itemCount == 6) {
      return isLandscape(context) ?350.5:392;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.screens[currentIndex],
          Material(
            type: MaterialType.transparency,
            child: Container(
              margin: widget.margin ?? const EdgeInsets.all(16),
              height: widget.height ??
                  (!isLandscape(context)
                      ? getScreenWidth(context)
                      : getScreenHeight(context)) *
                      .155,
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? Colors.black.withOpacity(.1),
                border: widget.border ??
                    Border.all(color: Colors.transparent, width: 0),
                boxShadow: [
                  BoxShadow(
                    color:
                    widget.backgroundColor ?? Colors.black.withOpacity(.15),
                    blurRadius: 4,
                    blurStyle: BlurStyle.inner,
                    offset: const Offset(0, 0),
                  ),
                  BoxShadow(
                    color:
                    widget.backgroundColor ?? Colors.black.withOpacity(.15),
                    blurRadius: 4,
                    blurStyle: BlurStyle.outer,
                    offset: const Offset(0, 0),
                  ),
                ],
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                      borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: widget.blur ?? 4.0,
                            sigmaY: widget.blur ?? 4.0),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: widget.borderRadius ??
                                  BorderRadius.circular(16),
                              color: AppColors.TRANSPARENT),
                          child: const SizedBox(
                            width: 40,
                          ),
                        ),
                      )),
                  ListView.builder(
                    itemCount: itemCount,
                    primary: false,
                    physics: widget.itemHorizontalBouncing ?? false
                        ? const BouncingScrollPhysics()
                        : const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                        horizontal: (!isLandscape(context)
                            ? getScreenWidth(context)
                            : getScreenHeight(context)) *
                            .024),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        setState(
                              () {
                            currentIndex = index;
                          },
                        );
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                                                          duration: widget.animationDuration ??
                                                              const Duration(milliseconds: 1500),
                                                          curve:
                                                          widget.curve ?? Curves.fastLinearToSlowEaseIn,
                                                          margin: EdgeInsets.only(
                                                            bottom: index == currentIndex
                                                                ? 0
                                                                : (!isLandscape(context)
                                                                ? getScreenWidth(context)
                                                                : getScreenHeight(context)) *
                                                                .029,
                                                            right: (((!isLandscape(context)
                                                                ? getScreenWidth(context)
                                                                : getScreenHeight(context))) -
                                                                delta()),
                                                            left: (((!isLandscape(context)
                                                                ? getScreenWidth(context)
                                                                : getScreenHeight(context))) -
                                                                delta()),
                                                          ),
                                                          width: (!isLandscape(context)
                                                              ? getScreenWidth(context)
                                                              : getScreenHeight(context)) -
                                                              delta(),
                                                          height: index == currentIndex
                                                              ? (!isLandscape(context)
                                                              ? getScreenWidth(context)
                                                              : getScreenHeight(context)) *
                                                              .014
                                                              : 0,
                                                          decoration: BoxDecoration(
                                                            color: widget.topCoverEnabled ?? true
                                                                ? (widget.selectedIconColor ?? Colors.blue)
                                                                : Colors.transparent,
                                                            borderRadius: const BorderRadius.vertical(
                                                              bottom: Radius.circular(10),
                                                            ),
                                                          ),
                                                        ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: delta() * .049),
                            child: Image.asset(
                              widget.menuItem[index].assetIcon,
                              height: widget.iconSize ??
                                  (!isLandscape(context)
                                      ? getScreenWidth(context)
                                      : getScreenHeight(context)) *
                                      .076,
                              width: widget.iconSize ??
                                  (!isLandscape(context)
                                      ? getScreenWidth(context)
                                      : getScreenHeight(context)) *
                                      .076,
                              fit: widget.fitIcon ?? BoxFit.cover,
                              color: index == currentIndex
                                  ? widget.selectedIconColor ?? Colors.blue
                                  : widget.unselectedIconColor ??
                                  Colors.black38,
                            ),
                          ),
                          SizedBox(
                            height: (!isLandscape(context)
                                ? getScreenWidth(context)
                                : getScreenHeight(context)) *
                                .03,
                            width: 15,
                          ),
                        ],
                      ),
                    ),
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

class AsNavItem {
  String? label;
  String assetIcon;

  AsNavItem(
      this.label,
      this.assetIcon,
      );

  factory AsNavItem.fromJson(Map<String, dynamic> json) => AsNavItem(
    json["label"] ?? "",
    json["icon"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "icon": assetIcon,
  };
}
