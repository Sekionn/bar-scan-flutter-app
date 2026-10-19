import 'package:barscan_app/data/services/auth_api_service.dart';
import 'package:barscan_app/data/services/auth_request_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('uses the backend message for a rejected mobile login', () async {
    final service = AuthApiService(
      client: MockClient(
        (_) async => http.Response(
          '{"message":"This user does not have access to the mobile app."}',
          403,
          headers: const {'content-type': 'application/json'},
        ),
      ),
    );

    expect(
      () => service.login(username: 'company-admin', password: 'password'),
      throwsA(
        isA<AuthRequestException>()
            .having((error) => error.statusCode, 'status code', 403)
            .having(
              (error) => error.message,
              'message',
              'This user does not have access to the mobile app.',
            ),
      ),
    );
  });
}
