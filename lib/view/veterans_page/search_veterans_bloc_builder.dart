import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/domain/maps/map_bloc.dart';
import 'package:veterans/domain/search/veterans/search_veterans_bloc.dart';
import 'package:veterans/domain/veterans/veterans_bloc.dart';
import 'package:veterans/model/veterans/veteran.dart';
import 'package:veterans/model/veterans/veteran_info_arguments.dart';
import 'package:veterans/view/veterans_page/veterans_list_widget.dart';

import '../search.dart';

class SearchVeteransBlocBuilder extends StatelessWidget
    implements SearchBlocBuilder {
  BuildContext _context;
  List<Veteran> _veterans;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Search(_onChangeSearch)),
            //после получения всех ветеранов, кидаем их на карту
            BlocListener<VeteransBloc, VeteransState>(
              listener: (context, state) {
                if (state is VeteransLazyLoadedState) _veterans = state.veterans;
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Tooltip(
                    message: 'Найти на карте',
                    child: IconButton(
                      onPressed: () {
                        // ignore: close_sinks
                        BlocProvider.of<MapBloc>(context).add(ShowVeteransOnMap());
                        Navigator.of(context).pushNamed('/map',
                            arguments: VeteranInfoArguments(
                                BlocProvider.of<MapBloc>(context)));
                      },
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black26,
                        size: 30,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onChangeSearch(String text) {
    _context.bloc<SearchVeteransBloc>().add(SearchStart(text));
  }
}

class SearchBlocBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchVeteransBloc, SearchVeteransState>(
        builder: (context, state) {
      if (state is SearchVeteransProgress)
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(),
        );
      if (state is SearchVeteransSuccess) {
        return Expanded(
            child: SearchVeteransList(
          veterans: state.veterans,
        ));
      }
      if (state is EmptySearchVeteran) {
        BlocProvider.of<VeteransBloc>(context).add(AppStarted());
        return SizedBox.shrink();
      }
      if (state is NotFoundState) {
        BlocProvider.of<VeteransBloc>(context).add(VeteransNotFound());
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Ветераны не найдены!'),
        );
      } else
        return SizedBox.shrink();
    });
  }
}

class SearchVeteransList extends StatelessWidget {
  List<Veteran> veterans;
  ScrollController _scrollController;
  BuildContext _context;
  final _scrollThreshold = 200.0;

  SearchVeteransList({Key key, this.veterans}) : super(key: key);

  void _setScroll(ScrollController scrollController) {
    _scrollController = scrollController;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    bool hasNext = (BlocProvider.of<SearchVeteransBloc>(_context).state
            as SearchVeteransSuccess)
        .veteransUpdatedAdapter
        .hasNext;
    if (maxScroll - currentScroll <= _scrollThreshold && hasNext) {
      BlocProvider.of<SearchVeteransBloc>(_context).add(SearchFetchVeterans());
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return VeteransListWidget(veterans, _setScroll, 'search_veterans_key');
  }
}
