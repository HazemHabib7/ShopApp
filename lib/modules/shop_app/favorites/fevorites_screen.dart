import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/favorites_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.favoritesModel != null ? ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) => favoriteItem(cubit.favoritesDataModel!, index, context),
          separatorBuilder: (context, index) => buildDivider(),
          itemCount: cubit.favoritesDataModel!.data!.data!.length,
        ) : emptyScreen();
      });
  }

Widget favoriteItem(FavoritesModel model,int index,context){
  return Container(
    height: 120,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 3.0),
          child: Image(
            image: NetworkImage(
                '${model.data?.data?[index].product?.image}'),
            height: 120.0,
            width: 120.0,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.data?.data?[index].product?.name}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
              Row(
                children: [
                  Text(
                    '${model.data?.data?[index].product?.price?.round()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: defaultColor,
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  if (model.data?.data?[index].product?.discount != 0)
                    Text(
                      '${model.data?.data?[index].product?.oldPrice?.round()}',
                      style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: CircleAvatar(
                      child: IconButton(
                        icon: Icon(Icons.favorite_border_outlined),
                        color: Colors.white,
                        onPressed:(){
                          ShopCubit.get(context).changeFavorites(model.data!.data![index].product!.id!);
                        },
                      ),
                      backgroundColor: ShopCubit.get(context).favorites?[model.data?.data?[index].product?.id] ? Colors.pinkAccent :Colors.grey,
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),

      ],
    ),
  );
}
}
