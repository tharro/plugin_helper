import 'package:flutter/material.dart';

import 'index.dart';

/// A platform-aware Scaffold which encapsulates the common behaviour between
/// material's and cupertino's bottom navigation pattern.
class AdaptiveBottomNavigationScaffold extends StatefulWidget {
  /// List of the tabs to be displayed with their respective navigator's keys.
  final List<MyWidgetBottomNavigationTab> navigationBarItems;
  final TextStyle selectedLabelStyle, unselectedLabelStyle;
  final Widget? customBottomBar;
  final Color selectedItemColor, unselectedItemColor;
  final Function(int)? onTabSelected;
  final List<int>? indexDisableTap;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final Widget? customBottomBarBehind;
  final double elevation;
  final bool extendBody;
  final bool showSelectedLabels, showUnselectedLabels;
  final double? height;

  const AdaptiveBottomNavigationScaffold({
    required this.navigationBarItems,
    Key? key,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    this.customBottomBar,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    this.onTabSelected,
    this.backgroundColor,
    this.padding,
    this.decoration,
    this.customBottomBarBehind,
    this.elevation = 1,
    this.extendBody = false,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
    this.indexDisableTap,
    this.height,
  }) : super(key: key);

  @override
  AdaptiveBottomNavigationScaffoldState createState() =>
      AdaptiveBottomNavigationScaffoldState();
}

class AdaptiveBottomNavigationScaffoldState
    extends State<AdaptiveBottomNavigationScaffold> {
  int _currentlySelectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      // We're preventing the root navigator from popping and closing the app
      // when the back button is pressed and the inner navigator can handle
      // it. That occurs when the inner has more than one page on its stack.
      // You can comment the onWillPop callback and watch "the bug".
      onWillPop: () async => !await widget
          .navigationBarItems[_currentlySelectedIndex]
          .navigatorKey
          .currentState!
          .maybePop(),
      child: _buildMaterial(context));

  Widget _buildMaterial(BuildContext context) =>
      MyWidgetMaterialBottomNavigationScaffold(
        navigationBarItems: widget.navigationBarItems,
        onItemSelected: onTabSelected,
        selectedIndex: _currentlySelectedIndex,
        selectedLabelStyle: widget.selectedLabelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        selectedItemColor: widget.selectedItemColor,
        unselectedItemColor: widget.unselectedItemColor,
        customBottomBar: widget.customBottomBar,
        backgroundColor: widget.backgroundColor,
        padding: widget.padding,
        decoration: widget.decoration,
        customBottomBarBehind: widget.customBottomBarBehind,
        elevation: widget.elevation,
        extendBody: widget.extendBody,
        showSelectedLabels: widget.showSelectedLabels,
        showUnselectedLabels: widget.showUnselectedLabels,
        height: widget.height,
      );

  /// Called when a tab selection occurs.
  void onTabSelected(int newIndex) {
    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.indexDisableTap == null ||
        (widget.indexDisableTap != null &&
            !widget.indexDisableTap!.contains(newIndex))) {
      if (_currentlySelectedIndex == newIndex) {
        // If the user is re-selecting the tab, the common
        // behavior is to empty the stack.
        widget.navigationBarItems[newIndex].navigatorKey.currentState!
            .popUntil((route) => route.isFirst);
      }

      setState(() {
        _currentlySelectedIndex = newIndex;
      });
    }

    if (widget.onTabSelected != null) {
      widget.onTabSelected!(newIndex);
    }
  }
}
