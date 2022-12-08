import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

import 'layout/shop_app/cubit/cubit.dart';
import 'layout/shop_app/cubit/states.dart';
import 'layout/shop_app/shop_layout.dart';
import 'modules/shop_app/login/shop_login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding_screen.dart';
import 'modules/shop_app/register/cubit/cubit.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  BlocOverrides.runZoned(
        () async {
          WidgetsFlutterBinding.ensureInitialized();
          DioHelper.init();
          await CacheHelper.init();
          Widget widget;
          bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
          token = CacheHelper.getData(key: 'token');
          if (onBoarding != null) {
            if (token != null) {
              widget = ShopLayout();
            }
            else {
              widget = ShopLoginScreen();
            }
          }
          else
            widget = OnBoardingScreen();
          runApp(MyApp(widget: widget,));
        }
  );
}


class MyApp extends StatelessWidget{
  Widget widget;
  MyApp({required this.widget});

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ShopCubit()..getHomeData()..getCategoriesData()..getFavoritesData()..getUserData(),),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: BlocConsumer<ShopCubit,ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home:widget,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: defaultColor,
              appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarBrightness: Brightness.dark,
                ),
                color: Colors.white,
                elevation: 0.0,
                titleSpacing: 14.0,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 24.0,
                ),
              ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: defaultColor,
                unselectedItemColor: Colors.grey,
                selectedIconTheme: IconThemeData(size: 30.0),
              ),

            ),
            );
          }
    )
    );
        }
}