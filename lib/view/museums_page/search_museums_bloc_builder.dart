import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/domain/museums/museums_bloc.dart';
import 'package:veterans/domain/search/museums/search_museums_bloc.dart';


import '../search.dart';
import '../search_bloc_builder.dart';

class SearchMuseumsBlocBuilder extends StatelessWidget implements SearchBlocBuilder {

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      children: [
        Search(_onChangeSearch),
        _blocBuilder()
      ],
    );
  }

  void _onChangeSearch(String text){
    _context.bloc<SearchMuseumsBloc>().add(SearchStart(text));
  }

  Widget _blocBuilder()
  {
    return BlocBuilder<SearchMuseumsBloc, SearchMuseumsState>(
        builder: (context, state) {
          if (state is SearchMuseumsProgress)
            return Padding(padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            );
          if (state is SearchMuseumsSuccess) {
            BlocProvider.of<MuseumsBloc>(context).add(MuseumsUpdated(state.museums));
            return SizedBox.shrink();
          } if (state is NotFoundState) {
            BlocProvider.of<MuseumsBloc>(context).add(MuseumsNotFound());
            return Padding(padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('По запросу ничего не найдено!'),
            );
          }
          else
            return SizedBox.shrink();
        });
  }
}
