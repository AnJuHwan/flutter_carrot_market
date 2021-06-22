import 'package:carousel_slider/carousel_slider.dart';
import 'package:carrot_market_sample/components/manor_temperature_widget.dart';
import 'package:carrot_market_sample/repository/contents_repository.dart';
import 'package:carrot_market_sample/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailContentView extends StatefulWidget {
  // 이전 페이지 데이터를 받을 수 있음 dynamic data , {this.data}
  dynamic data;
  DetailContentView({Key? key, this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  Size? size;
  List<dynamic> imgList = [];
  int _current = 0;
  double scrollpositionToAplpha = 0;
  ScrollController _controller = ScrollController();
  AnimationController? _animationController;
  Animation? _colorTween;
  bool isMyFavoriteContent = false;
  ContentsRepository? contentsRepository;

  // ScrollController 스크롤 이벤트
  // _animationController = AnimationController(vsync: this);
  // '지금 있는 클래스에 애니메이션을 적용 하겠다' 라는 의미
  @override
  void initState() {
    super.initState();
    contentsRepository = ContentsRepository();
    _animationController = AnimationController(vsync: this);
    // begin : 시작 Color , end : 끝 Color , .animate() 을 추가 해주면 됨
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController!);
    // _controller.offset : 스크롤 할 때 마다 좌표
    _controller.addListener(() {
      // 스크롤 할 때 마다 이벤트 발생
      setState(() {
        if (_controller.offset > 255) {
          scrollpositionToAplpha = 255;
        } else {
          scrollpositionToAplpha = _controller.offset;
        }
        // scrollpositionToAplpha = _controller.offset
        // 스크롤 offset : y좌표
        // 0~1 까지의 사이를 표현 : 0 : white , 1 : black
        _animationController!.value = scrollpositionToAplpha / 255;
      });
    });
    _loadMyFavoriteContentState();
  }

  _loadMyFavoriteContentState() async {
    bool ck =
        await contentsRepository!.isMyFavoritecontents(widget.data['cid']);
    print(ck);
    setState(() {
      isMyFavoriteContent = ck;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    _current = 0;
    imgList = [
      {"id": "0", "url": widget.data["image"]},
      {"id": "1", "url": widget.data["image"]},
      {"id": "2", "url": widget.data["image"]},
      {"id": "3", "url": widget.data["image"]},
      {"id": "4", "url": widget.data["image"]},
    ];
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
        animation: ColorTween(begin: Colors.white, end: Colors.black)
            .animate(_animationController!),
        builder: (context, child) => Icon(
              icon,
              color: _colorTween!.value,
            ));
  }

  Widget _appBarWidget() {
    return AppBar(
      // 지정한 색의 범위 0~255  --> 투명도
      backgroundColor: Colors.white.withAlpha(scrollpositionToAplpha.toInt()),
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.share)),
        IconButton(onPressed: () {}, icon: _makeIcon(Icons.more_vert)),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Stack(
      children: [
        Hero(
          tag: widget.data["cid"],
          child: Container(
              // CarrouselSlider 캐러셀 슬라이더
              child: CarouselSlider(
            options: CarouselOptions(
                height: size!.width,
                initialPage: 0,
                // initialPage : 처음 페이지
                enableInfiniteScroll: false,
                // enableInfiniteScroll : 무한 스크롤
                viewportFraction: 1,
                // viewportFraction : 페이지 사용 범위 1: 전체
                onPageChanged: (index, reason) {
                  print(index);
                  setState(() {
                    _current = index;
                  });
                }),
            items: imgList.map((map) {
              return Image.asset(
                map["url"],
                width: size!.width,
                fit: BoxFit.fill,
              );
            }).toList(),
          )),
        ),
        Positioned(
          bottom: 0,
          // left right : 0 을 사용하면 가운대로 가능
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.map((map) {
              return GestureDetector(
                child: Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == int.parse(map["id"])
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(50),
          //   child: Container(
          //     width: 50,
          //     height: 50,
          //     child: Image.asset('assets/images/user.png'),
          //   ),
          // )
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset('assets/images/user.png').image,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '개발하는남자',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '제주시 도담동',
              )
            ],
          ),
          Expanded(
            child: ManorTemperature(manorTemp: 37.5),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // stretch : Column 가로로 꽉차게 하기
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.data['title'],
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            "디지털/가전 · 22시간 전", //데이터가 없어 임의로 하는 것
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다 \n거래는 직거래만 합니다.",
            style: TextStyle(fontSize: 15, height: 1.5),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "채팅 3 · 관심 17 · 조회 295",
            style: TextStyle(fontSize: 12, height: 1.5, color: Colors.grey),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '판매자님의 판매 상품',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            '모두 보기',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      // CustomScrollView 아이템들 사용 방법
      // Grid ScrollView 등 할 때 사용함
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            _line(),
            _contentDetail(),
            _line(),
            _otherCellContents(),
          ]),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                // crossAxisCount : 한 Row 에 배치될 아이템 갯수
                // mainAxisSpacing : width의 간격
                // crossAxisSpacing : height의 간격
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10),
            delegate: SliverChildListDelegate(List.generate(8, (index) {
              // List.generate(아이템 갯수 , index)
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        color: Colors.grey,
                        height: 120,
                      ),
                    ),
                    Text('상품 제목',
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    Text('금액',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))
                  ],
                ),
              );
            }).toList()),
          ),
        )
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size!.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (isMyFavoriteContent) {
                // isMyFavoriteContent : true 이면 :
                // 좋아요가 눌러져있으면 한번더 누르면 삭제
                await contentsRepository!
                    .deleteMyFavoriteContnt(widget.data['cid']);
              } else {
                await contentsRepository!.addMyFavoriteContent(widget.data);
              }
              // addMyFavoriteContent 데이터 저장

              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(milliseconds: 1000),
                  content: Text(
                    isMyFavoriteContent ? '관심목록에 추가 되었습니다' : '관심목록에 삭제 되었습니다.',
                  )));
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
                  ? 'assets/svg/heart_on.svg'
                  : 'assets/svg/heart_off.svg',
              width: 25,
              height: 25,
              color: Color(0xfff00f4f),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1,
            height: 40,
            color: Colors.grey.withOpacity(0.3),
          ),
          Column(
            children: [
              Text(
                DataUtils.calcStringToWon(widget.data["price"].toString()),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            ],
          ),
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xfff08f4f),
                ),
                child: Text(
                  "채팅으로 거래하기",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar:true -> AppBar 위에까지 침범가능
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), child: _appBarWidget()),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
