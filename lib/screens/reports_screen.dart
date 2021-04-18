import 'package:aqua_service/bloc/report_bloc.dart';
import 'package:aqua_service/model/report.dart';
import 'package:flutter/material.dart';

import '../repository/report_repository.dart';
import '../repository/repository.dart';
import '../screens/widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Отчеты'),
      body: _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  final ReportRepository _repo = Repository.reportRepository;

  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  ReportBloc _reportBloc;

  @override
  void initState() {
    _reportBloc = ReportBloc(widget._repo);
    super.initState();
  }

  @override
  void dispose() {
    _reportBloc.dispose();
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
          Expanded(
            child: StreamBuilder(
              stream: _reportBloc.report,
              initialData: ReportInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is ReportInitState) {
                  _reportBloc.loadAllReports();
                  return SizedBox.shrink();
                } else if (snapshot.data is ReportLoadingState) {
                  return _buildLoading();
                } else if (snapshot.data is ReportDataState) {
                  ReportDataState state = snapshot.data;
                  return _buildContent(state.reports);
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

  Widget _buildContent(List<Report> reports) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, i) {
        return _ReportCard(
          report: reports[i],
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
                _reportBloc.loadAllReports();
              }),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    Key key,
    @required this.report,
  }) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {},
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            width: double.infinity,
            child: Text(
              '${report.timePeriod} : ${report.profit}',
              style: Theme.of(context).textTheme.bodyText1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
