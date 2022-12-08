import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../models/categories_model.dart';
import '../../../models/home_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if(state.model.status!)
          defaultToast(message:ShopCubit.get(context).favoritesModel!.message!, state: ToastStates.SUCCESS);
         else
          defaultToast(message:ShopCubit.get(context).favoritesModel!.message!, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return Conditional.single(
          conditionBuilder: (context) =>
              cubit.homeModel != null && cubit.categoriesModel != null,
          widgetBuilder: (context) =>
              builderWidget(cubit.homeModel!, cubit.categoriesModel!,context),
          fallbackBuilder: (context) =>
              Center(child: CircularProgressIndicator()),
          context: context,
        );
      },
    );
  }

  Widget builderWidget(HomeModel model, CategoriesModel categoriesModel,context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: model.data?.banners
                .map(
                  (e) => Image(
                    image: NetworkImage('${e.image}'),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
                .toList(),
            options: CarouselOptions(
              height: 250.0,
              autoPlay: true,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlayAnimationDuration: Duration(seconds: 3),
              autoPlayInterval: Duration(seconds: 3),
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              scrollDirection: Axis.horizontal,
              viewportFraction: 1.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 100.0,
            child: ListView.separated(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    categoriesItem(categoriesModel, index),
                separatorBuilder: (context, index) => SizedBox(width: 10.0),
                itemCount: categoriesModel.data!.data.length),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'New Products',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio: 1 / 1.5,
              children: List.generate(
                model.data!.products.length, (index) {
                  return Stack(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Image(
                              image: NetworkImage(
                                  '${model.data!.products[index].image}'),
                              height: 200.0,
                            ),
                          ),
                          Container(
                              height: 30.0,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  '${model.data!.products[index].name}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: Text(
                                    '${model.data!.products[index].price.round()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: defaultColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                if (model.data?.products[index].discount != 0)
                                  Text(
                                    '${model.data!.products[index].oldPrice.round()}',
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
                                          ShopCubit.get(context).changeFavorites(model.data!.products[index].id!);
                                        },
                                      ),
                                    backgroundColor: ShopCubit.get(context).favorites![model.data!.products[index].id] ? Colors.pinkAccent :Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (model.data!.products[index].discount != 0)
                      Container(
                          width: 60.0,
                          height: 20,
                          color: Colors.red,
                          child: Text(
                            'Discount',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          )),
                  ],
                );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoriesItem(CategoriesModel categoriesModel, index) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(
          image: NetworkImage('${categoriesModel.data?.data[index].image}'),
          fit: BoxFit.cover,
          height: 100.0,
          width: 100.0,
        ),
        Container(
          width: 100.0,
          height: 20.0,
          color: Colors.black.withOpacity(.55),
          child: Text(
            '${categoriesModel.data?.data[index].name}',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
