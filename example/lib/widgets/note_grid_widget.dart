import 'package:flutter/material.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';

class NoteGridWidget extends StatelessWidget {
  final Note note;

  const NoteGridWidget(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          color: Theme.of(context).cardColor),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            note.content,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
