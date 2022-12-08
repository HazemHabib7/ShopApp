import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/login/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import '../../../../models/login_model.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  late ShopLoginModel? shopLoginModel;

  void is1password (){
    isPassword = !isPassword;
    emit(IsPasswordState());
  }

  void login({
    required String email,
    required String password,
}){
    emit(LoginLoadingState());
    DioHelper.postData(
        url: 'login',
        data: {
          'email':email,
          'password':password,
        }).then((value) {
      // defaultToast(message: 'Successfully', state: ToastStates.SUCCESS);
      shopLoginModel=ShopLoginModel.fromjson(value.data);
      emit(LoginSuccessState(shopLoginModel!));

    }).catchError((onError){
      // defaultToast(message: onError.toString(), state: ToastStates.ERROR);
      print("Error: " + onError.toString());
      emit(LoginErrorState());
    });
  }
}