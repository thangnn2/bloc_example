import 'package:bloc_example/timer/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Timer extends StatelessWidget {
  const Timer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final times = context.select((TimerBloc bloc) => bloc.state.ticks);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<TimerBloc, TimerState>(
        listener: (context, state) {
          if (state is RunningState) {
            if (state.ticks == 0) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Yay! Time out'),
              ));
              context.read<TimerBloc>().add(ReplayTimer());
            }
          }
        },
        child: Column(
          children: [
            const Spacer(),
            Text(
              times.toString(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
            ),
            // }),
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
      ),
    );
  }
}
