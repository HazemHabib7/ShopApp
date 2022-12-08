import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../shared/components/components.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/colors.dart';
import '../login/shop_login_screen.dart';

class OnBoardingItems {
  final String image;
  final String title;
  final String body;
  OnBoardingItems(
      {
        required this.image,
        required this.title,
        required this.body
      });
}

List<OnBoardingItems> items =[
  OnBoardingItems(
    image: 'assets/images/on_boarding1.jpg',
    title: 'Screen Title 1',
    body: 'Screen Body 1',
  ),
  OnBoardingItems(
    image: 'assets/images/on_boarding1.jpg',
    title: 'Screen Title 2',
    body: 'Screen Body 2',
  ),
  OnBoardingItems(
    image: 'assets/images/on_boarding1.jpg',
    title: 'Screen Title 3',
    body: 'Screen Body 3',
  ),
];
PageController boardingController = PageController();
bool isLast = false;

void submit(context){
  CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
    if(value==true){
      return navigateAndFinish(context,ShopLoginScreen());
    }
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          defaultTextButton(
              function: (){
            submit(context);
          }, text: 'SKIP',
          color: defaultColor),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardingController,
                itemBuilder: (context, index) => obBoardingItem(items[index]),
                itemCount: items.length,
                onPageChanged: (index){
                  if(index==2){
                    setState(() {
                      isLast = true;
                    });
                  }
                  else{
                    setState(() {
                      isLast = false;
                    });
                  }
                },
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: defaultColor,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      expansionFactor: 4.0,
                      spacing: 5.0,
                    ),
                    controller: boardingController,
                    count: items.length
                ),
                Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if(isLast){
                      submit(context);
                    }
                    else{
                      boardingController.nextPage(
                          duration: Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios),
                )
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget obBoardingItem(OnBoardingItems model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(image: AssetImage('${model.image}')),
        SizedBox(
          height: 40.0,
        ),
        Text('${model.title}',
            style:
                TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 20.0,
        ),
        Text(
          '${model.body}',
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
