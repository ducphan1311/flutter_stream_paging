import 'package:flutter/material.dart';
import 'package:flutter_stream_paging_example/pages/list_view_demo_page_1.dart';
import 'package:flutter_stream_paging_example/pages/list_view_demo_page_2.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedBottomNavigationIndex = 0;

  final List<_BottomNavigationItem> _bottomNavigationItems = [
    _BottomNavigationItem(
      label: 'RefreshPage',
      iconData: Icons.refresh,
      widgetBuilder: (context) => const ListViewDemoPage1(),
    ),
    _BottomNavigationItem(
      label: 'DefaultPage',
      iconData: Icons.list,
      widgetBuilder: (context) => const ListViewDemoPage2(),
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('ListView'),
    ),
    resizeToAvoidBottomInset: false,
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedBottomNavigationIndex,
      items: _bottomNavigationItems
          .map(
            (item) => BottomNavigationBarItem(
          icon: Icon(item.iconData),
          label: item.label,
        ),
      )
          .toList(),
      onTap: (newIndex) => setState(
            () => _selectedBottomNavigationIndex = newIndex,
      ),
    ),
    body: IndexedStack(
      index: _selectedBottomNavigationIndex,
      children: _bottomNavigationItems
          .map(
            (item) => item.widgetBuilder(context),
      )
          .toList(),
    ),
  );
}

class _BottomNavigationItem {
  const _BottomNavigationItem({
    required this.label,
    required this.iconData,
    required this.widgetBuilder,
  });

  final String label;
  final IconData iconData;
  final WidgetBuilder widgetBuilder;
}
