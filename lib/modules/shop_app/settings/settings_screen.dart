import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/colors.dart';

class SettingsScreen extends StatelessWidget {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        var model = cubit.userDataModel;
        nameController.text = model!.data!.name!;
        emailController.text = model.data!.email!;
        phoneController.text = model.data!.phone!;
          return cubit.userDataModel != null ? Column(
          children: [
            if(state is ShopLoadingUpdateState)
            LinearProgressIndicator(),
            SizedBox(height: 15.0,),
            defaultTextFormField(
                validateText: 'Name must not be empty',
                controller: nameController,
                keyboardType: TextInputType.text,
                label: 'Name',
                prefixIcon: Icon(Icons.person)),
            SizedBox(height: 20.0,),
            defaultTextFormField(
                validateText: 'Email must not be empty',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                prefixIcon: Icon(Icons.email)),
            SizedBox(height: 20.0,),
            defaultTextFormField(
                validateText: 'phone must not be empty',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                label: 'Phone',
                prefixIcon: Icon(Icons.phone)),
            SizedBox(height: 20.0,),
            Container(
                width: 360,
                decoration: BoxDecoration(
                  color: defaultColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: defaultTextButton(function: (){
                  cubit.putUserData(
                      nameController.text,
                      emailController.text,
                      phoneController.text,
                  );
                },
                    text: 'update',color: Colors.white)),
            SizedBox(height: 20.0,),
            Container(
              width: 360,
              decoration: BoxDecoration(
                color: defaultColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
                child: defaultTextButton(function: (){
                  signOut(context);
                }, text: 'logout',color: Colors.white)),
          ],
        ) : Center(child: CircularProgressIndicator());
      },
    );
  }
}
