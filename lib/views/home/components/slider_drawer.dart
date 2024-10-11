import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_master/extensions/space_exs.dart';
import 'package:task_master/utils/app_colors.dart';
import 'package:task_master/views/home/components/details_page.dart';
import 'package:task_master/views/home/components/home_page.dart';
import 'package:task_master/views/home/components/profile_page.dart';
import 'package:task_master/views/home/components/setting_page.dart';
import 'package:task_master/views/home/home_view.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({super.key});

  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              "https://avatars.githubusercontent.com/u/91388754?v=4",
            ),
          ),
          8.h,
          Text("Vishnu Chandan", style: textTheme.displayMedium),
          Text("Wildlife Photographer, Web and App Dev",
              style: textTheme.displaySmall),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: widget.icons.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _navigateToPage(index);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(widget.icons[index], color: Colors.white),
                      title: Text(widget.texts[index],
                          style: textTheme.titleMedium
                              ?.copyWith(color: Colors.white)),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailsPage()),
        );
        break;
    }
  }
}
