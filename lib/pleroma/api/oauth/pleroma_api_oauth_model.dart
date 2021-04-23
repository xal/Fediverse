import 'dart:convert';

import 'package:fedi/json/json_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

// ignore_for_file: no-magic-number
part 'pleroma_api_oauth_model.g.dart';

@JsonSerializable(explicitToJson: true)
// -32 is hack for hive 0.x backward ids compatibility
// see reservedIds in Hive,
// which not exist in Hive 0.x
//@HiveType()
@HiveType(typeId: -32 + 51)
class PleromaOAuthToken implements IJsonObject {
  @HiveField(0)
  @JsonKey(name: "access_token")
  final String accessToken;
  @HiveField(1)
  @JsonKey(name: "token_type")
  final String tokenType;

  @HiveField(2)
  final dynamic scope;
  @JsonKey(name: "created_at")
  @HiveField(3)
  final dynamic createdAt;

  PleromaOAuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.scope,
    required this.createdAt,
  });

  @override
  String toString() {
    return 'PleromaOAuthToken{accessToken: $accessToken,'
        ' tokenType: $tokenType, scope: $scope, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PleromaOAuthToken &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          tokenType == other.tokenType &&
          scope == other.scope &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      accessToken.hashCode ^
      tokenType.hashCode ^
      scope.hashCode ^
      createdAt.hashCode;

  factory PleromaOAuthToken.fromJson(Map<String, dynamic> json) =>
      _$PleromaOAuthTokenFromJson(json);

  factory PleromaOAuthToken.fromJsonString(String jsonString) =>
      _$PleromaOAuthTokenFromJson(jsonDecode(jsonString));

  @override
  Map<String, dynamic> toJson() => _$PleromaOAuthTokenToJson(this);
}

@JsonSerializable()
class PleromaOAuthAuthorizeRequest {
  @JsonKey(name: "force_login")

  /// Forces the user to re-login,
  /// which is necessary for authorizing with multiple accounts from the same instance.

  final bool? forceLogin;
  @JsonKey(name: "response_type")

  ///  should be always code for this request

  final String? responseType;

  /// from application object
  @JsonKey(name: "client_id")
  final String? clientId;
  @JsonKey(name: "redirect_uri")

  /// Set a URI to redirect the user to.
  /// If this parameter is set to urn:ietf:wg:oauth:2.0:oob
  /// then the authorization code will be shown instead.
  /// Must match one of the redirect URIs declared during app registration.

  final String? redirectUri;

  /// List of requested OAuth scopes, separated by spaces (or by pluses,
  /// if using query parameters). Must be a subset of scopes declared during
  /// app registration. If not provided, defaults to read.
  final String? scope;

  PleromaOAuthAuthorizeRequest({
    required this.forceLogin,
    required this.clientId,
    required this.redirectUri,
    required this.scope,
    this.responseType = "code",
  });

  factory PleromaOAuthAuthorizeRequest.fromJsonString(String jsonString) =>
      _$PleromaOAuthAuthorizeRequestFromJson(jsonDecode(jsonString));

  factory PleromaOAuthAuthorizeRequest.fromJson(Map<String, dynamic> json) =>
      _$PleromaOAuthAuthorizeRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaOAuthAuthorizeRequestToJson(this);
}

@JsonSerializable()
class PleromaOAuthAccountTokenRequest {
  @JsonKey(name: "grant_type")
  final String? grantType;

  /// A user authorization code, obtained via /oauth/authorize
  final String? code;

  final String? scope;

  @JsonKey(name: "redirect_uri")
  final String? redirectUri;

  @JsonKey(name: "client_id")
  String? clientId;
  @JsonKey(name: "client_secret")
  String? clientSecret;

  PleromaOAuthAccountTokenRequest({
    required this.code,
    required this.scope,
    required this.redirectUri,
    required this.clientId,
    required this.clientSecret,
    this.grantType = "authorization_code",
  });

  @override
  String toString() {
    return 'PleromaOAuthAuthTokenRequest{grantType: $grantType, '
        'code: $code, scope: $scope, redirectUri: $redirectUri, '
        'clientId: $clientId, clientSecret: $clientSecret}';
  }

  factory PleromaOAuthAccountTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PleromaOAuthAccountTokenRequestFromJson(json);

  factory PleromaOAuthAccountTokenRequest.fromJsonString(String jsonString) =>
      _$PleromaOAuthAccountTokenRequestFromJson(jsonDecode(jsonString));

  Map<String, dynamic> toJson() =>
      _$PleromaOAuthAccountTokenRequestToJson(this);
}

@JsonSerializable()
class PleromaOAuthAppTokenRequest {
  @JsonKey(name: "grant_type")
  final String? grantType;

  final String? scope;

  @JsonKey(name: "redirect_uri")
  final String? redirectUri;

  @JsonKey(name: "client_id")
  String? clientId;
  @JsonKey(name: "client_secret")
  String? clientSecret;

  PleromaOAuthAppTokenRequest({
    this.scope,
    this.redirectUri,
    this.clientId,
    this.clientSecret,
    this.grantType = "client_credentials",
  });

  @override
  String toString() {
    return 'PleromaOAuthAppTokenRequest{grantType: $grantType, '
        ' scope: $scope, redirectUri: $redirectUri, '
        'clientId: $clientId, clientSecret: $clientSecret}';
  }

  factory PleromaOAuthAppTokenRequest.fromJsonString(String jsonString) =>
      _$PleromaOAuthAppTokenRequestFromJson(jsonDecode(jsonString));

  factory PleromaOAuthAppTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$PleromaOAuthAppTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PleromaOAuthAppTokenRequestToJson(this);
}

@JsonSerializable()
class PleromaOAuthAppTokenRevokeRequest {
  @JsonKey(name: "client_id")
  String? clientId;
  @JsonKey(name: "client_secret")
  String? clientSecret;

  String? token;

  PleromaOAuthAppTokenRevokeRequest({
    required this.clientId,
    required this.clientSecret,
    required this.token,
  });

  @override
  String toString() {
    return 'PleromaOAuthAppTokenRevokeRequest{clientId: $clientId,'
        ' clientSecret: $clientSecret, token: $token}';
  }

  factory PleromaOAuthAppTokenRevokeRequest.fromJsonString(String jsonString) =>
      _$PleromaOAuthAppTokenRevokeRequestFromJson(jsonDecode(jsonString));

  factory PleromaOAuthAppTokenRevokeRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PleromaOAuthAppTokenRevokeRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PleromaOAuthAppTokenRevokeRequestToJson(this);
}