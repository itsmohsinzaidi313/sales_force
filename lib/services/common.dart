import 'dart:async';
import 'package:logger/logger.dart';
import '../shared/config.dart';

abstract class ServiceCommon {
  String name;
  String description;
  String serviceVersion;
  bool active = false;
  bool cycleComplete = true;
  int duration = Config.serviceCycleDelay;
  Logger log = Config.log;

  Future<void> perform();

  void setStatus(bool set) => active = set;

  bool status() => active;

  void start() => active = true;

  void stop() => active = false;

  void initiate() => _cycle();

  void forceCycle() => cycleComplete = true;

  void pauseDuration({int seconds = Config.serviceCycleDelay}) {
    this.duration = seconds;
  }

  void _cycle() async =>
      Timer.periodic(Duration(seconds: duration), (Timer t) => _operation());

  void _operation() async {
    if (active && cycleComplete) {
      try {
        await perform();
      } catch (e) {
        log.e('SERVICE $name CRASHED: $e');
      }
    }
  }
}
