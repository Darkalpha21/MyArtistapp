import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:my_artist_demo/app/utility/constant.dart';
import 'package:my_artist_demo/base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'odoo_response.dart';
import 'odoo_version.dart';

class Odoo {
  Odoo({required String url, Base? base}) {
    _serverURL = url;
    _base = base;
  }

  late String _serverURL;
  final Map<String, String> _headers = {};
  OdooVersion version = OdooVersion();
  Base? _base;

  String createPath(String path) {
    return _serverURL + path;
  }

  Future<OdooResponse> getSessionInfo() async {
    var url = createPath("/web/session/get_session_info");
    return await callRequest(url, createPayload({}));
  }

  Future<OdooResponse> destroy() async {
    var url = createPath("/web/session/destroy");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final res = await callRequest(url, createPayload({}));
    prefs.remove("session");
    return res;
  }

  // Authenticate user
  Future<OdooResponse> authenticateMobile(String? username, String? password,
      bool isOTPLogin, String? database) async {
    var url = createPath("/web/session/authenticate/mobile");
    var params = {
      "db": database,
      "login": username,
      isOTPLogin ? "is_otp_login" : "password":
          isOTPLogin ? isOTPLogin : password,
      "context": {}
    };
    final response = await callRequest(url, createPayload(params));
    return response;
  }

  Future<OdooResponse> authenticate(
      String? username, String? password, String? database) async {
    var url = createPath("/web/session/authenticate");
    var params = {
      "db": database,
      "login": username,
      "password": password,
      "context": {}
    };
    final response = await callRequest(url, createPayload(params));
    return response;
  }

  Future<OdooResponse> read(String model, List<int> ids, List<String> fields,
      {dynamic kwargs, Map? context}) async {
    return await callKW(model, "read", [ids, fields],
        kwargs: kwargs, context: context);
  }

  // Future<OdooResponse> searchRead(
  //     String model, List domain, List<String> fields,
  //     {int offset = 0, int limit = 0, String order = ""}) async {
  //   var url = createPath("/web/dataset/search_read");
  //   var params = {
  //     "context": getContext(),
  //     "domain": domain,
  //     "fields": fields,
  //     "limit": limit,
  //     "model": model,
  //     "offset": offset,
  //     "sort": order
  //   };
  //   return await callRequest(url, createPayload(params));
  // }
  Future<OdooResponse> searchRead(
      String model, List domain, List<String> fields,
      {int offset = 0, int limit = 0, String order = "", Map? myContext}) async {
    var params = {
      "domain": domain,
      "fields": fields,
      "offset": offset,
      "limit": limit,
      "order": order
    };
    return await callKW(model, "search_read", [],
        kwargs: params, context: myContext ?? getContext());
  }

  // Call any model method with arguments
  Future<OdooResponse> callKW(String model, String method, List args,
      {dynamic kwargs, Map? context}) async {
    kwargs = kwargs ?? {};
    context = context ?? {};
    var url = createPath("/web/dataset/call_kw/$model/$method");
    var params = {
      "model": model,
      "method": method,
      "args": args,
      "kwargs": kwargs,
      "context": context
    };
    return await callRequest(url, createPayload(params));
  }

  // Create new record for model
  Future<OdooResponse> create(String model, Map values) async {
    return await callKW(model, "create", [values]);
  }

  // Write record with ids and values
  Future<OdooResponse> write(String model, List<int> ids, Map values) async {
    return await callKW(model, "write", [ids, values]);
  }

  // Remove record from system
  Future<OdooResponse> unlink(String model, List<int> ids) async {
    return await callKW(model, "unlink", [ids]);
  }

  // Call json controller
  Future<OdooResponse> callController(String path, Map params) async {
    return await callRequest(createPath(path), createPayload(params));
  }

  // connect to odoo and set version and databases
  Future<OdooVersion> connect() async {
    OdooVersion odooVersion = await getVersionInfo();
    return odooVersion;
  }

  // get version of odoo
  Future<OdooVersion> getVersionInfo() async {
    var url = createPath("/web/webclient/version_info");
    final response = await callRequest(url, createPayload({}));
    version = OdooVersion().parse(response);
    return version;
  }

