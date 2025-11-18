import 'package:back_to_us/Models/app_user.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:flutter/material.dart';

class StackedMemberDisplay extends StatelessWidget {
  const StackedMemberDisplay({
    super.key,
    required this.displayUsers,
    required this.userLength,
    this.radius = 15,
  });

  final double radius;
  final int userLength;
  final List<AppUser> displayUsers;

  @override
  Widget build(BuildContext context) {

    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: displayUsers.length * 30,
          height: radius*2,
          child: Stack(
            children: displayUsers.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              return Positioned(
                left: index * radius,
                child: CustomProfilePictureDisplayer(
                  radius: radius,
                  profileUrl: user.profilePic ?? "",
                ),
              );
            }).toList(),
          ),
        ),
        if (userLength >3) 
          Text("+${userLength - 3}")
      ] 
    );
    
    
    
    /*return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ...displayUsers.map((user) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomProfilePictureDisplayer(
              radius: 15,
              profileUrl: user.profilePic ?? "",
            ),
          );
        }).toList(),
        if (userLength >3) 
          Text("+${userLength - 3}")
      ]
    );*/
  }
}

/*return Center(
                child: SizedBox(
                  height: 30, // same as avatar diameter
                  width: (displayUsers.length * 20.0) + 30, // controls total width
                  child: Stack(
                    children: [
                      ...displayUsers.mapIndexed((index, user) {
                        return Positioned(
                          left: index * 20.0, // overlap spacing
                          child: CustomProfilePictureDisplayer(
                            radius: 15,
                            profileUrl: user.profilePic ?? "",
                          ),
                        );
                      }).toList(),
                      if (users.length > 3)
                        Positioned(
                          left: displayUsers.length * 20.0,
                          child: Text("+${users.length - 3}")
                        ),
                    ],
                  ),
                ),
              ); */