import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_bloc.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:test_app/feature/presentation/bloc/search_bloc/search_state.dart';
import 'package:test_app/feature/presentation/widgets/loading_widget.dart';

class SearchPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationSearchBloc, LocationSearchState>(
        listener: (context, state) {
          if (state is LocationSearchError) {
            // Обработка ошибки
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
                  labelText: 'Введите город',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final location = _controller.text;
                  if (location.isNotEmpty) {
                    context
                        .read<LocationSearchBloc>()
                        .add(SearchLocations(location: location));
                  }
                },
                child: Text('Поиск'),
              ),
              SizedBox(height: 16.0),
              BlocBuilder<LocationSearchBloc, LocationSearchState>(
                builder: (context, state) {
                  if (state is LocationLoading) {
                    return LoadingIcon();
                  } else if (state is LocationLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.locations.length,
                        itemBuilder: (context, index) {
                          final location = state.locations[index];
                          return ListTile(
                            title: Text(location.name ?? ""),
                            onTap: () {
                              Navigator.pop(context, location.name);
                            },
                          );
                        },
                      ),
                    );
                  }
                  return Container(); // Пустой контейнер, если нет состояния загрузки или ошибки
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
