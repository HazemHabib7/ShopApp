import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_app/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../models/change_favorites_model.dart';
import '../../../models/favorites_model.dart';
import '../../../models/home_model.dart';
import '../../../models/login_model.dart';
import '../../../modules/shop_app/categories/categories_screen.dart';
import '../../../modules/shop_app/favorites/fevorites_screen.dart';
import '../../../modules/shop_app/products/products_screen.dart';
import '../../../modules/shop_app/settings/settings_screen.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(context) => BlocProvider.of(context);
  List<Widget> items = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  int currentIndex = 0;


  void changeBottomNav(int index){
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void bottomNav(){
    emit(ShopLoadingHomeDataState());
  }


  HomeModel? homeModel;
  Map<dynamic,dynamic>? favorites = {};
  void getHomeData(){
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(url: HOME,token: token).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favorites!.addAll({
          element.id:element.inFavorites,
        });
      });
      // printFullText(homeModel!.data!.banners.toString());
      emit(ShopSuccessHomeDataState());
    }).catchError((onError){
      emit(ShopErrorHomeDataState());
      print(onError.toString());
    });
  }


  CategoriesModel? categoriesModel;
  void getCategoriesData(){
    DioHelper.getData(url: CATEGORIES,token: token).then((value) {
      categoriesModel = CategoriesModel.formJson(value.data);
      // printFullText(categoriesModel!.data!.banners.toString());
      emit(ShopSuccessCategoriesDataState());
    }).catchError((onError){
      emit(ShopErrorCategoriesDataState());
      print(onError.toString());
    });
  }

  ChangeFavoritesModel? favoritesModel;
  void changeFavorites(int productId){
    favorites![productId] = !favorites![productId];
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
        url: FAVORITES,
        data: {
      'product_id':productId,
        },
        token: token,
    ).then((value) {
      favoritesModel = ChangeFavoritesModel.fromJson(value.data);
        if(favoritesModel!.status == false) {
          favorites![productId] = !favorites![productId];
        }
        else{
          getFavoritesData();
        }
          emit(ShopSuccessChangeFavoritesState(favoritesModel!));
        print(favoritesModel.toString());
    }).catchError((onError){
      emit(ShopErrorChangeFavoritesState());
      print(onError.toString());
    });
  }


  FavoritesModel? favoritesDataModel;
  void getFavoritesData(){
    emit(ShopLoadingFavoritesState());
    DioHelper.getData(url: FAVORITES,token: token).then((value) {
      favoritesDataModel = FavoritesModel.fromJson(value.data);
      // printFullText(homeModel!.data!.banners.toString());
      emit(ShopSuccessFavoritesState());
    }).catchError((onError){
      emit(ShopErrorFavoritesState());
      print(onError.toString());
    });
  }


  ShopLoginModel? userDataModel;
  void getUserData(){
    emit(ShopLoadingUserState());
    DioHelper.getData(url: PROFILE,token: token).then((value) {
      userDataModel = ShopLoginModel.fromjson(value.data);
      // printFullText(homeModel!.data!.banners.toString());
      emit(ShopSuccessUserState());
    }).catchError((onError){
      emit(ShopErrorUserState());
      print(onError.toString());
    });
  }

  void putUserData(
      String name,
      String email,
      String phone,
      ){
    emit(ShopLoadingUpdateState());
    DioHelper.putData(
        url: UPDATE_PROFILE,
        data: {
          'name':name,
          'email':email,
          'phone':phone,
        },
        token: token).then((value) {
      userDataModel = ShopLoginModel.fromjson(value.data);
      // printFullText(homeModel!.data!.banners.toString());
      emit(ShopSuccessUpdateState());
    }).catchError((onError){
      emit(ShopErrorUpdateState());
      print(onError.toString());
    });
  }
}

