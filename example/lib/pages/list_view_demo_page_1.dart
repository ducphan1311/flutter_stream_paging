import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/fl_stream_paging.dart';
import 'package:flutter_stream_paging_example/datasource/list_view_page.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';
import 'package:flutter_stream_paging_example/datasource/note_repository.dart';
import 'package:flutter_stream_paging_example/widgets/note_widget.dart';

class ListViewDemoPage1 extends StatefulWidget {
  const ListViewDemoPage1({super.key});

  @override
  ListViewDemoPage1State createState() => ListViewDemoPage1State();
}

class ListViewDemoPage1State extends State<ListViewDemoPage1> {
  final GlobalKey key = GlobalKey();
  late ListViewDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = ListViewDataSource(NoteRepository());
  }

  @override
  Widget build(BuildContext context) {
    return PagingListView2<int, Note>.separated(
      key: key,
      // padding: EdgeInsets.all(16),
      builderDelegate: PagedChildBuilderDelegate<Note>(itemBuilder: (context, data, child) {
        return NoteWidget(data);
      },),
      pageDataSource: dataSource,
      separatorBuilder: (_, index) => const SizedBox(height: 20,),
    );
  }
}