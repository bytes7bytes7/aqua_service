import 'package:flutter/material.dart';

import 'widgets/app_header.dart';
import 'widgets/loading_circle.dart';
import 'widgets/rect_button.dart';
import '../bloc/bloc.dart';
import '../bloc/report_bloc.dart';
import '../model/report.dart';

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
  @override
  __BodyState createState() => __BodyState();
}

class __BodyState extends State<_Body> {

  @override
  void dispose() {
    Bloc.bloc.reportBloc.dispose();
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
              stream: Bloc.bloc.reportBloc.report,
              initialData: ReportInitState(),
              builder: (context, snapshot) {
                if (snapshot.data is ReportInitState) {
                  Bloc.bloc.reportBloc.loadAllReports();
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
                Bloc.bloc.reportBloc.loadAllReports();
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
