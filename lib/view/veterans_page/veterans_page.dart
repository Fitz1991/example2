import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:veterans/data/firebase_providers/veterans_firestore_provider.dart';
import 'package:veterans/data/repositories/veterans/firestore_veterans_repository.dart';
import 'package:veterans/domain/maps/map_bloc.dart';
import 'package:veterans/domain/search/veterans/search_veterans_bloc.dart';
import 'package:veterans/domain/veterans/veterans_bloc.dart';
import 'package:veterans/view/veterans_page/search_veterans_bloc_builder.dart';
import 'package:veterans/view/veterans_page/veterans_list_widget.dart';

class VeteransPage extends StatelessWidget {
  final FirestoreVeteransRepository _veteransRepository =
      FirestoreVeteransRepository(VeteransProvider());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapBloc>(
          create: (context) => MapBloc(FirestoreVeteransRepository(VeteransProvider())),
        ),
        BlocProvider<VeteransBloc>(
          create: (BuildContext context) =>
              VeteransBloc(veteransRepository: _veteransRepository)
                ..add(AppStarted()),
        ),
        BlocProvider<SearchVeteransBloc>(
          create: (context) =>
              SearchVeteransBloc(veteransRepository: _veteransRepository),
        ),
      ],
      child: Container(
        child: Column(children: [
          Row(
            children: [
              Expanded(child: SearchVeteransBlocBuilder()),
            ],
          ),
          SearchBlocBuilder(),
          BlocListener<SearchVeteransBloc, SearchVeteransState>(
            listener: (context, state) {
              if (state is SearchVeteransSuccess) {
                BlocProvider.of<VeteransBloc>(context).add(VeteransEmptyPageEvent());
              }
            },
            child: VeteransList(),
          ),
        ]),
      ),
    );
  }
}

class VeteransList extends StatelessWidget {
  ScrollController _scrollController;
  BuildContext _context;
  final _scrollThreshold = 200.0;

  VeteransList({Key key}) : super(key: key);

  void _setScroll(ScrollController scrollController) {
    _scrollController = scrollController;
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    bool hasNext =
        (BlocProvider.of<VeteransBloc>(_context).state as VeteransLazyLoadedState)
            .veteransUpdatedAdapter
            .hasNext;
    if (maxScroll - currentScroll <= _scrollThreshold && hasNext) {
      BlocProvider.of<VeteransBloc>(_context).add(FetchVeterans());
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return BlocBuilder<VeteransBloc, VeteransState>(builder: (context, state) {
      if (state is VeteransInitialState) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is VeteransLazyLoadedState) {
        return Expanded(
            child: VeteransListWidget(state.veterans, _setScroll, 'veterans_key'));
      }
      if (state is VeteransEmptyState) {
        return SizedBox.shrink();
      } else {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
