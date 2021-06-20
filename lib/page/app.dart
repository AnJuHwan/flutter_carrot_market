import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
    // 위에 index 초기화 안해줬으니 initState에서 0으로 초기화 (기본페이지)
  }

  // intl 라이브러리를 사용해서 price : 80000 -> 80,000원 전환
  // https://pub.dev/packages/intl

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return Home();
      case 1:
        return Container();

      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
    return Container();
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22),
        ),
        // activeIcon : 선택이 되었을 때 바뀌는 ui모습
        // off.svg  --> on.svg
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22),
        ),
        label: label);
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
        // type : BottomNavigationBarType
        // 이용하여 선택되었을 때 애니메이션 , 효과를 줄 수 있음
        type: BottomNavigationBarType.fixed,
        // int index : 아이템의 인덱스값을 찍어줌
        onTap: (int index) {
          print(index);
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        // selectedItemColor : bottomBar 아이템의 색을 지정해 줄 수 있음
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        items: [
          _bottomNavigationBarItem("home", "홈"),
          _bottomNavigationBarItem("notes", "동네생활"),
          _bottomNavigationBarItem("location", "내 근처"),
          _bottomNavigationBarItem("chat", "채팅"),
          _bottomNavigationBarItem("user", "나의 당근"),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(50.0), child: _appBarWidget()),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarWidget(),
    );
  }
}
