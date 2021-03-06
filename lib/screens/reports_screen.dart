import 'package:flutter/material.dart';

import '../widgets/error_label.dart';
import '../widgets/app_header.dart';
import '../widgets/empty_label.dart';
import '../widgets/loading_circle.dart';
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
      child: StreamBuilder(
        stream: Bloc.bloc.reportBloc.report,
        initialData: ReportInitState(),
        builder: (context, snapshot) {
          if (snapshot.data is ReportInitState) {
            Bloc.bloc.reportBloc.loadAllReports();
            return SizedBox.shrink();
          } else if (snapshot.data is ReportLoadingState) {
            return LoadingCircle();
          } else if (snapshot.data is ReportDataState) {
            ReportDataState state = snapshot.data as ReportDataState;
            if (state.reports.length > 0) {
              return _ReportList(reports: state.reports);
            } else {
              return EmptyLabel();
            }
          } else {
            return ErrorLabel(
              error: snapshot.error as Error,
              stackTrace: snapshot.stackTrace as StackTrace,
              onPressed: () {
                Bloc.bloc.reportBloc.loadAllReports();
              },
            );
          }
        },
      ),
    );
  }
}

class _ReportList extends StatelessWidget {
  const _ReportList({
    Key? key,
    required this.reports,
  }) : super(key: key);

  final List<Report> reports;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, i) {
        return _ReportCard(
          report: reports[i],
        );
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    Key? key,
    required this.report,
  }) : super(key: key);

  final Report report;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            child: Row(
              children: [
                Container(
                  width: size.width*0.4,
                  child: Text(
                    report.timePeriod!,
                    style: Theme.of(context).textTheme.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Container(
                  width: size.width*0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+${report.profit}',
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        (report.expenses != 0)
                            ? '-${report.expenses}'
                            : report.expenses.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
