import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:polinizador_dashboard_app/theme.dart';
import 'package:polinizador_dashboard_app/utils/adaptive.dart';
import 'package:polinizador_dashboard_app/widgets/ProductCard.dart';

import '../data.dart';

class HighlightsView extends StatefulWidget {
  HighlightsView({Key key}) : super(key: key);

  @override
  _HighlightsViewState createState() => _HighlightsViewState();
}

class _HighlightsViewState extends State<HighlightsView> {

  @override
  Widget build(BuildContext context) {
    final alerts = DummyDataService.getAlerts(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Em destaque", style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: isDisplayDesktop(context) ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 7,
                child: Semantics(
                  sortKey: const OrdinalSortKey(1, name: "highlights"),
                  child: const _OverviewGrid(spacing: 24),
                ),
              ),
              const SizedBox(width: 24),
              Flexible(
                flex: 3,
                child: Container(
                  width: 400,
                  child: Semantics(
                    sortKey: const OrdinalSortKey(2, name: "highlights"),
                    child: FocusTraversalGroup(
                      child: _AlertsView(alerts: alerts),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              _AlertsView(alerts: alerts.sublist(0, 1)),
              const SizedBox(height: 12),
              const _OverviewGrid(spacing: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({Key key, @required this.spacing}) : super(key: key);

  final double spacing;

  List<Widget> _buildCardList() {
    List<Widget> productList = [
      ProductCard("AirFryer"),
      ProductCard("Samsung Laptop")
    ];
    return productList.map((item) => Container(
      child: Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: item
          )
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {

      // Only display multiple columns when the constraints allow it and we
      // have a regular text scale factor.
      final minWidthForTwoColumns = 600;
      final hasMultipleColumns = isDisplayDesktop(context) &&
          constraints.maxWidth > minWidthForTwoColumns;
      final boxWidth = hasMultipleColumns
          ? constraints.maxWidth / 2 - spacing / 2
          : double.infinity;

      return Wrap(
        runSpacing: spacing,
        children: [
          Container(
            width: boxWidth,
            child: Card(
              color: PolinizadorColors.cardBackground,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      alignment: Alignment.center,
                      width: 600,
                      height: 50,
                      color: PolinizadorColors.gray25,
                      child: Text("Mais vendidos", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      enableInfiniteScroll: true,
                      height: 200,
                    ),
                    items: _buildCardList()
                  ),
                ]
              )
            ),
          ),
          if (hasMultipleColumns) SizedBox(width: spacing),
          Container(
            width: boxWidth,
            child: Card(
                color: PolinizadorColors.cardBackground,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          alignment: Alignment.center,
                          width: 600,
                          height: 50,
                          color: PolinizadorColors.gray25,
                          child: Text("Mais visualizados", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ),
                      ),
                      CarouselSlider(
                          options: CarouselOptions(
                            enableInfiniteScroll: true,
                            height: 200,
                          ),
                          items: _buildCardList()
                      ),
                    ]
                )
            )
          ),
        ],
      );
    });
  }
}

class _AlertsView extends StatelessWidget {
  const _AlertsView({Key key, this.alerts}) : super(key: key);

  final List<AlertData> alerts;

  @override
  Widget build(BuildContext context) {
    final isDesktop = isDisplayDesktop(context);

    return Container(
      padding: const EdgeInsetsDirectional.only(start: 16, top: 4, bottom: 4),
      color: PolinizadorColors.cardBackground,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
            isDesktop ? const EdgeInsets.symmetric(vertical: 16) : null,
            child: MergeSemantics(
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text("Alertas", style: TextStyle(fontWeight: FontWeight.bold),),
                  if (!isDesktop)
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {},
                      child: Text("Ver tudo"),
                    ),
                ],
              ),
            ),
          ),
          for (AlertData alert in alerts) ...[
            Container(color: PolinizadorColors.primaryBackground, height: 1),
            _Alert(alert: alert),
          ]
        ],
      ),
    );
  }
}

class _Alert extends StatelessWidget {
  const _Alert({
    Key key,
    @required this.alert,
  }) : super(key: key);

  final AlertData alert;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: isDisplayDesktop(context)
            ? const EdgeInsets.symmetric(vertical: 8)
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(alert.message),
            ),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(alert.iconData, color: PolinizadorColors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}