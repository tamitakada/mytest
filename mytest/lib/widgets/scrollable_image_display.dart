import 'package:flutter/material.dart';
import 'package:mytest/utils/file_utils.dart';
import 'static_loader.dart';
import 'package:mytest/constants.dart';
import 'package:mytest/widgets/error_page.dart';


class ScrollableImageDisplay extends StatelessWidget {

  final List<String> images; // File names
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
            borderRadius: BorderRadius.circular(5)
          ),
          child: Stack(
            children: [
              FutureBuilder<Image?>(
                future: FileUtils.readImageFile(images[index] ?? ""),
                builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                  imageCache.clear();
                  imageCache.clearLiveImages();
                  if (snapshot.hasData) {
                    return snapshot.data ?? const ErrorPage(margin: EdgeInsets.zero);
                  } else {
                    return const SizedBox(
                      width: 160,
                      height: double.infinity,
                      child: StaticLoader(),
                    );
                  }
                }
              ),
              onDelete != null
                ? Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => onDelete!(index),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Constants.salmon.withOpacity(0.5),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Constants.salmon,
                        size: 12,
                      ),
                    ),
                  ),
                )
                : Container()
            ],
          )
        );
      },
    );
  }
}
