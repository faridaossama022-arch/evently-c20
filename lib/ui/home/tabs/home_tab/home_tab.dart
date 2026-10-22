import 'package:evently_c20/core/resources/assets_manager.dart';
import 'package:evently_c20/core/resources/my_flutter_app_icons.dart';
import 'package:evently_c20/providers/theme_provider.dart';
import 'package:evently_c20/providers/user_provider.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/all_view.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/birthday_view.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/book_view.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/exhibition_view.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/meeting_view.dart';
import 'package:evently_c20/ui/home/tabs/home_tab/tabs/sport_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../start/widgets/language_switch.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTabController(
          length: 6,
          child: Column(
            spacing: 24,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Back ✨",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(fontSize: 14),
                        ),
                        userProvider.user==null
                            ?Center(child: CircularProgressIndicator(),)
                            :Text(
                          userProvider.user?.name??"",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: .w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    InkWell(
                      onTap: (){
                        if(themeProvider.themeMode==ThemeMode.dark){
                          themeProvider.changeTheme(ThemeMode.light);
                        }else{
                          themeProvider.changeTheme(ThemeMode.dark);
                        }
                      },
                      child: SvgPicture.asset(
                        themeProvider.themeMode == ThemeMode.dark
                            ? AssetsManager.moon
                            : AssetsManager.sun,
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary,
                              .srcIn,
                        ),
                        height: 24,
                        width: 24,
                      ),
                    ),
                    SizedBox(width: 4,),
                    LanguageSwitch(
                      title: "EN",
                      selectedLanguage: "en",
                      languageCode: "en",
                      height: 32,
                      width: 32,
                    ),
                  ],)
                ],
              ),
              TabBar(
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
                    borderRadius: BorderRadius.circular(16)
                  ),
                  tabs: [
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .secondary
                      )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.all),
                        Text("All",style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary
                        )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.bike),
                        Text("Sport",style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary
                        )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.birthday_icon),
                        Text("Birthday",style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary
                        )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.book),
                        Text("Book",style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),

                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary
                        )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.meeting),
                        Text("Meeting",style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .secondary
                        )
                    ),
                    child: Row(
                      spacing:8,
                      children: [
                        Icon(MyFlutterApp.exhibition),
                        Text("Exhibition",style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16
                        ),)
                      ],
                    ),
                  ),
                )
              ]),
              Expanded(
                  child: TabBarView(children: [
                    AllView(),
                    SportView(),
                    BirthdayView(),
                    BookView(),
                    MeetingView(),
                    ExhibitionView(),
                  ]))
            ],
          ),
        ),
      ),
    );
  }
}
