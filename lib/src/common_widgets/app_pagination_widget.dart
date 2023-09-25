import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AppPaginationWidget extends StatefulWidget {
  const AppPaginationWidget(
      {Key? key,
      required this.child,
      required this.onLoading,
      this.enableLoadingOnScrollStart = false,
      this.enablePullDown = false,
      this.onRefresh})
      : super(key: key);
  final Widget child;
  final Future<bool> Function() onLoading;
  final Future<bool> Function()? onRefresh;

  final bool enableLoadingOnScrollStart;
  final bool enablePullDown;

  @override
  State<AppPaginationWidget> createState() => _AppPaginationWidgetState();
}

class _AppPaginationWidgetState extends State<AppPaginationWidget> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> _onLoading() async {
    if (await widget.onLoading()) {
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }
  }

  Future<void> _onRefresh() async {
    if (await widget.onRefresh!()) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: widget.enableLoadingOnScrollStart
          ? (notification) {
              if (notification.metrics.axisDirection == AxisDirection.down) {
                _onLoading();
                return true;
              }
              return false;
            }
          : null,
      child: SmartRefresher(
        enablePullDown: widget.enablePullDown,
        enablePullUp: true,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            return SizedBox(
              height: 55.0,
              child: Center(
                child: mode == LoadStatus.loading
                    ? const CircularProgressIndicator.adaptive()
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        header: CustomHeader(
          builder: (context, mode) {
            return SizedBox(
              height: 55.0,
              child: Center(
                child: mode == RefreshStatus.refreshing
                    ? const CircularProgressIndicator.adaptive()
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
        controller: _refreshController,
        onLoading: widget.enableLoadingOnScrollStart ? null : _onLoading,
        onRefresh: widget.enablePullDown ? _onRefresh : null,
        primary: false,
        child: widget.child,
      ),
    );
  }
}
