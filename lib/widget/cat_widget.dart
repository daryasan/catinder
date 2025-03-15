import 'package:cached_network_image/cached_network_image.dart';
import 'package:catinder/model/cat.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CatWidget extends StatelessWidget {
  final double height;
  final Cat cat;
  static final double borderWidth = 2;
  static final double borderRadius = 25;
  static final Color borderColor = Color(0xFF232323);
  static final double breedHeight = 60;

  const CatWidget({super.key, required this.height, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 60, 30, 10),
      child: Container(
        height: height,
        width: 500,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius + 1),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _CatImage(height: height, cat: cat),
            ColoredBox(
              color: Color(0xFF232323),
              child: SizedBox(height: borderWidth, width: 500),
            ),
            _Breed(cat: cat),
          ],
        ),
      ),
    );
  }
}

class _CatImage extends StatelessWidget {
  final double height;
  final Cat cat;

  const _CatImage({required this.height, required this.cat});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: cat.image,
      imageBuilder:
          (context, imageProvider) => Container(
            height: height - CatWidget.breedHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(CatWidget.borderRadius - 1),
                topRight: Radius.circular(CatWidget.borderRadius - 1),
              ),
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
      progressIndicatorBuilder:
          (context, url, downloadProgress) =>
              _Loading(height: height - CatWidget.breedHeight),
      errorWidget:
          (context, url, error) =>
              _Error(height: height - CatWidget.breedHeight),
    );
  }
}

class _Error extends StatelessWidget {
  final double height;

  const _Error({required this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/error-cat.svg',
      semanticsLabel: 'loading',
      height: height,
      width: height,
    );
  }
}

class _Loading extends StatelessWidget {
  final double height;

  const _Loading({required this.height});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/loading-cat.svg',
      semanticsLabel: 'loading',
      height: height,
      width: height,
    );
  }
}

class _Breed extends StatelessWidget {
  final Cat cat;

  const _Breed({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        cat.breed,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
