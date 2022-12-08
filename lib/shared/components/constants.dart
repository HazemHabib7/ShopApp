import '../../modules/shop_app/login/shop_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context){

    CacheHelper.removeData(key: 'token').then((value) {
      navigateAndFinish(context, ShopLoginScreen());
    });}


String? token;
