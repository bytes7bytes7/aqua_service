import 'package:aqua_service/bloc/fabric_bloc.dart';
import 'package:aqua_service/model/fabric.dart';
import 'package:aqua_service/repository/fabric_repository.dart';
import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';
import 'widgets/search_bar.dart';

class FabricsScreen extends StatefulWidget {
  const FabricsScreen(this._repo);

  final FabricRepository _repo;

  @override
  _FabricsScreenState createState() => _FabricsScreenState();
}

class _FabricsScreenState extends State<FabricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Материалы'),
      body: _Body(widget._repo),
    );
  }
}


class _Body extends StatefulWidget {
  const _Body(this._repo);

  final FabricRepository _repo;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  FabricBloc _fabricBloc;

  @override
  void initState() {
    _fabricBloc = FabricBloc(widget._repo);
    super.initState();
  }

  @override
  void dispose() {
    _fabricBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          SearchBar(),
          //SortBar(),
          Expanded(
            child: StreamBuilder(
              stream: _fabricBloc.fabric,
              initialData: FabricInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is FabricInitState) {
                  _fabricBloc.loadAllFabrics();
                  return SizedBox.shrink();
                } else if (snapshot.data is FabricLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is FabricDataState) {
                  FabricDataState state = snapshot.data;
                  return _buildContent(state.fabrics);
                } else {
                  return _buildError();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: LoadingCircle(),
    );
  }

  Widget _buildContent(List<Fabric> fabrics) {
    return ListView.builder(
      itemCount: fabrics.length,
      itemBuilder: (context, i) {
        return SizedBox.shrink();
        // return _FabricCard(
        //   fabric: fabrics[i],
        // );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка',
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(height: 20),
          RectButton(
            text: 'Обновить',
            onPressed: () {
              _fabricBloc.loadAllFabrics();
            },
          ),
        ],
      ),
    );
  }
}