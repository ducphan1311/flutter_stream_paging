import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/fl_stream_paging.dart';
import 'package:flutter_stream_paging_example/datasource/list_view_page.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';
import 'package:flutter_stream_paging_example/datasource/note_repository.dart';
import 'package:flutter_stream_paging_example/widgets/note_widget.dart';

class ListViewDemoPage extends StatefulWidget {
  const ListViewDemoPage({super.key});

  @override
  ListViewDemoPageState createState() => ListViewDemoPageState();
}

class ListViewDemoPageState extends State<ListViewDemoPage> {
  final GlobalKey key = GlobalKey();
  late ListViewDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = ListViewDataSource(NoteRepository());
  }

  @override
  Widget build(BuildContext context) {
    return PagingListView<int, Note>.separated(
      key: key,
      builderDelegate: PagedChildBuilderDelegate<Note>(
        itemBuilder: (context, data, child, onUpdate) {
          return NoteWidget(data);
        },
      ),
      pageDataSource: dataSource,
      separatorBuilder: (_, index) => const SizedBox(
        height: 20,
      ),
      errorBuilder: (_, err) => const SizedBox(),
    );
  }
}
