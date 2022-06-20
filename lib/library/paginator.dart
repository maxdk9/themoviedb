// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:themoviedb/domain/api_client/api_client.dart';

typedef PaginatorLoad<T> = Future<PaginatorLoadResult<T>> Function(int);

class PaginatorLoadResult<T> {
  final List<T> data;
  final int currentPage;
  final int totalPage;
  PaginatorLoadResult({
    required this.data,
    required this.currentPage,
    required this.totalPage,
  });
}

class Paginator<T> {
  final _data = <T>[];
  late int _currentPage;
  late int _totalPage;
  bool _isLoadingInProgress = false;
  final PaginatorLoad<T> load;

  Paginator({
    required this.load,
  });

  List<T> get data => _data;

  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) {
      return;
    }
    _isLoadingInProgress = true;
    final int nextPage = _currentPage + 1;

    try {
      final result = await load(nextPage);
      _data.addAll(result.data);
      _currentPage = result.currentPage;
      _totalPage = result.totalPage;
      _isLoadingInProgress = false;

      // _data.addAll(
      //     result.movies.map((movie) => makeRowData(movie)).toList());
    } catch (e) {
      _isLoadingInProgress = false;
    }
  }

  Future<void> resetList() async {
    _currentPage = 0;
    _totalPage = 1;
    _data.clear();
    await loadNextPage();
  }
}
