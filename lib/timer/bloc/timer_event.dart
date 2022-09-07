part of 'timer_bloc.dart';

abstract class TimerEvent {}

class TimerStart extends TimerEvent {
  final int ticks;
  TimerStart({required this.ticks});
}

class PauseTimer extends TimerEvent {}

class ReplayTimer extends TimerEvent {}

class ResumeTimer extends TimerEvent {}

class TimerTicker extends TimerEvent {
  final int ticks;
  TimerTicker({required this.ticks});
}
