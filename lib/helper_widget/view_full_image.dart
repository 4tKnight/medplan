import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ViewFullImage extends StatefulWidget {
  String url='';
  String hero;
  File? fileImage;
  ViewFullImage(this.url, this.hero, {this.fileImage, Key? key}) : super(key: key);

  @override
  State<ViewFullImage> createState() => _ViewFullImageState();
}

class _ViewFullImageState extends State<ViewFullImage> with SingleTickerProviderStateMixin{

  AnimationController? _animationController;
  Animation<Matrix4>? _animation;

  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails = TapDownDetails();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          child: Hero(
            tag: widget.hero,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
              alignment: Alignment.topCenter,
              child: widget.fileImage==null?
              CachedNetworkImage(
                imageUrl: widget.url,
                fit: BoxFit.contain,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                  width: double.maxFinite,
                  height: 120,
                  color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.error, size: 150),
                ),
              ) : Image.file(widget.fileImage!)
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    )..addListener(() {
        _transformationController.value = _animation!.value;
      });
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    Matrix4 _endMatrix;
    Offset _position = _doubleTapDetails.localPosition;

    if (_transformationController.value != Matrix4.identity()) {
      _endMatrix = Matrix4.identity();
    } else {
      _endMatrix = Matrix4.identity()
        ..translate(-_position.dx * 2, -_position.dy * 2)
        ..scale(3.0);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: _endMatrix,
    ).animate(
      CurveTween(curve: Curves.easeOut).animate(_animationController!),
    );
    _animationController!.forward(from: 0);
  }
// void _handleDoubleTapDown(TapDownDetails details) {
//   _doubleTapDetails = details;
// }


}
