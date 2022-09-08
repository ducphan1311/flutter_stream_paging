import 'package:flutter/material.dart';
import 'package:flutter_stream_paging_example/datasource/models/note.dart';

class NoteWidget extends StatelessWidget {
  final Note note;

  const NoteWidget(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
        color: Theme.of(context).cardColor
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            child: Text('${note.id}'),
          ),
          const SizedBox(width: 16,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.title, style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w800
                ),),
                const SizedBox(height: 4,),
                Text(note.content, style: Theme.of(context).textTheme.bodyText2,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
