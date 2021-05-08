import 'package:flutter/material.dart';

import 'widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';
import '../model/fabric.dart';
import 'fabric_info_screen.dart';
import 'global/next_page_route.dart';
import '../bloc/bloc.dart';
import '../bloc/fabric_bloc.dart';

class FabricsScreen extends StatefulWidget {
  FabricsScreen({
    Key key,
    this.addFabric,
  }) : super(key: key);

  final Function addFabric;

  @override
  _FabricsScreenState createState() => _FabricsScreenState();
}

class _FabricsScreenState extends State<FabricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Материалы',
        action: (widget.addFabric != null)
            ? []
            : [
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
                        ),
                      ),
                    );
                  },
                ),
              ],
      ),
      body: _Body(
        addFabric: widget.addFabric,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    Key key,
    @required this.addFabric,
  }) : super(key: key);

  final Function addFabric;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  @override
  void dispose() {
    Bloc.bloc.fabricBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder(
        stream: Bloc.bloc.fabricBloc.fabric,
        initialData: FabricInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is FabricInitState) {
            Bloc.bloc.fabricBloc.loadAllFabrics();
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
          addFabric: widget.addFabric,
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
              Bloc.bloc.fabricBloc.loadAllFabrics();
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
    @required this.addFabric,
  }) : super(key: key);

  final Fabric fabric;
  final Function addFabric;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (addFabric != null)
              ? () {
                  addFabric(fabric);
                  Navigator.pop(context);
                }
              : () {
                  Navigator.push(
                    context,
                    NextPageRoute(
                      nextPage: FabricInfoScreen(
                        title: 'Материал',
                        fabric: fabric,
                      ),
                    ),
                  );
                },
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
