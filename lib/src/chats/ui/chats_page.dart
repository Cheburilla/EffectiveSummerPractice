import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ChatsPage extends StatelessWidget {
  final List<Chat> chats;

  const ChatsPage({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru');
    chats.removeWhere((element) => element.lastMessage == null);
    chats.sort((a, b) => b.date!.difference(a.date!).inSeconds);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextPlain Messenger'),
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.search)],
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title:
                  Text(chats[index].userName, style: const TextStyle(fontSize: 22)),
              subtitle: Text(chats[index].lastMessage!, maxLines: 1, overflow: TextOverflow.ellipsis),
              leading: CircleAvatar(
                backgroundImage: AssetImage(chats[index].userAvatar?? ''),
                child: chats[index].userAvatar == null ? Text(chats[index].userName[0]) : null),
              trailing: Text(DateFormat.MMMd("ru").format(chats[index].date!)),
            );
          }),
    );
  }
}
