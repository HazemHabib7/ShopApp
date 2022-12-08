import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/search_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/colors.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ShopSearchScreen extends StatelessWidget {

  TextEditingController searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20.0,),
                    defaultTextFormField(
                        onSubmit: (value){
                          if(formKey.currentState!.validate()){
                            SearchCubit.get(context).search(text: value);
                          }
                        },
                        validateText: 'Type anything to search',
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        label: 'Search',
                        prefixIcon: Icon(Icons.search)),
                    SizedBox(height: 10.0,),
                    if(state is SearchLoadingState)
                      LinearProgressIndicator(),
                    if(state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => searchItem(SearchCubit.get(context).searchModel!,index,context,searchController.text),
                          separatorBuilder: (context, index) => buildDivider(),
                          itemCount: SearchCubit.get(context).searchModel!.data!.data!.length),
                    )
                  ],
                ),
              ));
        },
      )
    );
  }

  Widget searchItem(SearchModel model,int index,context,text){
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
                  '${model.data!.data![index].image}'),
              height: 120.0,
              width: 120.0,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.data!.data![index].name}',
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
                      '${model.data!.data![index].price!.round()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: defaultColor,
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        child: IconButton(
                          icon: Icon(Icons.favorite_border_outlined),
                          color: Colors.white,
                          onPressed:(){
                            SearchCubit.get(context).search(text: text);
                          },
                        ),
                        backgroundColor: SearchCubit.get(context).searchModel!.data!.data![index].inFavorites == true ? Colors.pinkAccent :Colors.grey,
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
