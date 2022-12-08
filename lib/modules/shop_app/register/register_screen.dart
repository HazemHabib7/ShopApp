import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/shop_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopRegisterScreen extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit,RegisterStates>(
      listener: (context, state) {
        if(state is RegisterSuccessState){
          if(state.loginModel.status==true){
            // print('message: ${state.loginModel.message}');
            // print('token: ${state.loginModel.data?.token}');
            CacheHelper.saveData(key: 'token', value: '${state.loginModel.data?.token}').then((value) {
              token = state.loginModel.data?.token;
              navigateAndFinish(context, ShopLayout());
            });
          }
          else {
            print('message: ${state.loginModel.message}');
            defaultToast(
                message: '${state.loginModel.message}',
                state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        RegisterCubit cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('REGISTER',style: TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Register now to browse our hot offers',style: TextStyle(color: Colors.grey,fontSize: 20.0)),
                    ),
                    SizedBox(height: 35.0),
                    defaultTextFormField(
                        onTap: (){},
                        validateText: 'User name must not be empty',
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        label: 'User Name',
                        prefixIcon: Icon(Icons.person)),
                    SizedBox(height: 20.0),
                    defaultTextFormField(
                        onTap: (){},
                        validateText: 'User name must not be empty',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined)),
                    SizedBox(height: 20.0),
                    defaultTextFormField(
                        onTap: (){},
                        validateText: 'Password must not be empty',
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: 'Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                        isPassword: cubit.isPassword,
                        suffixIcon: IconButton(
                          onPressed: (){
                            cubit.is1password();
                          },
                          icon:cubit.isPassword? Icon(Icons.visibility_outlined):Icon(Icons.visibility_off_outlined),
                        )
                    ),
                    SizedBox(height: 20.0),
                    defaultTextFormField(
                      onTap: (){},
                      validateText: 'Phone number must not be empty',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      label: 'Phone number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    SizedBox(height: 35.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: state is RegisterLoadingState ? Center(child: CircularProgressIndicator()) :defaultButton(
                        radius: 25.0,
                        function: (){
                          if(formKey.currentState!.validate()){
                            cubit.register(
                              name: nameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        text: 'register',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
