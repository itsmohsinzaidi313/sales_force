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

  initiate() => _cycle();

  forceCycle() => cycleComplete = true;

  pauseDuration({int seconds = Config.serviceCycleDelay}) {
    this.duration = seconds;
  }

  _cycle() async =>
      Timer.periodic(Duration(seconds: duration), (Timer t) => _operation());

  _operation() async {
    if (active) {
      if (cycleComplete) await perform();
    }
  }
}
