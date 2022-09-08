import 'package:bloc_example/timer/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Timer extends StatelessWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const timeInitial = "01:00";
    String time = timeInitial;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(),
          BlocBuilder<TimerBloc, TimerState>(builder: (context, state) {
            if (state is RunningState) {
              time = '00:${state.ticks}';
            } else if (state is PauseState) {
              time = '00:${state.pauseTicks}';
            } else if (state is ResumeState) {
              time = '00:${state.resumeTicks}';
            } else if (state is TimerInitial) {
              time = timeInitial;
            }
            return Text(
              time,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            );
          }),
          const SizedBox(
            height: 50,
          ),
          Row(
            children: [
              const Spacer(),
              FloatingActionButton(
                onPressed: () {
                  context.read<TimerBloc>().add(TimerStart(ticks: 60));
                },
                child: const Icon(Icons.play_arrow),
              ),
              const SizedBox(
                width: 30,
              ),
              FloatingActionButton(
                onPressed: () {
                  context.read<TimerBloc>().add(PauseTimer());
                },
                child: const Icon(Icons.pause),
              ),
              const SizedBox(
                width: 30,
              ),
              FloatingActionButton(
                onPressed: () {
                  context.read<TimerBloc>().add(ReplayTimer());
                },
                child: const Icon(Icons.replay),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
