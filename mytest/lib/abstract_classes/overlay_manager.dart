import 'package:flutter/material.dart';

abstract class OverlayManager {
  void updateOverlay(Widget? overlay);
  void openOverlay();
  void closeOverlay();
  bool isOverlayOpen();
}