import 'package:equatable/equatable.dart';

/// Retrieve list data from the server.
class ListModel<T> extends Equatable {
  /// Total row of the list on the database.
  final int? count;

  /// A URL to get more data from the server.
  final String? next;

  // Deprecation
  final String? previous;

  /// List data with custom model.
  final List<T>? results;

  /// Add parameters when searching or filtering.
  final Map<String, dynamic>? params;

  /// Waiting for server.
  final bool isLoading;

  /// Loading more data from the server.
  final bool isLoadingMore;

  /// Refreshing from the server.
  final bool isRefreshing;

  /// Error message from the server.
  final String errorMessage;

  const ListModel({
    this.count,
    this.next,
    this.previous,
    this.results,
    this.params,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.errorMessage = '',
  });

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
      params: params,
      errorMessage: '',
      isLoading: false,
      isLoadingMore: false,
      isRefreshing: false,
    );
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
