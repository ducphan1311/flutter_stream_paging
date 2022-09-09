# Flutter Stream Paging

<p align="center">

  <a href="https://pub.dartlang.org/packages/flutter_stream_paging">
    <img alt="Pub Package" src="https://img.shields.io/pub/v/flutter_stream_paging.svg">
  </a>
  <br/>
  <a href="https://github.com/tenhobi/effective_dart">
    <img alt="style: effective dart" src="https://img.shields.io/badge/style-effective_dart-40c4ff.svg">
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
  </a>
</p>

---
A Flutter package that supports pagination(load infinite) for ListView, GridView

### Demo

|   |   |
|---|---|
| <img src="https://raw.githubusercontent.com/ducphan1311/flutter_stream_paging/main/demo/list_view.gif" alt="Example Project" /> | <img src="https://raw.githubusercontent.com/ducphan1311/flutter_stream_paging/main/demo/grid_view.gif" alt="Example Project" /> |

### DataSource

To create a `PagingListView` or `PagingGridView` you will need create class which extended from `DataSource`.

When extended from `DataSource`, you will need `override` 2 methods is `loadInitial` and `loadPageAfter`.

Output of those function is a Tuple2 with item1 is List<ItemType> is List of data, end item2 is next page index.

Example: if your list start with page index is 0.
-> on loadInitial output is Tuple2([...], 1) 1 is next page when load more item.

Example:

```
class ListViewDataSource extends DataSource<int, Note> {
  NoteRepository noteRepository;

  ListViewDataSource(this.noteRepository);

  @override
  FutureOr<Tuple2<List<Note>, int>> loadInitial(int pageSize) async {
    return Tuple2(await noteRepository.getNotes(0), 1);
  }

  @override
  FutureOr<Tuple2<List<Note>, int>> loadPageAfter(int params, int pageSize) async {
    if (params == 4) {
      return Tuple2([], params + 1);
    } else {
      return Tuple2(await noteRepository.getNotes(params), params + 1);
    }
  }
}
```

### Display on UI

To display on UI, currently you can use `PagingListView` or `PagingGridView`.

Example:
```
      ListViewDataSource dataSource = ListViewDataSource(NoteRepository());

      PagingListView<int, Note>.separated(
      key: key,
      builderDelegate: PagedChildBuilderDelegate<Note>(itemBuilder: (context, data, child) {
        return NoteWidget(data);
      },),
      pageDataSource: dataSource,
      separatorBuilder: (_, index) => const SizedBox(height: 20,),
    ),

```

