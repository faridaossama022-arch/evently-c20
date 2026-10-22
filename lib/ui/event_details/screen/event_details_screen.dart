import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/resources/assets_manager.dart';
import 'package:evently_c20/core/resources/dialog_utils.dart';
import 'package:evently_c20/core/resources/routes_manager.dart';
import 'package:evently_c20/core/reusable_components/back_btn.dart';
import 'package:evently_c20/model/event_model.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  static const List<String> months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  @override
  Widget build(BuildContext context) {
    EventModel event = ModalRoute.of(context)!.settings.arguments as EventModel;
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    DateTime? dateTime = event.dateAndTime?.toDate();
    bool isOwner = event.userId == FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        leadingWidth: 60,
        title: Text("Event Details"),
        actions: isOwner
            ? [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed(RoutesManager.editEvent, arguments: event);
              setState(() {});
            },
            icon: Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary),
          ),
          IconButton(
            onPressed: () {
              confirmDelete(event);
            },
            icon: Icon(Icons.delete_outline, color: Colors.red),
          ),
        ]
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: screenHeight * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    provider.themeMode == ThemeMode.dark
                        ? AppConstants.darkEventTypeBackground[event.type] ?? ""
                        : AppConstants.lightEventTypeBackground[event.type] ?? "",
                  ),
                ),
              ),
            ),
            Text(event.title ?? "", style: Theme.of(context).textTheme.titleMedium),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      AssetsManager.date,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  ),
                  SizedBox(width: 8,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateTime != null ? "${dateTime.day} ${months[dateTime.month - 1]}" : "",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        dateTime != null ? TimeOfDay.fromDateTime(dateTime).format(context) : "",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text("Description", style: Theme.of(context).textTheme.displaySmall),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
              ),
              child: Text(event.desc ?? "", style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }

  confirmDelete(EventModel event) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text("Delete Event"),
        content: Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              deleteEvent(event);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  deleteEvent(EventModel event) async {
    var messenger = ScaffoldMessenger.of(context);
    DialogUtils.showLoadingDialog(context);
    await FirestoreManager.deleteEvent(event);
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text("Event deleted successfully")));
  }
}