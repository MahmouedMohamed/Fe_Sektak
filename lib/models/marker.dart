import 'package:google_maps_flutter/google_maps_flutter.dart';

class ModifiedMarker {
  Marker marker;

  ModifiedMarker(this.marker);

  Marker getMarker() {
    return marker;
  }

  changeColor() {
    print('Finding Changing color of ${marker.markerId}');
        marker = marker
        .copyWith(iconParam: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
  }

  onMarkerDragEnd(LatLng position) {
    marker = marker.copyWith(
      positionParam: position
    );
  }
}