import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lojservers/screens/tab/taking_orders_screen.dart';
import 'package:lojservers/screens/tab/list_of_orders_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  BannerAd? _bannerAd;

  final List<Widget> _pages = [
    const TakingOrdersScreen(),
    const ListOfOrdersScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkForUpdate();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-8397585981018540/8328164422', // Replace with your ad unit ID
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(),
    )..load();
  }

  Future<void> _checkForUpdate() async {
    AppUpdateInfo updateInfo;
    try {
      updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          print(e);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Taking Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List Of Orders',
          ),
        ],
      ),
      bottomSheet: _bannerAd == null
          ? null
          : Container(
              alignment: Alignment.bottomCenter,
              width: _bannerAd?.size.width.toDouble(),
              height: _bannerAd?.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
