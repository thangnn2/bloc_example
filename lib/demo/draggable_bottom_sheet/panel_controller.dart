import 'package:bloc_example/demo/draggable_bottom_sheet/sliding_value.dart';
import 'package:flutter/material.dart';

class PanelController extends ValueNotifier<SlidingValue> {
  PanelController(
      {ScrollController? scrollController,
      ValueNotifier<bool>? panelVisibility})
      : _scrollController = scrollController ?? ScrollController(),
        _panelVisibility = ValueNotifier<bool>(false),
        super(SlidingValue());

  final ScrollController _scrollController;
  final ValueNotifier<bool> _panelVisibility;

  ScrollController get scrollController => _scrollController;

  ValueNotifier<bool> get panelVisibility => _panelVisibility;

  bool get isVisible => _panelVisibility.value;

  void openPanel() {
    if (value.slidingState == SlidingState.min) return;
    value = value.copyWith(
      slidingState: SlidingState.initial,
      factor: 0.0,
    );
    _panelVisibility.value = true;
  }

  void closePanel() {
    if (value.slidingState == SlidingState.close) return;
    value = value.copyWith(
      slidingState: SlidingState.close,
      factor: 0.0,
    );
    _panelVisibility.value = false;
  }

  void attach(SlidingValue slidingValue) {
    value = slidingValue.copyWith(
      slidingState: slidingValue.slidingState,
      factor: slidingValue.factor,
    );
    _panelVisibility.value = true;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_panelVisibility.hasListeners) _panelVisibility.dispose();
    if (_scrollController.hasListeners) _scrollController.dispose();
    super.dispose();
  }
}
