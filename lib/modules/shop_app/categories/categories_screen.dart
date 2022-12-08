import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../shared/components/components.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.categoriesModel ==null ? Center(child: CircularProgressIndicator()) : ListView.separated(
            itemBuilder: (context, index) => categoriesItem(cubit.categoriesModel!, index),
            separatorBuilder: (context, index) => buildDivider(),
            itemCount: cubit.categoriesModel!.data!.data.length);
      },
    );
  }
  Widget categoriesItem(CategoriesModel categoriesModel,int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
         Image(image: NetworkImage('${categoriesModel.data!.data[index].image}'),width: 100.0,height: 100.0,),
          SizedBox(width: 20.0,),
          Text('${categoriesModel.data!.data[index].name}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
        ],
      ),
    );
  }

}
