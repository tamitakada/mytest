import 'package:flutter/material.dart';
import 'package:mytest/pair.dart';
import 'package:mytest/utils/file_utils.dart';
import 'dart:io';
import 'static_loader.dart';
import 'dart:async';


class ScrollableImageDisplay extends StatelessWidget {

  final List<Pair<String, bool>> images; // File name, local
  final void Function(int)? onDelete;

  const ScrollableImageDisplay({ super.key, required this.images, this.onDelete });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Stack(
            children: [
              images[index].b
                ? FutureBuilder<Image?>(
                  future: FileUtils.readImageFile(images[index].a ?? ""),
                  builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                    imageCache.clear();
                    imageCache.clearLiveImages();
                    if (snapshot.hasData) {
                      return snapshot.data ?? Text("エラー");
                    } else {
                      return const SizedBox(
                        width: 160,
                        height: double.infinity,
                        child: StaticLoader(),
                      );
                    }
                  }
                )
                : Image.file(
                  File(images[index].a),
                  fit: BoxFit.cover,
                  height: double.infinity
                ),
              onDelete != null ? Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    print('tap');
                    onDelete!(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ) : Container()
            ],
          )
        );
      },
    );
  }
}
