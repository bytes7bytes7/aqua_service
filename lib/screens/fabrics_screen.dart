import 'package:aqua_service/bloc/fabric_bloc.dart';
import 'package:aqua_service/model/fabric.dart';
import 'package:aqua_service/repository/fabric_repository.dart';
import 'package:aqua_service/repository/repository.dart';
import 'package:flutter/material.dart';

import '../screens/widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';
import 'widgets/search_bar.dart';

class FabricsScreen extends StatefulWidget {
  const FabricsScreen({
    Key key,
    this.forChoice = false,
  }) : super(key: key);

  final bool forChoice;

  @override
  _FabricsScreenState createState() => _FabricsScreenState();
}

class _FabricsScreenState extends State<FabricsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Материалы'),
      body: _Body(forChoice: widget.forChoice),
    );
  }
}

class _Body extends StatefulWidget {
  _Body({
    Key key,
    @required this.forChoice,
  }) : super(key: key);

  final bool forChoice;
  final FabricRepository _repo = Repository.fabricRepository;

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
        return _FabricCard(
          fabric: fabrics[i],
          forChoice: widget.forChoice,
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
              _fabricBloc.loadAllFabrics();
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
  }) : super(key: key);

  final Fabric fabric;
  final bool forChoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: (!forChoice) ? () {
            // Navigator.push(
            //   context,
            //   NextPageRoute(
            //     nextPage: FabricInfoScreen(
            //       title: 'Заказ',
            //       fabric: fabric,
            //     ),
            //   ),
            // );
          } : () {},
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
