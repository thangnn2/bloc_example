import 'dart:ui';

enum SliderState { initial, open, close, slidingUp, slidingDown, max }

class SliderValue {
  final SliderState state;
  final double factor;

  SliderValue({
    this.state = SliderState.initial,
    this.factor = 0.0,
  });

  SliderValue copyWith(
      {SliderState? state, double? offset, double? factor, Offset? position}) {
    return SliderValue(
      state: state ?? this.state,
      factor: factor ?? this.factor,
    );
  }
}
