import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String currentLocation = "ara"; // Drop Down 변수지정
  ContentsRepository contentsRepository = ContentsRepository();
  final Map<String, String> locationTypeToString = {
    // Map으로 오브젝트 생성
    "ara": "아라동", // "ara" 이면 "아라동"
    "ora": "오라동", // "ora" 이면 "오라동"
    "donam": "도남동", // "donam" 이면 "도남동"
  };

  @override
  void initState() {
    super.initState();
    currentLocation = "ara";
    // contentsRepository = ContentsRepository(); // 방법1 : 선언 1
  }

  // @override // 방법2 : 선언2
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   contentsRepository = ContentsRepository();
  // }

  final oCcy = new NumberFormat("#,###", "ko_KR");
  String calcStringToWon(String priceString) {
    oCcy.format(int.parse(priceString));
    return "${oCcy.format(int.parse(priceString))}원";
  }

  Widget _appBarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          print("Click");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 25),
          // offset : 좌표 Drop Down 나오는 위치를 설정 가능 (x , y)

          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          // 팝업 메뉴 버튼 (Drop Down)
          onSelected: (String where) {
            // onSelected : 클릭한 아이템 Text의 value 를 보여줌
            // onSelected : 인자값을 넣어 줘야댐
            setState(() {
              currentLocation = where;
              // where : value 값을 가져옴
            });
          },
          itemBuilder: (BuildContext context) {
            // 팝업 메뉴 아이템
            return [
              // 메뉴 아이템 리스트
              PopupMenuItem(value: "ara", child: Text("아라동")),
              PopupMenuItem(value: "ora", child: Text("오라동")),
              PopupMenuItem(value: "donam", child: Text("도남동")),
            ];
          },
          child: Row(
            children: [
              // Map
              Text('${locationTypeToString[currentLocation]}'),
              // locationTypeToString 에서 currentLocation 맞는것을 Text로 변환
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
      elevation: 1.0,
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: Icon(Icons.tune)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/bell.svg",
              width: 22,
            ))
      ],
    );
  }

  _loadContents() {
    contentsRepository.loadContentsFromLocation(currentLocation);
  }

  Widget _bodyWidget() {
    return FutureBuilder(
      future: _loadContents(),
      builder: (context, snapshot) {
        List<Map<String, String>> datas = snapshot.data;
        return Padding(
          // symmetric : vertical , horizontal 패딩을 줄 수 있음
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView.separated(
              // 아이템
              itemBuilder: (BuildContext _context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                      child: Row(
                    children: [
                      ClipRRect(
                        // ClipRRect : 감싸서 borderRadius 사용 가능
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.asset(
                          datas[index]["images"].toString(),
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        // ClipRRect가 사용하는것 외 모든사이즈를 가짐
                        child: Container(
                          padding: const EdgeInsets.only(left: 20),
                          height: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                datas[index]["title"].toString(),
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                // overflow: TextOverflow.ellipsis
                                // 텍스트가 overflow 됐을 때 ...으로 나오게 됨
                              ),
                              SizedBox(height: 5),
                              Text(
                                datas[index]["location"].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                calcStringToWon(
                                    datas[index]["price"].toString()),
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Expanded(
                                /*Expanded : 부모의 사이즈 영향 받음 
                              Container의 height가 100이면 Text 3개를 제외한 모든 사이즈는
                              Expanded의 감싸져 있는 Widget이 가지게 됨*/
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/heart_off.svg',
                                      width: 13,
                                      height: 13,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(datas[index]["likes"].toString()),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
                );
              },
              // 밑줄
              separatorBuilder: (BuildContext _context, int index) {
                return Container(
                  height: 1,
                  color: Colors.black.withOpacity(0.5),
                );
              },
              // 아이템의 갯수
              itemCount: datas.length),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), child: _appBarWidget()),
      body: _bodyWidget(),
    );
  }
}
