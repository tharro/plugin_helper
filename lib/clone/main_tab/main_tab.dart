// import 'package:bolierplate_mobile/configs/app_text_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:plugin_helper/widgets/bottom_tab_navigator/index.dart';

// class MainTab extends StatefulWidget {
//   const MainTab({Key? key}) : super(key: key);

//   @override
//   State<MainTab> createState() => _MainTabState();
// }

// class _MainTabState extends State<MainTab> {
//   List<WidgetAppFlow>? _appFlows;
//   GlobalKey<AdaptiveBottomNavigationScaffoldState>? _adapterKey;

//   @override
//   void initState() {
//     _adapterKey = GlobalKey<AdaptiveBottomNavigationScaffoldState>();
//     _appFlows = [
//       WidgetAppFlow(
//         title: 'Home',
//         iconData: const Icon(
//           Icons.camera,
//           color: Colors.grey,
//         ),
//         activeIconData: const Icon(
//           Icons.camera,
//           color: Colors.red,
//         ),
//         navigatorKey: GlobalKey<NavigatorState>(),
//         child: Container(
//           color: Colors.red,
//         ),
//       ),
//       WidgetAppFlow(
//         title: 'Message',
//         iconData: const Icon(
//           Icons.message,
//           color: Colors.grey,
//         ),
//         activeIconData: const Icon(
//           Icons.message,
//           color: Colors.red,
//         ),
//         navigatorKey: GlobalKey<NavigatorState>(),
//         child: Container(
//           color: Colors.yellow,
//         ),
//       ),
//     ];
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdaptiveBottomNavigationScaffold(
//       key: _adapterKey,
//       navigationBarItems: _appFlows!.map((flow) {
//         return WidgetBottomNavigationTab(
//           bottomNavigationBarItem: BottomNavigationBarItem(
//             label: flow.title,
//             icon: flow.iconData,
//             activeIcon: flow.activeIconData,
//             tooltip: '',
//           ),
//           navigatorKey: flow.navigatorKey,
//           initialPageBuilder: (context) => flow.child,
//         );
//       }).toList(),
//       selectedLabelStyle: AppTextStyles.textSize12(color: Colors.green),
//       unselectedLabelStyle: AppTextStyles.textSize12(),
//     );
//   }
// }
