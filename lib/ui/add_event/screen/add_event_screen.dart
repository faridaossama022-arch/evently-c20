import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20/core/remote/network/firestore_manager.dart';
import 'package:evently_c20/core/resources/app_constants.dart';
import 'package:evently_c20/core/resources/assets_manager.dart';
import 'package:evently_c20/core/resources/dialog_utils.dart';
import 'package:evently_c20/core/reusable_components/back_btn.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:evently_c20/model/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/resources/my_flutter_app_icons.dart';
import '../../../core/reusable_components/custom_field.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  late TextEditingController titleController;
  late TextEditingController descController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int selectedTab = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: BackBtn(),
        leadingWidth: 60,
        title: Text("Add Event"),
      ),
      body: DefaultTabController(
        length: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 16,
                children: [
                  Container(
                    height: screenHeight * 0.23,
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.23,
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
                                AssetsManager.sport_light,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.23,
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
                                AssetsManager.birthday_light,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.23,
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
                                AssetsManager.book_light,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.23,
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
                                AssetsManager.meeting_light,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: screenHeight * 0.23,
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
                                AssetsManager.exhibition_light,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    onTap: (value) {
                      selectedTab = value;
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
                    tabs: [
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(MyFlutterApp.bike),
                              Text(
                                "Sport",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(MyFlutterApp.birthday_icon),
                              Text(
                                "Birthday",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(MyFlutterApp.book),
                              Text(
                                "Book",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),

                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(MyFlutterApp.meeting),
                              Text(
                                "Meeting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          child: Row(
                            spacing: 8,
                            children: [
                              Icon(MyFlutterApp.exhibition),
                              Text(
                                "Exhibition",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                        child: Text(selectedDate!=null?selectedDate.toString():"Choose Date",style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400
                        ),),
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
                        child: Text(selectedTime!=null?selectedTime!.format(context):"Choose Time",style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w400
                        ),),
                      )
                    ],
                  ),
                  CustomButton(title: "Add Event", onClick: () {
                    addEvent();
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  DateTime? selectedDate;
  chooseDate()async{
    var temp = await showDatePicker(
        initialDate: selectedDate,
        context: context,

        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365))
    );
    if(temp!=null){
      setState(() {
        selectedDate = temp;
      });
    }
  }
  TimeOfDay? selectedTime;
  chooseTime()async{
    var temp = await showTimePicker(
        context: context,
        initialTime: selectedTime??TimeOfDay.now()
    );
    if(temp!=null){
      setState(() {
        selectedTime = temp;
      });
    }
  }

  addEvent()async{
    if(formKey.currentState!.validate()){
      if(selectedTime != null && selectedDate !=null){
        DialogUtils.showLoadingDialog(context);
        await FirestoreManager.saveEvent(EventModel(
            userId: FirebaseAuth.instance.currentUser?.uid,
            title: titleController.text,
            desc: descController.text,
            dateAndTime: Timestamp.fromDate(DateTime(
              selectedDate!.year,
              selectedDate!.month,
              selectedDate!.day,
              selectedTime!.hour,
              selectedTime!.minute,
            )),
            type: AppConstants.types[selectedTab]
        ));
        Navigator.of(context).pop();
        SnackBar snackBar = SnackBar(content: Text("Event created successfully"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        SnackBar snackBar = SnackBar(content: Text("Date and time are required"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      

    }
  }
}
