part of 'timer_bloc.dart';

abstract class TimerState {
  final int ticks;
  TimerState({required this.ticks});
}

class TimerInitial extends TimerState {
  TimerInitial({required super.ticks});
}

class RunningState extends TimerState {
  RunningState({required super.ticks});
}

class PauseState extends TimerState {
  PauseState({required super.ticks});
}

class ReplayState extends TimerState {
  ReplayState({required super.ticks});
}
