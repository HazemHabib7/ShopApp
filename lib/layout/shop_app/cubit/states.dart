import '../../../models/change_favorites_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ChangeBottomNavBarState extends ShopStates {}

class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {}

class ShopSuccessCategoriesDataState extends ShopStates {}

class ShopErrorCategoriesDataState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  final ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {}

class ShopChangeFavoritesState extends ShopStates {}

class ShopErrorFavoritesState extends ShopStates {}

class ShopSuccessFavoritesState extends ShopStates {}

class ShopLoadingFavoritesState extends ShopStates {}

 class ShopErrorUpdateState extends ShopStates {}

class ShopSuccessUpdateState extends ShopStates {}

class ShopLoadingUpdateState extends ShopStates {}

class ShopErrorUserState extends ShopStates {}

class ShopSuccessUserState extends ShopStates {}

class ShopLoadingUserState extends ShopStates {}

