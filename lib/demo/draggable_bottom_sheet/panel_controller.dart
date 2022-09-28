import 'package:bloc_example/demo/draggable_bottom_sheet/slider.dart';
import 'package:flutter/cupertino.dart';

class PanelController extends ValueNotifier<SliderValue> {
  PanelController(
      {ScrollController? scrollController,
      ValueNotifier<bool>? panelVisibility})
      : _scrollController = scrollController ?? ScrollController(),
        _panelVisibility = panelVisibility ?? ValueNotifier<bool>(false),
        super(SliderValue());

  final ScrollController _scrollController;
  final ValueNotifier<bool> _panelVisibility;

  ScrollController get scrollController => _scrollController;

  ValueNotifier<bool> get panelVisibility => _panelVisibility;

  bool get isVisible => _panelVisibility.value;

  void openPanel() {
    value = value.copyWith(
      position: Offset.zero,
      factor: 0.0,
      state: SliderState.initial,
      offset: 0.0,
    );
    _panelVisibility.value = true;
  }

  void closePanel() {
    value = value.copyWith(
      position: Offset.zero,
      factor: 0.0,
      state: SliderState.close,
      offset: 0.0,
    );
    _panelVisibility.value = false;
  }

  void attach(SliderValue sliderValue) {
    value = sliderValue.copyWith(
      state: sliderValue.state,
      factor: sliderValue.factor,
    );
  }

  @override
  set value(SliderValue newValue) {
    super.value = newValue;
  }

  @override
  void dispose() {
    if (_panelVisibility.hasListeners) _panelVisibility.dispose();
    if (_scrollController.hasListeners) _scrollController.dispose();
    super.dispose();
  }
}
