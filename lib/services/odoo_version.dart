import 'odoo_response.dart';

class OdooVersion {
  var _version, _server_serie, _protocol_version;
  var _major, _minor, _micro, _release_level, _serial;
  bool _isEnterprise = false;

  String getVersionInfo() {
    return _version;
  }

  int getServerSerie() {
    return _server_serie;
  }

  int getProtocolVersion() {
    return _protocol_version;
  }

  dynamic getMajorVersion() {
    return _major;
  }

  int getMinorVersion() {
    return _minor;
  }

  int getMicroVersion() {
    return _micro;
  }

  String getReleaseLevel() {
    return _release_level;
  }

  String getSerial() {
    return _serial;
  }

  bool isEnterprise() {
    return _isEnterprise;
  }

  OdooVersion parse(OdooResponse response) {
    Map result = response.getResult();
    _version = result['server_version'];
    _server_serie = result['server_serie'];
    _protocol_version = result['protocol_version'];
    List<dynamic> versionInfo = result['server_version_info'];
    if (versionInfo.length == 6) {
      _isEnterprise = versionInfo.last == "e";
    }
    _major = versionInfo[0];
    _minor = versionInfo[1];
    _micro = versionInfo[2];
    _release_level = versionInfo[3];
    _serial = versionInfo[4];
    return this;
  }

  @override
  String toString() {
    if (_version != null) {
      return "$_version (${_isEnterprise ? 'Enterprise' : 'Community'})";
    }
    return "Not Connected: Please call connect() or getVersionInfo() with callback.";
  }
}
