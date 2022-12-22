import 'index.dart';
import 'package:flutter/material.dart';

/// A Scaffold with a configured BottomNavigationBar, separate
/// Navigators for each tab view and state retaining across tab switches.
class MyWidgetMaterialBottomNavigationScaffold extends StatefulWidget {
  const MyWidgetMaterialBottomNavigationScaffold({
    required this.navigationBarItems,
    required this.onItemSelected,
    required this.selectedIndex,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    Key? key,
    this.customBottomBar,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    this.backgroundColor,
    this.padding,
    this.decoration,
    this.customBottomBarBehind,
    this.elevation = 1,
    this.extendBody = false,
    this.showSelectedLabels = true,
    this.showUnselectedLabels = true,
  }) : super(key: key);

  /// List of the tabs to be displayed with their respective navigator's keys.
  final List<MyWidgetBottomNavigationTab> navigationBarItems;

  /// Called when a tab selection occurs.
  final ValueChanged<int> onItemSelected;

  final TextStyle selectedLabelStyle, unselectedLabelStyle;

  final int selectedIndex;

  final Widget? customBottomBar;
  final Widget? customBottomBarBehind;
  final double elevation;

  final EdgeInsets? padding;
  final Color selectedItemColor, unselectedItemColor;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  final bool extendBody;
  final bool showSelectedLabels, showUnselectedLabels;

  @override
  _MaterialBottomNavigationScaffoldState createState() =>
      _MaterialBottomNavigationScaffoldState();
}

class _MaterialBottomNavigationScaffoldState
    extends State<MyWidgetMaterialBottomNavigationScaffold>
    with TickerProviderStateMixin<MyWidgetMaterialBottomNavigationScaffold> {
  final List<_MaterialBottomNavigationTab> materialNavigationBarItems = [];
  final List<AnimationController> _animationControllers = [];

  /// Controls which tabs should have its content built. This enables us to
  /// lazy instantiate it.
  final List<bool> _shouldBuildTab = <bool>[];

  @override
  void initState() {
    _initAnimationControllers();
    _initMaterialNavigationBarItems();

    _shouldBuildTab.addAll(List<bool>.filled(
      widget.navigationBarItems.length,
      false,
    ));

    super.initState();
  }

  void _initMaterialNavigationBarItems() {
    materialNavigationBarItems.addAll(
      widget.navigationBarItems
          .map(
            (barItem) => _MaterialBottomNavigationTab(
              bottomNavigationBarItem: barItem.bottomNavigationBarItem,
              navigatorKey: barItem.navigatorKey,
              subtreeKey: GlobalKey(),
              initialPageBuilder: barItem.initialPageBuilder,
            ),
          )
          .toList(),
    );
  }

  void _initAnimationControllers() {
    _animationControllers.addAll(
      widget.navigationBarItems.map<AnimationController>(
        (destination) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );

    if (_animationControllers.isNotEmpty) {
      _animationControllers[0].value = 1.0;
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: widget.extendBody,
        // The Stack is what allows us to retain state across tab
        // switches by keeping all of our views in the widget tree.
        body: Stack(
          fit: StackFit.expand,
          children: materialNavigationBarItems
              .map(
                (barItem) => _buildPageFlow(
                  context,
                  materialNavigationBarItems.indexOf(barItem),
                  barItem,
                ),
              )
              .toList(),
        ),
        bottomNavigationBar: Container(
            padding: widget.padding,
            color: widget.backgroundColor,
            child: Stack(
              children: [
                if (widget.customBottomBarBehind != null)
                  widget.customBottomBarBehind!,
                BottomNavigationBar(
                  showSelectedLabels: widget.showSelectedLabels,
                  showUnselectedLabels: widget.showUnselectedLabels,
                  backgroundColor: widget.backgroundColor,
                  currentIndex: widget.selectedIndex,
                  elevation: widget.elevation,
                  items: materialNavigationBarItems
                      .map(
                        (item) => item.bottomNavigationBarItem,
                      )
                      .toList(),
                  onTap: widget.onItemSelected,
                  type: BottomNavigationBarType.fixed,
                  selectedLabelStyle: widget.selectedLabelStyle,
                  unselectedLabelStyle: widget.unselectedLabelStyle,
                  selectedItemColor: widget.selectedItemColor,
                  unselectedItemColor: widget.unselectedItemColor,
                ),
                if (widget.customBottomBar != null) widget.customBottomBar!,
              ],
            )),
      );

  // The best practice here would be to extract this to another Widget,
  // however, moving it to a separate class would only harm the
  // readability of our guide.
  Widget _buildPageFlow(
    BuildContext context,
    int tabIndex,
    _MaterialBottomNavigationTab item,
  ) {
    final isCurrentlySelected = tabIndex == widget.selectedIndex;

    // We should build the tab content only if it was already built or
    // if it is currently selected.
    _shouldBuildTab[tabIndex] =
        isCurrentlySelected || _shouldBuildTab[tabIndex];

    final Widget view = FadeTransition(
      opacity: _animationControllers[tabIndex].drive(
        CurveTween(curve: Curves.fastOutSlowIn),
      ),
      child: KeyedSubtree(
        key: item.subtreeKey,
        child: _shouldBuildTab[tabIndex]
            ? Navigator(
                // The key enables us to access the Navigator's state inside the
                // onWillPop callback and for emptying its stack when a tab is
                // re-selected. That is why a GlobalKey is needed instead of
                // a simpler ValueKey.
                key: item.navigatorKey,
                // Since this isn't the purpose of this sample, we're not using
                // named routes. Because of that, the onGenerateRoute callback
                // will be called only for the initial route.
                onGenerateRoute: (settings) => MaterialPageRoute(
                  settings: settings,
                  builder: item.initialPageBuilder,
                ),
              )
            : Container(),
      ),
    );

    if (tabIndex == widget.selectedIndex) {
      _animationControllers[tabIndex].forward();
      return view;
    } else {
      _animationControllers[tabIndex].reverse();
      if (_animationControllers[tabIndex].isAnimating) {
        return IgnorePointer(child: view);
      }
      return Offstage(child: view);
    }
  }
}

/// Extension class of BottomNavigationTab that adds another GlobalKey to it
/// in order to use it within the KeyedSubtree widget.
class _MaterialBottomNavigationTab extends MyWidgetBottomNavigationTab {
  const _MaterialBottomNavigationTab({
    required BottomNavigationBarItem bottomNavigationBarItem,
    required GlobalKey<NavigatorState> navigatorKey,
    required WidgetBuilder initialPageBuilder,
    required this.subtreeKey,
  }) : super(
          bottomNavigationBarItem: bottomNavigationBarItem,
          navigatorKey: navigatorKey,
          initialPageBuilder: initialPageBuilder,
        );

  final GlobalKey subtreeKey;
}
