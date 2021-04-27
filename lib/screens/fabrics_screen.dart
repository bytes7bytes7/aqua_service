import 'package:flutter/material.dart';

import '../bloc/fabric_bloc.dart';
import '../model/fabric.dart';
import '../repository/repository.dart';
import '../screens/widgets/app_header.dart';
import 'fabric_info_screen.dart';
import 'global/next_page_route.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';
import 'widgets/search_bar.dart';

class FabricsScreen extends StatefulWidget {
  FabricsScreen({
    Key key,
    this.forChoice = false,
  }) : super(key: key);

  final bool forChoice;
  final _repo = Repository.fabricRepository;

  @override
  _FabricsScreenState createState() => _FabricsScreenState();
}

class _FabricsScreenState extends State<FabricsScreen> {
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
    return Scaffold(
      appBar: AppHeader(
        title: 'Материалы',
        action: [
          IconButton(
            icon: Icon(Icons.add,
                color: Theme.of(context).focusColor, size: 32.0),
            onPressed: () {
              Navigator.push(
                context,
                NextPageRoute(
                  nextPage: FabricInfoScreen(
                    title: 'Новый Материал',
                    fabric: Fabric(),
                    bloc: _fabricBloc,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _Body(
        forChoice: widget.forChoice,
        bloc: _fabricBloc,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.forChoice,
    @required this.bloc,
  }) : super(key: key);

  final bool forChoice;
  final FabricBloc bloc;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
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
              stream: widget.bloc.fabric,
              initialData: FabricInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is FabricInitState) {
                  widget.bloc.loadAllFabrics();
                  return SizedBox.shrink();
                } else if (snapshot.data is FabricLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is FabricDataState) {
                  FabricDataState state = snapshot.data;
                  if (state.fabrics.length > 0)
                    return _buildContent(state.fabrics);
                  else
                    return Center(
                      child: Text(
                        'Пусто',
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    );
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
        return _FabricCard(
          fabric: fabrics[i],
          forChoice: widget.forChoice,
          bloc: widget.bloc,
        );
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
              widget.bloc.loadAllFabrics();
            },
          ),
        ],
      ),
    );
  }
}

class _FabricCard extends StatelessWidget {
  const _FabricCard({
    Key key,
    @required this.fabric,
    @required this.forChoice,
    @required this.bloc,
  }) : super(key: key);

  final Fabric fabric;
  final bool forChoice;
  final FabricBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (!forChoice)
              ? () {
                  Navigator.push(
                    context,
                    NextPageRoute(
                      nextPage: FabricInfoScreen(
                        title: 'Материал',
                        fabric: fabric,
                        bloc: bloc,
                      ),
                    ),
                  );
                }
              : () {},
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            width: double.infinity,
            child: Row(
              children: [
                SizedBox(width: 14.0),
                Text(
                  '${fabric.title}',
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
