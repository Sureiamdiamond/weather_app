import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:test_app/feature/presentation/widgets/forecast_widget.dart';
import 'package:test_app/gen/assets.gen.dart';
import 'package:intl/intl.dart' as intl;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  final String apiKey = 'AIzaSyD3ZmBeQeBYEPv1PV-BeUVNm_I2t_MrU54';
  bool isLoading = false;

  // Add a ScrollController
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Gemini.init(apiKey: apiKey, enableDebugging: true);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Don't forget to dispose of the controller.
    super.dispose();
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        String formattedTime = intl.DateFormat('HH:mm').format(DateTime.now());
        messages.add({
          'text': _controller.text,
          'isMe': true,
          'time': formattedTime,
        });
        isLoading = true;
      });
      askGemini(_controller.text);
      _controller.clear();
      _scrollToBottom(); // Scroll to the bottom when a new message is added
    }
  }

  void askGemini(String prompt) async {
    try {
      final response = await Gemini.instance.prompt(parts: [
        Part.text(prompt),
      ]);
      setState(() {
        String formattedTime = intl.DateFormat('HH:mm').format(DateTime.now());
        messages.add({
          'text': response?.output ?? 'No response from server.',
          'isMe': false,
          'time': formattedTime,
        });
        isLoading = false;
      });
      _scrollToBottom(); // Scroll to the bottom when a new message is received
    } catch (e) {
      setState(() {
        String formattedTime = intl.DateFormat('HH:mm').format(DateTime.now());
        String errorMessage = 'Error occurred';

        if (e.toString().contains('403')) {
          errorMessage = 'لطفا اینترنت خود را بررسی کنید یا از متصل بودن فیلترشکن مطمئن شوید';
        } else {
          errorMessage = 'Error: ${e.toString()}';
        }

        messages.add({
          'text': errorMessage,
          'isMe': false,
          'time': formattedTime,
        });
        isLoading = false;
      });
      _scrollToBottom(); // Scroll to the bottom in case of error
    }
  }

  // Function to scroll to the bottom
  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  bool isPersian(String text) {
    final persianRegex = RegExp(r'[\u0600-\u06FF]');
    return persianRegex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
                Image.asset(Assets.images.gemini.path, height: 35),
                const SizedBox(width: 50)
              ],
            ),
          ),
          Expanded(
            child: messages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Assets.images.bot.path, height: 90),
                  const SizedBox(height: 10),
                  Text(
                    "برای استفاده از من باید حتما فیلترشکن روشن باشه!",
                    textDirection: TextDirection.rtl,
                    style: AppTextStyles.geminiFarsiBlack,
                  )
                ],
              ),
            )
                : ListView.builder(
              reverse: false,
              itemCount: messages.length + (isLoading ? 1 : 0),
              controller: _scrollController, // Attach the controller here
              itemBuilder: (context, index) {
                if (isLoading && index == messages.length) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xff0064b6),));
                }
                final message = messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4, left: 4),
                    child: Container(
                      width: message['isMe'] ? null : 350,
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: message['isMe']
                            ? const Color(0xff0064b6)
                            : Colors.grey[600],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message['text'],
                            style: isPersian(message['text'])
                                ? AppTextStyles.geminiFarsi
                                : const TextStyle(
                              color:  Colors.white
                              ,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            message['time'],
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: AppTextStyles.gemini,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      hintText: 'هرچی میخوای بپرس...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send_rounded,
                      color: Color(0xff0e6ab6), size: 30),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
