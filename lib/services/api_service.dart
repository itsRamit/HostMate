import 'package:dio/dio.dart';
import 'package:host_mate/models/experience.dart';

class ApiService {
  final Dio _dio;
  ApiService([Dio? dio]) : _dio = dio ?? Dio();

  Future<List<Experience>> fetchExperiences() async {
    final response = await _dio.get(
      'https://staging.chamberofsecrets.8club.co/v1/experiences',
      queryParameters: {'active': true},
    );
    final data = response.data as Map<String, dynamic>;
    final experiences = (data['data']?['experiences'] as List<dynamic>?) ?? [];
    return experiences
        .map((e) => Experience.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
