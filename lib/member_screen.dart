import 'package:flutter/material.dart';
import 'data_model.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key, required this.addMember, required this.deleteMember, required this.members});

  final Function(String) addMember;
  final Function(Member) deleteMember;
  final List<Member> members;

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Members'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.members.length,
              itemBuilder: (context, index) {
                final member = widget.members[index];
                return ListTile(
                  title: Text(member.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.deleteMember(member);
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // Show add member dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    String newMemberName = '';
                    return AlertDialog(
                      title: const Text('Add Member'),
                      content: TextField(
                        onChanged: (value) {
                          newMemberName = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Member Name',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.addMember(newMemberName);
                            Navigator.pop(context);
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add Member'),
            ),
          ),
        ],
      ),
    );
  }
}
