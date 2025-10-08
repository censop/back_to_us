import 'package:back_to_us/Services/firebase_service.dart';
import 'package:back_to_us/Widgets/custom_profile_picture_displayer.dart';
import 'package:back_to_us/Widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class PendingInvitesScreen extends StatefulWidget {
  const PendingInvitesScreen({super.key});

  @override
  State<PendingInvitesScreen> createState() => _PendingInvitesScreenState();
}

class _PendingInvitesScreenState extends State<PendingInvitesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Invites"),
        centerTitle: true,
      ),

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseService.pendingInvitesStream(), 
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final invites = snapshot.data!;

          if (invites.isEmpty) {
            return Center(
              child: Text(
                "There are no pending invites.", 
                style: Theme.of(context).textTheme.titleMedium,
              )
            );
          }

          return ListView.builder(
            itemCount: invites.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CustomProfilePictureDisplayer(
                  radius: 30,
                  profileUrl: invites[index]["senderPhoto"] ?? "",
                ),
                title: Text(invites[index]["senderUsername"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      FirebaseService.acceptFriendInvite(invites[index]["id"]);

                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackbar(
                          content: Text("Invite accepted."), 
                          backgroundColor: Theme.of(context).colorScheme.primary
                        )
                      );
                    },
                    ),
                    IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      FirebaseService.declineFriendInvite(invites[index]["id"]);

                      ScaffoldMessenger.of(context).showSnackBar(
                        customSnackbar(
                          content: Text("Invite rejected."), 
                          backgroundColor: Theme.of(context).colorScheme.primary
                        )
                      );
                    },
                    )
                  ],
                ),
              );    
            }
          );
        }
      ),
    );
  }
}