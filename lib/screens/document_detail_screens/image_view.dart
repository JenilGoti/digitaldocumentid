import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  const ImageView(
      {Key? key,
      required this.imageKey,
      required this.image,
      required this.size})
      : super(key: key);
  final String imageKey;
  final Map<String, dynamic> image;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: (MediaQuery.of(context).size.width * size) + 10,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        image[imageKey],
                        fit: BoxFit.fill,
                        height: (MediaQuery.of(context).size.width * size) + 10,
                        width: MediaQuery.of(context).size.width,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColorDark,
                              Theme.of(context).accentColor
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(9),
                              topLeft: Radius.circular(9))),
                      child: Text(
                        imageKey,
                        textScaleFactor: 1.6,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
