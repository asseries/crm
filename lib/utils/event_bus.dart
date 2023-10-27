import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();


// busEventListener = eventBus.on<EventModel>().listen((event) {
//       if(event.event == EVENT_NOTIFICATION){
//       }
//     });

//        eventBus.fire(EventModel(event: EVENT_NOTIFICATION, data: ["BACK","SERVICES"]));