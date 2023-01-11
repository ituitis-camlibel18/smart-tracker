import 'package:flutter/material.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:sample_app/Pages/LandingPage.dart';

import '../Pages/AdminPage.dart';
import '../introduction_pages/introduction_pages.dart';


  class AnimatedIntroductionSlider extends StatelessWidget {
  const AnimatedIntroductionSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return  IntroViewsFlutter(
  pages,
  onTapDoneButton: () {
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => LandingPage()), (route) => false);
  },
  pageButtonTextStyles: const TextStyle(
  color: Colors.white,
  fontSize: 18.0,
  ),
  );
  }
  }

 // @override
 // Widget build(BuildContext context) {
 //  return MaterialApp(
 //  debugShowCheckedModeBanner: false,
 //  title: 'introduction Slider',
 //   theme: ThemeData(
 //      primarySwatch: Colors.blue,
 //    ),
 //     home: Builder(
 //      builder: (context) => IntroViewsFlutter(
 //         pages,
 //         onTapDoneButton: () {
//           Navigator.of(context).pushReplacementNamed('/homepage');
//        },
//         pageButtonTextStyles: const TextStyle(
//            color: Colors.white,
//            fontSize: 18.0,
//          ),
//       ),
//     ),
//   );
// }
//}
