import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:maids_project/shared/components/Imports/default_imports.dart';
import 'package:maids_project/shared/network/end_points.dart';

void main()
{
  late Dio dio;
  late DioAdapter dioAdapter;
  Response<dynamic> response;

  late AppCubit appCubit;

  setUp(() {
    appCubit = AppCubit();
    dio = Dio(BaseOptions(baseUrl: localhost, receiveDataWhenStatusError: true,));
    dioAdapter = DioAdapter(dio: dio);

    dio.options.headers=
    {
      'Accept':'application/json',
      'Connection' : 'keep-alive',
    };

  });

  tearDown(() {
    appCubit.close();
    dio.close();
    dioAdapter.close();
  });

  group('Network', ()
  {
    test('Login With Correct Username and password', ()async
    {

      //Correct data to login
      const userCredentials = <String, dynamic>{
        'username':'emilys',
        'password': 'emilyspass',
      };

      dioAdapter.onPost(
          login,
          (server)=>server.reply(201,null),
          data: userCredentials,
      );

      // Returns a response with 201 Created success status response code.
      response = await dio.post(login, data: userCredentials);
      expect(response.statusCode, 201);
    });

    test('Login With False Username and password', ()async
    {

      //Correct data to login
      const userCredentials = <String, dynamic>{
        'username':'wrong',
        'password': '123',
      };

      //Allow Dio to pass the data of 404 values
      dio.options.validateStatus=(status)
      {
        return [200,201,400,404].contains(status)
          ?true
          :false;
      };

      dioAdapter.onPost(
        login,
            (server)=>server.reply(400,null),
        data: userCredentials,
      );

      // Returns a response with 201 Created success status response code.
      response = await dio.post(login, data: userCredentials, );
      expect(response.statusCode, 400);
    });

    test('Get All Todos', ()async
    {
      dioAdapter.onGet(
        allTodosEndpoint,
        (server)=>server.reply(200,null),
        queryParameters: {
          'limit':20,
          'skip': 0
        },
      );

      response = await dio.get(allTodosEndpoint, queryParameters: {'limit':20, 'skip':0});
      expect(response.statusCode,200);

    });
  });
}