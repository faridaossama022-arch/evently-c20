import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/resources/assets_manager.dart';
import 'package:evently_c20/core/resources/dialog_utils.dart';
import 'package:evently_c20/core/resources/routes_manager.dart';
import 'package:evently_c20/model/event_model.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:evently_c20/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EventItem extends StatefulWidget {
  final EventModel event;
  const EventItem({super.key,required this.event});

  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).pushNamed(RoutesManager.eventDetails, arguments: widget.event);
      },
      child: Container(
        height: screenHeight * 0.25,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    provider.themeMode == ThemeMode.dark
                        ? AppConstants.darkEventTypeBackground[widget.event.type]??""
                        : AppConstants.lightEventTypeBackground[widget.event.type]??"",
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        )
                    ),
                    child: Text(widget.event.dateAndTime?.toDate().day.toString()??"",style: Theme.of(context).textTheme.headlineSmall,),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 9.5,
                        horizontal: 8
                    ),
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .secondary,
                        )
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(widget.event.title??"",style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500
                          ),),
                        ),
                        IconButton(onPressed: () {
                          heartClicked(userProvider);
                        }, icon: SvgPicture.asset(userProvider.user?.favorites?.contains(widget.event.id!)??false
                            ?AssetsManager.heart_selected
                            :AssetsManager.heart))
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  heartClicked(UserProvider userProvider)async{
    if(userProvider.user?.favorites?.contains(widget.event.id!)??false){
      DialogUtils.showLoadingDialog(context);
      await FirestoreManager.deleteEventFavorite(widget.event);
      userProvider.user?.favorites?.remove(widget.event.id!);
      await FirestoreManager.updateUser(userProvider.user?.favorites??[]);
      Navigator.of(context).pop();
      SnackBar snackBar = SnackBar(content: Text("Event deleted from your favorites"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      DialogUtils.showLoadingDialog(context);
      await FirestoreManager.addEventFavorite(widget.event);
      userProvider.user?.favorites?.add(widget.event.id!);
      await FirestoreManager.updateUser(userProvider.user?.favorites??[]);
      Navigator.of(context).pop();
      SnackBar snackBar = SnackBar(content: Text("Event added to your favorites"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {

    });
  }
}