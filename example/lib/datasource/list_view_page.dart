import 'dart:async';

import 'package:flutter_stream_paging/data_source/data_source.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';
import 'package:flutter_stream_paging_example/datasource/note_repository.dart';
import 'package:tuple/tuple.dart';

class ListViewDataSource extends DataSource<int, Note> {
  NoteRepository noteRepository;

  ListViewDataSource(this.noteRepository);

  @override
  Future<Tuple2<List<Note>, int>> loadInitial(int pageSize) async {
    return Tuple2(await noteRepository.getNotes(0), 1);
  }

  @override
  Future<Tuple2<List<Note>, int>> loadPageAfter(
      int params, int pageSize) async {
    if (params == 4) {
      return Tuple2([], params + 1);
    } else {
      return Tuple2(await noteRepository.getNotes(params), params + 1);
    }
  }
}
