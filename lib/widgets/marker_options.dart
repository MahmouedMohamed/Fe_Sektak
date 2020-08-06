import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class MarkerIcon {
  BitmapDescriptor markerIcon;
  MarkerIcon() {
    createMarkerImageFromAsset();
  }
  BitmapDescriptor getIcon() {
    return markerIcon;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  createMarkerImageFromAsset() async {
    final Uint8List loadedIcon =
        await getBytesFromAsset('assets/images/travel-transport-hotel-vacation-holidays-tourist-tourism-travelling-traveling_54-512.png', 100);
    if (markerIcon == null) {
      updateBitmap(BitmapDescriptor.fromBytes(loadedIcon));
    }
  }

  void updateBitmap(BitmapDescriptor bitmap) {
    markerIcon = bitmap;
  }
}
