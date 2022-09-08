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
    final state = this.state;
    if (state is PauseState) {
      add(ResumeTimer());
      return;
    }
    if (state is RunningState) {
      return;
    }
    _streamSubscription?.cancel();
    _streamSubscription = _ticker.tick(ticks: event.ticks).listen((event) {
      add(TimerTicker(ticks: event));
    });
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    final state = this.state;
    if (state is RunningState) {
      _streamSubscription?.pause();
      emit(PauseState(pauseTicks: state.ticks));
    }
  }

  void _onTimerTicker(TimerTicker event, Emitter<TimerState> emit) {
    emit(RunningState(ticks: event.ticks));
  }

  void _onReplayTimer(ReplayTimer event, Emitter<TimerState> emit) {
    _streamSubscription?.cancel();
    emit(TimerInitial());
  }

  void _onResumeTimer(ResumeTimer event, Emitter<TimerState> emit) {
    final state = this.state;
    if (state is RunningState) return;
    if (state is PauseState) {
      _streamSubscription?.resume();
      emit(ResumeState(resumeTicks: state.pauseTicks));
    }
  }

  @override
  Future<void> close() async {
    _streamSubscription?.cancel();
    super.close();
  }
}
