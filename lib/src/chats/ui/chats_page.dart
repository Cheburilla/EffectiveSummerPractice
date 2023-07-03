import 'dart:math';

import 'package:bootcamp_project/src/chats/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';

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
        backgroundColor: Colors.black26,
        title: const Text('TextPlain Messenger'),
        leading: const Icon(Icons.menu),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPage(
                      searchLabel: 'Поиск',
                      suggestion: const Center(
                        child: Text('Чаты по имени и сообщению'),
                      ),
                      failure: const Center(
                        child: Text('Ничего не найдено :('),
                      ),
                      items: chats,
                      filter: (chat) => [chat.userName, chat.lastMessage],
                      builder: (chat) => tiles(chat),
                    ),
                  ))
        ],
        centerTitle: true,
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(4),
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            final chat = chats[index];
            return tiles(chat);
          }),
    );
  }

  Widget tiles(Chat chat) {
    return ListTile(
      title: Padding(
          padding: const EdgeInsets.only(bottom: 2, top: 4),
          child: Row(
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Expanded(
                  child: Text(chat.userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
                SizedBox(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      (DateTime.now().difference(chat.date!).inDays < 7)
                          ? DateFormat.E("ru").format(chat.date!)
                          : (DateUtils.isSameDay(DateTime.now(), chat.date!))
                              ? DateFormat.Hm("ru").format(chat.date!)
                              : DateFormat.MMMd("ru").format(chat.date!),
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                )
              ])),
      subtitle: Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Expanded(
            child: Text(chat.lastMessage!,
                style: const TextStyle(fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          chat.countUnreadMessages != 0
              ? Center(
                  child: Container(
                      //padding: const EdgeInsets.all(2),
                      width: 26,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                          child: Text(
                        chat.countUnreadMessages.toString(),
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ))))
              : const SizedBox.shrink(),
        ],
      ),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage:
            chat.userAvatar != null ? AssetImage(chat.userAvatar!) : null,
        child: chat.userAvatar == null
            ? Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Color.fromARGB(255, Random().nextInt(128),
                              Random().nextInt(128), Random().nextInt(128))
                        ])),
                child: chat.userAvatar == null
                    ? Center(
                        child: Text(
                        chat.userName[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ))
                    : null,
              )
            : null,
      ),
      visualDensity: const VisualDensity(vertical: 4),
    );
  }
}
