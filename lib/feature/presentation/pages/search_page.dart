import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Logger logger = Logger();

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 233, 233),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 239, 231, 233),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          iconSize: 35,
        ),
      ),
      body: BlocListener<LocationSearchBloc, LocationSearchState>(
        listener: (context, state) {
          if (state is LocationSearchError) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter the city name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final location = _controller.text;
                  logger.i("Enter the city name$location");
                  if (location.isNotEmpty) {
                    context
                        .read<LocationSearchBloc>()
                        .add(SearchLocations(location: location));
                  }
                },
                child: const Text('Search'),
              ),
              const SizedBox(height: 16.0),
              BlocBuilder<LocationSearchBloc, LocationSearchState>(
                builder: (context, state) {
                  if (state is LocationLoading) {
                    return const LoadingIcon();
                  } else if (state is LocationLoaded) {
                    return Expanded(
                      child: Scrollbar( // Optional: Adds a scrollbar for better UX
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: state.locations.length,
                          itemBuilder: (context, int index) {
                            final location = state.locations[index];
                            return ListTile(
                              title: Text(location.name ?? ""),
                              subtitle: Text("${location.country}, ${location.region}"),
                              tileColor: const Color.fromARGB(255, 212, 210, 210),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0),
                              ),
                              onTap: () async {
                                Navigator.pop(context, location.name);
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 10.0);
                          },
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