  Future<OdooResponse> getDatabases() async {
    var serverVersionNumber = await getVersionInfo();

    if (serverVersionNumber.getMajorVersion() == null) {
      version = await getVersionInfo();
    }
    String url = getServerURL();
    var params = {};
    if (serverVersionNumber.getMajorVersion() == 9) {
      url = createPath("/jsonrpc");
      params["method"] = "list";
      params["service"] = "db";
      params["args"] = [];
    } else if (serverVersionNumber.getMajorVersion() >= 10) {
      url = createPath("/web/database/list");
      params["context"] = {};
    } else {
      url = createPath("/web/database/get_list");
      params["context"] = {};
    }
    final response = await callRequest(url, createPayload(params));
    return response;
  }

  String getServerURL() {
    return _serverURL;
  }

  Map createPayload(Map params) {
    return {
      "id": const Uuid().v1(),
      "jsonrpc": "2.0",
      "method": "call",
      "params": params,
    };
  }

  Map getContext() {
    return {"lang": "en_US", "tz": "Europe/Brussels", "uid": 1};
  }

  Future<OdooResponse> callRequest(String url, Map payload) async {
    var body = json.encode(payload);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _headers["Content-type"] = "application/json; charset=UTF-8";
    String? session = prefs.getString("session");
    if (session != null) {
      _headers["Cookie"] = session;
    }
    var response;
    try {
      response = await http.post(Uri.parse(url), body: body, headers: _headers);
      _updateCookies(response);
    } on SocketException catch (e) {
      if (e.osError?.message == "Network is unreachable") {
        _base?.showServerMessage();
      }
    }
    return OdooResponse(json.decode(response.body), response.statusCode);
  }

  _updateCookies(http.Response response) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _headers['Cookie'] = rawCookie;
      prefs.setString(Constants.SESSION, rawCookie);
    }
  }

  Future<OdooResponse> hasRight(String model, List right) {
    var url = createPath("/web/dataset/call_kw");
    var params = {
      "model": model,
      "method": "has_group",
      "args": right,
      "kwargs": {},
      "context": getContext()
    };
    final res = callRequest(url, createPayload(params));
    return res;
  }

  Future<OdooResponse> callRegister(String name, String email, String password, String mobile, String base64String) {
    var url = createPath("/android/register");
    Map<String, dynamic> values = {};
    values["name"] = name;
    values["email"] = email;
    values["password"] = password;
    values["mobile"] = mobile;
    if (base64String != "") {
      values["image"] = base64String;
    }
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callGroup(int userId) async {
    var url = createPath("/web/group");
    var params = {
      "uid": userId
    };
    return await callRequest(url, createPayload(params));
  }

  Future<OdooResponse> sendFCMToken(Map<String, dynamic> values) {
    var url = createPath("/android/register_fcm_token");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callUpdateProfile(Map<String, dynamic> values) {
    var url = createPath("/android/update/user_profile");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callResetPassword(Map<String, dynamic> values) {
    var url = createPath("/android/reset_password");
    final res = callRequest(url, createPayload(values));
    return res;
  }
  Future<OdooResponse> callChangePassword(Map<String, dynamic> values) {
    var url = createPath("/android/change_password");
    final res = callRequest(url, createPayload(values));
    return res;
  }
  Future<OdooResponse> callShowMyProfile(Map<String, dynamic> values) {
    var url = createPath("/android/show/my/profile");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callShowArtists(Map<String, dynamic> values) {
    var url = createPath("/android/show/all/artists");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callShowTalents(Map<String, dynamic> values) {
    var url = createPath("/android/show/all/talent");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callShowTags(Map<String, dynamic> values) {
    var url = createPath("/android/show/all/tags");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> callShowFavorites(Map<String, dynamic> values) {
    var url = createPath("/android/show/my/favorites");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> addRemoveFavorites(Map<String, dynamic> values) {
    var url = createPath("/android/add/favorites");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> searchArtist(Map<String, dynamic> values) {
    var url = createPath("/android/search/all/artists");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> showCompany(Map<String, dynamic> values) {
    var url = createPath("/android/show/company");
    final res = callRequest(url, createPayload(values));
    return res;
  }

  Future<OdooResponse> showAttachments(Map<String, dynamic> values) {
    var url = createPath("/android/show/attachments");
    final res = callRequest(url, createPayload(values));
    return res;
  }
}
