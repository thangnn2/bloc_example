import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'draggable_bottom_sheet/panel_controller.dart';
import 'draggable_bottom_sheet/sliding_value.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with TickerProviderStateMixin {
  late final PanelController _panelController;
  late final ScrollController _scrollController;
  VelocityTracker? velocityTracker;
  Offset _initialPointerPosition = Offset.zero;
  late AnimationController _animationController;
  bool _scrollToTop = false;
  bool _scrollToBottom = false;
  double _scrollableSpace = 0.0;
  double gapScrollingDown = 0.0;
  double gapScrollingUp = 0.0;
  final double _maxPanelHeight = 1.sh;
  final double _minPanelHeight = 210.h;

  bool get _aboveHalfWay => _panelController.value.factor > 0.3;

  @override
  void initState() {
    _panelController = PanelController();
    _scrollController = _panelController.scrollController
      ..addListener(() {
        if ((_scrollToTop || _scrollToBottom) && _scrollController.hasClients) {
          _scrollController.position.hold(() {});
        }
      });
    _scrollableSpace = _maxPanelHeight - _minPanelHeight;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(
        () {
          _panelController.attach(
            SlidingValue(
              factor: _animationController.value,
              slidingState: _aboveHalfWay ? SlidingState.max : SlidingState.min,
            ),
          );
        },
      );
    super.initState();
  }

  void _onPointerDown(PointerDownEvent event) {
    _initialPointerPosition = event.position;
    velocityTracker ??= VelocityTracker.withKind(event.kind);
    setState(() {});
  }

  void _onPointerMove(PointerMoveEvent event) {
    velocityTracker!.addPosition(event.timeStamp, event.position);
    final panelState = _panelController.value.slidingState;
    final state =
        _initialPointerPosition.dy - event.position.dy > _minPanelHeight
            ? SlidingState.slidingUp
            : SlidingState.slidingDown;
    if (panelState == SlidingState.initial && state == SlidingState.slidingUp) {
      _scrollToTop = 1.sh - event.position.dy > _minPanelHeight;
    }
    if (panelState == SlidingState.max && state == SlidingState.slidingDown) {
      final isControllerOffsetZero = _scrollController.hasClients
          ? _scrollController.offset == 0.0
          : false;
      final isHandler = event.position.dy >= _minPanelHeight &&
          event.position.dy <= _maxPanelHeight;
      _scrollToBottom = isHandler || isControllerOffsetZero;
    }

    if (_scrollToBottom || _scrollToTop) {
      double factor = 0.0;
      if (_scrollToTop) {
        factor = ((_initialPointerPosition.dy - event.position.dy) /
                _scrollableSpace)
            .clamp(0, 1);
      }
      _panelController.attach(
        SlidingValue(
          slidingState: state,
          factor: factor,
        ),
      );
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final velocity = velocityTracker!.getVelocity();
    final dyVelocity = velocity.pixelsPerSecond.dy;
    final flingPanel = dyVelocity.abs() > 800.0;
    final endValue = flingPanel
        ? (dyVelocity.isNegative ? 1.0 : 0.0)
        : (_aboveHalfWay ? 1.0 : 0.0);
    _snapToPosition(endValue);
    velocityTracker = null;
  }

  void _snapToPosition(double endValue, {double? startValue}) {
    final Simulation simulation = SpringSimulation(
      SpringDescription.withDampingRatio(
        mass: 1.0,
        stiffness: 600.0,
        ratio: 1.1,
      ),
      startValue ?? _panelController.value.factor,
      endValue,
      0,
    );
    _animationController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _panelController.openPanel();
        },
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                _panelController.closePanel();
              },
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _panelController.panelVisibility,
            builder: (context, isVisible, child) {
              return isVisible ? child! : const SizedBox();
            },
            child: ValueListenableBuilder(
              valueListenable: _panelController,
              builder: (context, SlidingValue value, child) {
                final height = (_minPanelHeight +
                    value.factor * (_maxPanelHeight - _minPanelHeight));
                return PositionedDirectional(
                  bottom: 0,
                  child: SizedBox(
                    height: height,
                    child: child,
                  ),
                );
              },
              child: Listener(
                onPointerDown: _onPointerDown,
                onPointerUp: _onPointerUp,
                onPointerMove: _onPointerMove,
                child: Container(
                  width: 1.sw,
                  color: Colors.purple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
