import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:test_app/feature/presentation/widgets/forecast_widget.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Logger logger = Logger();
  final TextEditingController _controller = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => logger.i("Speech status: $status"),
      onError: (error) => logger.e("Speech error: $error"),
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
        },
      );
    } else {
      logger.e("Speech recognition is not available");
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 50), // Spacing from top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3d3865ca),
                    blurRadius: 12,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Search here",
                        border: InputBorder.none, 
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        hintStyle: TextStyle(color: Color(0x83505050))
                      ),
                    ),
                  ),
                  if (_controller.text.isNotEmpty)
                    IconButton(

                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.done, color: Colors.black45 , size: 25,),
                      onPressed: () {

                        final location = _controller.text;
                        if (location.isNotEmpty) {
                          context.read<LocationSearchBloc>().add(SearchLocations(location: location));
                        }
                      },
                    ),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic, color: Colors.grey),
                    onPressed: () {
                      if (_isListening) {
                        _stopListening();
                      } else {
                        _startListening();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<LocationSearchBloc, LocationSearchState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return const LoadingIcon();
                } else if (state is LocationLoaded) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.locations.length,
                    itemBuilder: (context, index) {
                      final location = state.locations[index];
                      return ListTile(
                        title: Text(location.name ?? "" , style: AppTextStyles.search),
                        subtitle: Text("${location.country}, ${location.region}"),
                        tileColor: Color(0x348eb6ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        onTap: () {
                          Navigator.pop(context, location.name);
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 10.0),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
