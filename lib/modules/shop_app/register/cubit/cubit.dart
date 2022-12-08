import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/shop_app/register/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import '../../../../models/login_model.dart';
import '../../../../shared/network/end_points.dart';
import '../../../../shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());
  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  late ShopLoginModel? shopLoginModel;

  void is1password (){
    isPassword = !isPassword;
    emit(RegisterIsPasswordState());
  }

  void register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }){
    emit(RegisterLoadingState());
    DioHelper.postData(
        url: REGISTER,
        data: {
          'name':name,
          'email':email,
          'password':password,
          'phone':phone,
        }).then((value) {
          shopLoginModel=ShopLoginModel.fromjson(value.data);
          defaultToast(message: 'Successfully', state: ToastStates.SUCCESS);
          emit(RegisterSuccessState(shopLoginModel!));
    }).catchError((onError){
      print("Error: " + onError.toString());
      defaultToast(message: onError.toString(), state: ToastStates.ERROR);
      emit(RegisterErrorState());
    });
  }
}