import 'package:evently_c20/core/resources/routes_manager.dart';
import 'package:evently_c20/core/reusable_components/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../core/resources/assets_manager.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": AssetsManager.onboarding1,
      "title": "Find Events That Inspire You",
      "desc": "Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art workshops, professional networking, or simply discovering new experiences, we have something for everyone. Our curated recommendations will help you explore, connect, and make the most of every opportunity around you.",
    },
    {
      "image": AssetsManager.onboarding2,
      "title": "Effortless Event Planning",
      "desc": "Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we've got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.",
    },
    {
      "image": AssetsManager.onboarding3,
      "title": "Connect with Friends & Share Moments",
      "desc": "Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.",
    },
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void goToSignIn() {
    Navigator.pushReplacementNamed(context, RoutesManager.signIn);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color primary = Theme.of(context).colorScheme.primary;
    bool isLastPage = currentIndex == pages.length - 1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: currentIndex > 0
            ? IconButton(
          onPressed: () {
            pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, color: primary, size: 20,),
        )
            : null,
        title: Image.asset(AssetsManager.logo,
          color: primary,
          width: screenWidth*0.45,),
        actions: [
          if (!isLastPage)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: goToSignIn,
                style: TextButton.styleFrom(
                  backgroundColor: primary.withValues(alpha: 0.08),
                  minimumSize: Size(0, 30),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Skip", style: TextStyle(
                  color: primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (context, index) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(pages[index]["image"]!),
                      ),
                    ),
                    SizedBox(height: 16,),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(pages.length, (dotIndex) => AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          width: currentIndex == dotIndex ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: currentIndex == dotIndex ? primary : Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )),
                      ),
                    ),
                    SizedBox(height: 24,),
                    Text(pages[index]["title"]!,style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 16,),
                    Text(pages[index]["desc"]!,style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                title: isLastPage ? "Get started" : "Next",
                onClick: () {
                  if (isLastPage) {
                    goToSignIn();
                  } else {
                    pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}