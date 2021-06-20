import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class DetailContentView extends StatefulWidget {
  // 이전 페이지 데이터를 받을 수 있음 dynamic data , {this.data}
  dynamic data;
  DetailContentView({Key? key, this.data}) : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView> {
  Size? size;
  List<dynamic> imgList = [];
  int _current = 0;
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

  Widget _appBarWidget() {
    return AppBar(
      // 부모의 색 따라감 (요기에서는 투명처리)
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      actions: [
        IconButton(
            onPressed: () {}, icon: Icon(Icons.share, color: Colors.white)),
        IconButton(
            onPressed: () {}, icon: Icon(Icons.more_vert, color: Colors.white)),
      ],
    );
  }

  Widget _bodyWidget() {
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

  Widget _bottomBarWidget() {
    return Container(
      width: size!.width,
      height: 55,
      color: Colors.red,
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
