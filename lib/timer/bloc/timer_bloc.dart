import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_example/timer/ticker.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial()) {
    on<TimerStart>(_onTimerStart);
    on<PauseTimer>(_onPauseTimer);
    on<ReplayTimer>(_onReplayTimer);
    on<ResumeTimer>(_onResumeTimer);
    on<TimerTicker>(_onTimerTicker);
  }

  final Ticker _ticker;
  StreamSubscription<int>? _streamSubscription;

  void _onTimerStart(TimerStart event, Emitter<TimerState> emit) {
    _streamSubscription?.cancel();
    _streamSubscription = _ticker.tick(ticks: event.ticks).listen((event) {
      add(TimerTicker(ticks: event));
    });
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {}

  void _onTimerTicker(TimerTicker event, Emitter<TimerState> emit) {
    emit(RunningState(ticks: event.ticks));
  }

  void _onReplayTimer(ReplayTimer event, Emitter<TimerState> emit) {}

  void _onResumeTimer(ResumeTimer event, Emitter<TimerState> emit) {}

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    super.close();
  }
}
