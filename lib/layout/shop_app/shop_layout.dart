import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../modules/shop_app/search/search_screen.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/colors.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
    listener: (context, state) {},
    builder: (context, state) {
      ShopCubit cubit = ShopCubit.get(context);
    return Scaffold(
      appBar: AppBar(
    title: Text('Salla',style: TextStyle(color: defaultColor),),
    actions: [
      IconButton(onPressed: (){
        navigateTo(context, ShopSearchScreen());
      }, icon: Icon(Icons.search)),
    ],
      ),
      body: cubit.items[cubit.currentIndex],
      bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.apps),
        label: 'Categories',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ],
    onTap: (index){
      cubit.changeBottomNav(index);
    },
    currentIndex: cubit.currentIndex,
      ),
    );
    }
    );

  }
}
