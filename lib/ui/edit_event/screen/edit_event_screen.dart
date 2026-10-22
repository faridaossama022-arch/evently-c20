import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/resources/assets_manager.dart';
import 'package:evently_c20/core/resources/dialog_utils.dart';
import 'package:evently_c20/core/reusable_components/back_btn.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:evently_c20/model/event_model.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/resources/my_flutter_app_icons.dart';
import '../../../core/reusable_components/custom_field.dart';

class EditEventScreen extends StatefulWidget {
  const EditEventScreen({super.key});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EventModel? event;
  int selectedTab = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  static const List<String> shortMonths = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  final List<String> tabTitles = ["Sport", "Birthday", "Book", "Meeting", "Exhibition"];
  final List<IconData> tabIcons = [
    MyFlutterApp.bike,
    MyFlutterApp.birthday_icon,
    MyFlutterApp.book,
    MyFlutterApp.meeting,
    MyFlutterApp.exhibition,
  ];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (event == null) {
      event = ModalRoute.of(context)!.settings.arguments as EventModel;
      titleController.text = event!.title ?? "";
      descController.text = event!.desc ?? "";
      int index = AppConstants.types.indexOf(event!.type ?? "");
      selectedTab = index == -1 ? 0 : index;
      DateTime? dateTime = event!.dateAndTime?.toDate();
      if (dateTime != null) {
        selectedDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
        selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      }
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    String type = AppConstants.types[selectedTab];
    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        leadingWidth: 60,
        title: Text("Edit Event"),
      ),
      body: DefaultTabController(
        length: 5,
        initialIndex: selectedTab,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
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
                              ? AppConstants.darkEventTypeBackground[type] ?? ""
                              : AppConstants.lightEventTypeBackground[type] ?? "",
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    onTap: (value) {
                      setState(() {
                        selectedTab = value;
                      });
                    },
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    unselectedLabelStyle: Theme.of(context).textTheme.displaySmall,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    dividerHeight: 0,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorWeight: 0,
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tabs: List.generate(tabTitles.length, (index) => Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).colorScheme.secondary),
                        ),
                        child: Row(
                          spacing: 8,
                          children: [
                            Icon(tabIcons[index]),
                            Text(
                              tabTitles[index],
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )),
                  ),
                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title",style: Theme.of(context).textTheme.displaySmall,),
                      CustomField(
                        prefixPath: "",
                        controller: titleController,
                        keyboard: TextInputType.text,
                        hint: "Event Title",
                        validation: (value) {
                          if(value==null || value.isEmpty){
                            return "Event title can't be empty";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description",style: Theme.of(context).textTheme.displaySmall,),
                      CustomField(
                        maxLines: 5,
                        prefixPath: "",
                        controller: descController,
                        keyboard: TextInputType.text,
                        hint: "Event Description",
                        validation: (value) {
                          if(value==null || value.isEmpty){
                            return "Event description can't be empty";
                          }
                          return null;
                        },
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AssetsManager.date),
                      SizedBox(width: 8,),
                      Text("Event Date",style: Theme.of(context).textTheme.displaySmall,),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          chooseDate();
                        },
                        child: Text(
                          selectedDate != null
                              ? "${shortMonths[selectedDate!.month - 1]} ${selectedDate!.day}, ${selectedDate!.year}"
                              : "Choose Date",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(AssetsManager.time),
                      SizedBox(width: 8,),
                      Text("Event Time",style: Theme.of(context).textTheme.displaySmall,),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          chooseTime();
                        },
                        child: Text(
                          selectedTime != null ? selectedTime!.format(context) : "Choose Time",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                            decorationColor: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  CustomButton(title: "Update Event", onClick: () {
                    updateEvent();
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  chooseDate() async {
    var temp = await showDatePicker(
      initialDate: selectedDate,
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (temp != null) {
      setState(() {
        selectedDate = temp;
      });
    }
  }

  chooseTime() async {
    var temp = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (temp != null) {
      setState(() {
        selectedTime = temp;
      });
    }
  }

  updateEvent() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Date and time are required")),
      );
      return;
    }
    var messenger = ScaffoldMessenger.of(context);
    DialogUtils.showLoadingDialog(context);
    event!.title = titleController.text;
    event!.desc = descController.text;
    event!.type = AppConstants.types[selectedTab];
    event!.dateAndTime = Timestamp.fromDate(DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    ));
    await FirestoreManager.updateEvent(event!);
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    messenger.showSnackBar(SnackBar(content: Text("Event updated successfully")));
  }
}