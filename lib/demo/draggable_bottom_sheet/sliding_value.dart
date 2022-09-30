enum SlidingState { initial, min, max, slidingDown, slidingUp, close, sliding }

class SlidingValue {
  final SlidingState slidingState;
  final double factor;

  SlidingValue({
    this.slidingState = SlidingState.initial,
    this.factor = 0.0,
  });

  SlidingValue copyWith({
    SlidingState? slidingState,
    double? factor,
  }) {
    return SlidingValue(
      factor: factor ?? this.factor,
      slidingState: slidingState ?? this.slidingState,
    );
  }
}
