import 'dart:convert';
import 'package:alarm_app/src/repository/http_request.dart' as http;
import 'package:alarm_app/src/model/msg_model.dart';
import 'package:alarm_app/src/repository/http_request.dart';

class MsgRepository {
  final Http httpRequest;

  MsgRepository(this.httpRequest);
}
