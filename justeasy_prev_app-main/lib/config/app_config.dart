import 'package:justeasy/helpers/console.dart';

class AppConfig {
  // static const mainUrl = 'http://192.168.0.100:5000';
  // static const mainUrl = 'http://192.168.0.101:5000';
  static const mainUrl = 'http://3.110.6.209';
  static const host = "${mainUrl}/api";
  static const googlePlacesApi = "";
  static const String LINKEDIN_SECRET = 'LmDdfKUps7DN7Qdh';
  static const String LINKEDIN_CLIENT_ID = '86gyxbd72ujk9r';
  static const String LINKED_REDIRECT_URL = 'http://3.110.6.209/index';
  static const String LINKEDIN_SCOPE = 'r_liteprofile r_emailaddress';

  // static const redis_host = "ec2-3-111-1-172.ap-south-1.compute.amazonaws.com";
  // static const redis_host = "192.168.0.101";
  static const redis_host = "54.191.65.54";
static const redis_port = "6379";
// static const redis_port = "4545";

  static Map<String, String> getApiHeader(String? token) {
    if (token != null) {
      return {
        "Content-type": "application/x-www-form-urlencoded",
        'Authorization': token,
      };
    }
    return {"Content-type": "application/x-www-form-urlencoded"};
  }

  static Uri get linkedinAuthUrl {
    Map<String, String> params = {
      'response_type': 'code',
      'client_id': LINKEDIN_CLIENT_ID,
      'redirect_uri': LINKED_REDIRECT_URL,
      'state': 'imaginar.in',
      'scope': LINKEDIN_SCOPE
    };
    Uri uri = Uri.https('linkedin.com', 'oauth/v2/authorization', params);
    return uri;
  }
}
