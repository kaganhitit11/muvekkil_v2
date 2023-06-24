import 'package:example/profile_page.dart';
import 'package:example/welcome_page.dart';
import 'package:flutter/material.dart';
import 'chatCompletion.dart';
import 'chat_message.dart';
import 'model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Color myRed = const Color(0xffff2d2d);
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;
  String? firstUserMessage;

  void _addBotGreeting() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'Merhabalar. Sana nasıl yardımcı olabilirim?',
        chatMessageType: ChatMessageType.bot,
      ));
    });
  }

  @override
  void initState() {
    _addBotGreeting();
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
              "Müvekkil",
              style: TextStyle(fontSize: 30),
              textAlign: TextAlign.center
          ),
        ),
        backgroundColor: myRed,
        centerTitle: true,
      ),
      drawer: _buildDrawer(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (firstUserMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 5.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Container(
                    width: 410,
                    decoration: BoxDecoration(
                        color: myRed,
                        border: Border.all(color:Colors.red),
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child:Padding(
                      padding: const EdgeInsets.all(25.0),
                        child: Column(
                            children:[
                              const Text(
                                "Problem",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight:FontWeight.bold, fontSize: 25, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                firstUserMessage!,
                                style: const TextStyle(fontSize: 20, color: Colors.white),
                                textAlign: TextAlign.justify,
                              ),
                            ]
                        )
                    )
                  ),
                ),
              ),
            Expanded(
              child: _buildList(),
            ),
            Visibility(
              visible: isLoading,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  _buildInput(),
                  const SizedBox(width: 5),
                  _buildSubmit(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: myRed,
            ),
            child: const Center( // Wrap your text with a Center widget
              child: Text('Menü', style: TextStyle(color: Colors.white, fontSize: 30,),
                textAlign: TextAlign.center, // Optional, adds more guarantee for centering text
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.black),
            title: const Text('Profilim', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.arrow_back_ios, color: Colors.black),
            title: const Text('Çıkış Yap', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: myRed,
        ),
        child: IconButton(
          icon: const Icon(
            Icons.send_rounded,
            color: Colors.white,
          ),
          onPressed: () async {
            if (firstUserMessage == null) {
              setState(() {
                firstUserMessage = _textController.text;
              });
            }
            setState(
                  () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            chatCompletion(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.black),
        controller: _textController,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: myRed),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: myRed),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(color: myRed),
          ),
          ),
        ),
      );
  }

  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return ChatMessageWidget(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _choiceAction(String choice) {
    if (choice == 'Logout') {
      // implement logout functionality here
      print('Logout');
    } else if (choice == 'Profile Page') {
      // navigate to profile page
      print('Navigate to Profile Page');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

}






