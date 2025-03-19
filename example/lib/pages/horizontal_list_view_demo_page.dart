import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/ui/paging_list_view.dart';
import 'package:flutter_stream_paging/utils/paged_child_builder_delegate.dart';

import '../datasource/list_view_page.dart';
import '../datasource/models/note.dart';
import '../datasource/note_repository.dart';
import '../widgets/note_widget.dart';

class HorizontalListViewDemoPage extends StatefulWidget {
  static const path = '/horizontal_list_view_demo_page';
  const HorizontalListViewDemoPage({Key? key}) : super(key: key);

  @override
  State<HorizontalListViewDemoPage> createState() => _HorizontalListViewDemoPageState();
}

class _HorizontalListViewDemoPageState extends State<HorizontalListViewDemoPage> {
  final GlobalKey key = GlobalKey();
  late ListViewDataSource dataSource;
  bool isExtend = false;
  @override
  void initState() {
    super.initState();
    dataSource = ListViewDataSource(NoteRepository());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: PagingListView<int, Note>.separated(
        key: key,
        builderDelegate: PagedChildBuilderDelegate<Note>(
          itemBuilder: (context, data, child, onUpdate, onDelete, dataList) {
            return Column(
              children: [
                Container(width: 100, height: 100, color: Colors.red,),
              ],
            );
          },
        ),
        scrollDirection: Axis.horizontal,
        pageDataSource: dataSource,
        separatorBuilder: (_, index, item, items) {
          return const SizedBox(
            width: 20,
          );
        },
        padding: EdgeInsets.symmetric(horizontal: 16),
        errorBuilder: (_, err) => const SizedBox(),
        invisibleItemsThreshold: 1, // padding: EdgeInsets.only(top: 30),
      ),
    );
  }
}
