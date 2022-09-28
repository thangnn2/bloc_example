import 'package:bloc_example/demo/draggable_bottom_sheet/panel_controller.dart';
import 'package:bloc_example/demo/draggable_bottom_sheet/slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> with TickerProviderStateMixin {
  late final PanelController _panelController;
  VelocityTracker? velocityTracker;
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  double _initialPointerPosition = 0.0;
  final double _maxHeightPanel = 1.sh;
  final double _minHeightPanel = 210.h;
  bool _scrollToTop = false;
  bool _scrollTopBottom = false;
  var _pointerPositionBeforeScroll = Offset.zero;

  bool get _aboveHalfWay => _panelController.value.factor > 0.3;

  @override
  void initState() {
    _panelController = PanelController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..addListener(() {
        _panelController.attach(SliderValue(
          factor: _animationController.value,
          state: _aboveHalfWay ? SliderState.max : SliderState.initial,
        ));
      });
    _scrollController = _panelController.scrollController
      ..addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.position.hold(() {});
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onPointerUp(PointerUpEvent event) {
    final scrollVelocity = velocityTracker!.getVelocity();
    final dyVelocity = scrollVelocity.pixelsPerSecond.dy;
    final flingPanel = dyVelocity.abs() > 800.0;
    final endValue = flingPanel
        ? (dyVelocity.isNegative ? 1.0 : 0.0)
        : (_aboveHalfWay ? 1.0 : 0.0);
    _snapToPosition(endValue);
  }

  void _onPointerDown(PointerDownEvent event) {
    _initialPointerPosition = event.position.dy;
    velocityTracker ??= VelocityTracker.withKind(event.kind);
  }

  void _onPointerMove(PointerMoveEvent event) {
    final panelState = _panelController.value.state;
    final state = _initialPointerPosition - event.position.dy > _minHeightPanel
        ? SliderState.slidingUp
        : SliderState.slidingDown;
    velocityTracker?.addPosition(event.timeStamp, event.position);
    if (state == SliderState.slidingUp && panelState == SliderState.initial) {
      _scrollToTop =
          _initialPointerPosition - event.position.dy > _minHeightPanel;
    }
    if (state == SliderState.slidingDown && panelState == SliderState.max) {
      final isHandler =
          event.position.dy >= _minHeightPanel && event.position.dy <= 1.sh;
      _scrollTopBottom = isHandler;
    }
    if (_scrollTopBottom) {
      _pointerPositionBeforeScroll = event.position;
    }
    if (_scrollToTop || _scrollTopBottom) {
      final startingPX = event.position.dy -
          (_scrollToTop ? _minHeightPanel : _pointerPositionBeforeScroll.dy);
      final remainingPX = ((_maxHeightPanel - _minHeightPanel) - startingPX);

      final factor = (remainingPX / (_maxHeightPanel - _minHeightPanel));
      _panelController.attach(SliderValue(factor: factor, state: state));
    }
    // final scrollGap = _initialPointerPosition - event.position.dy;
    // final factor = scrollGap / (_maxHeightPanel - _minHeightPanel);
    // if (factor >= 0 && factor <= 1) {
    //   _panelController.attach(SliderValue(factor: factor));
    // }
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
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (_) {
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
            child: ValueListenableBuilder<SliderValue>(
              valueListenable: _panelController,
              builder: (context, value, child) {
                final height = (_minHeightPanel +
                        (value.factor * (_maxHeightPanel - _minHeightPanel)))
                    .clamp(_minHeightPanel, _maxHeightPanel);
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
                onPointerMove: _onPointerMove,
                onPointerUp: _onPointerUp,
                child: Container(
                  width: 1.sw,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
