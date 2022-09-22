import 'package:flutter/material.dart';
import 'package:flutter_stream_paging/fl_stream_paging.dart';
import 'package:flutter_stream_paging_example/datasource/list_view_page.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';
import 'package:flutter_stream_paging_example/datasource/note_repository.dart';
import 'package:flutter_stream_paging_example/widgets/note_widget.dart';

class GridViewDemoPage extends StatefulWidget {
  const GridViewDemoPage({super.key});

  @override
  GridViewDemoPageState createState() => GridViewDemoPageState();
}

class GridViewDemoPageState extends State<GridViewDemoPage> {
  final GlobalKey key = GlobalKey();
  late ListViewDataSource dataSource;
  @override
  void initState() {
    super.initState();
    dataSource = ListViewDataSource(NoteRepository());
  }

  @override
  Widget build(BuildContext context) {
    return PagingGridView<int, Note>(
        builderDelegate: PagedChildBuilderDelegate<Note>(
          itemBuilder: (context, data, child, onUpdate, onDelete) {
            return NoteWidget(data);
          },
        ),
        pageDataSource: dataSource,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 100 / 150,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
        ));
  }
}
