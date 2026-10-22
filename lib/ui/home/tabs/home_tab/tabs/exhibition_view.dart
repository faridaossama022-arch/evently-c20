import 'package:flutter/material.dart';

import '../../../../../core/remote/network/firestore_manager.dart';
import '../../../../../core/resources/app_constants.dart';
import '../../../../../core/reusable_components/event_item.dart';
import '../../../../../model/event_model.dart';

class ExhibitionView extends StatelessWidget {
  const ExhibitionView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreManager.getFilteredEvents(AppConstants.types[4]),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.hasError){
          return Column(
            children: [
              Text(snapshot.error.toString()),
              ElevatedButton(onPressed: () {

              }, child: Text("Try Again"))
            ],
          );
        }
        List<EventModel> events = snapshot.data??[];
        if(events.isEmpty){
          return Center(child: Text('No events found',style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary
          ),),);
        }
        return ListView.separated(
            itemBuilder: (context, index) => EventItem(event: events[index],),
            separatorBuilder: (context, index) => SizedBox(height: 16,),
            itemCount: events.length
        );
      },
    );
  }
}
