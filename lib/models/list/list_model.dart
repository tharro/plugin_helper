import 'package:equatable/equatable.dart';

class ListModel<T> extends Equatable {
  final int? count;
  final String? next;
  final String? previous;
  final List<T>? results;
  final Map<String, dynamic>? params;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String errorMessage;

  ListModel({
    int? count,
    String? next,
    String? previous,
    List<T>? results,
    Map<String, dynamic>? params,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
  })  : results = [],
        count = 0,
        next = null,
        previous = null,
        params = null,
        errorMessage = '',
        isLoading = false,
        isLoadingMore = false,
        isRefreshing = false;

  factory ListModel.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic> json) convert,
      {Map<String, dynamic>? params}) {
    return ListModel(
        count: json['count'],
        next: json['next'] != null
            ? (json['next'] as String).replaceAll('http://', 'https://')
            : null,
        previous: json['previous'] != null
            ? (json['previous'] as String).replaceAll('http://', 'https://')
            : null,
        results: (json['results'] as List).map((e) => convert(e)).toList(),
        params: params);
  }

  ListModel<T> copyWith({
    int? count,
    String? next,
    String? previous,
    List<T>? results,
    Map<String, dynamic>? params,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? errorMessage,
  }) {
    return ListModel(
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      results: results ?? this.results,
      params: params ?? this.params,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        count,
        next,
        previous,
        results,
        params,
        isLoadingMore,
        isLoading,
        isRefreshing,
        errorMessage
      ];
}
