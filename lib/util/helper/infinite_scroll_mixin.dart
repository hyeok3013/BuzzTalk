import 'package:flutter/material.dart';

mixin InfiniteScrollMixin<T extends StatefulWidget> on State<T> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      onScrollEnd();
    }
  }

  /// 무한 스크롤 시 호출되는 함수 (상속된 클래스에서 구현해야 함)
  void onScrollEnd();

  /// ScrollController를 반환하는 메서드 (리스트에서 사용 가능)
  ScrollController get scrollController => _scrollController;
}
