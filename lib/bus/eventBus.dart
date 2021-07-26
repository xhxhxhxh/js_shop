import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class HandleBus {
  final String eventType;
  HandleBus(this.eventType);
}

class ChangeNum {
  final int num;
  final Map data;
  ChangeNum(this.num, this.data);
}

class ChangeCheckedStatus {
  final bool status;
  ChangeCheckedStatus(this.status);
}