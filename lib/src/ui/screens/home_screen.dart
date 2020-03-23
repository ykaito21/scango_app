import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/store_model.dart';
import '../../core/providers/store_provider.dart';
import '../../core/providers/home_screen_provider.dart';
import '../global/routes/route_generator.dart';
import '../global/extensions.dart';
import '../global/style_list.dart';
import '../shared/widgets/stream_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamWrapper<List<StoreModel>>(
      stream: context.provider<StoreProvider>().streamStores,
      onError: (context, _) => errorInitialStore(context),
      onWaitting: (context) => waittingInitialStore(),
      onSuccess: (context, stores) {
        if (stores.isEmpty) return waittingInitialStore();
        final store = stores.first;
        return Provider<HomeScreenProvider>(
          create: (context) => HomeScreenProvider(),
          dispose: (context, homeScreenProvider) =>
              homeScreenProvider.dispose(),
          child: Consumer<HomeScreenProvider>(
            builder: (context, homeScreenProvider, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    store.name,
                    style: StyleList.smallBoldTextStyle,
                  ),
                  centerTitle: true,
                  actions: <Widget>[
                    IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                      },
                      icon: Icon(Icons.search),
                    ),
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      DrawerHeader(
                        child: Text('Drawer Header'),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                      ),
                      ListTile(
                        title: Text('Item 1'),
                        onTap: () {
                          // context.provider<StoreProvider>().setLocation();
                        },
                      ),
                      ListTile(
                        title: Text('Item 2'),
                        onTap: () {
                          // context.provider<StoreProvider>().getStore();
                        },
                      ),
                    ],
                  ),
                ),
                body: WillPopScope(
                  onWillPop: () async => !await homeScreenProvider
                      .navigators[homeScreenProvider.currentIndex].currentState
                      .maybePop(),
                  child: CupertinoTabScaffold(
                    resizeToAvoidBottomInset: false,
                    tabBuilder: (context, index) {
                      return CupertinoTabView(
                        navigatorKey: homeScreenProvider.navigators[index],
                        onGenerateRoute: RouteGenerator.generateRoute,
                        builder: (context) {
                          switch (index) {
                            case 0:
                              return Container();
                            case 1:
                              return Container();
                            default:
                              return Container();
                          }
                        },
                      );
                    },
                    tabBar: CupertinoTabBar(
                      border: Border(
                        top: BorderSide(
                          color: context.scaffoldBackgroundColor,
                          width: 0.0, // One physical pixel.
                          style: BorderStyle.solid,
                        ),
                      ),
                      backgroundColor: context.scaffoldBackgroundColor,
                      activeColor: context.accentColor,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          // title: Text('Home'),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.shopping_cart),
                        ),
                      ],
                      onTap: (index) {
                        if (homeScreenProvider.currentIndex == index) {
                          homeScreenProvider.navigators[index].currentState
                              .popUntil((route) => route.isFirst);
                        }
                        homeScreenProvider.currentIndex = index;
                      },
                    ),
                  ),
                ),
                floatingActionButton: Padding(
                  padding: (Platform.isIOS)
                      ? const EdgeInsets.only(bottom: 30.0)
                      : const EdgeInsets.only(bottom: 0.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.crop_free),
                    onPressed: () => null,
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            },
          ),
        );
      },
    );
  }

  Widget errorInitialStore(BuildContext context) => Scaffold(
      body:
          Center(child: StyleList.errorViewState(context.translate('error'))));

  Widget waittingInitialStore() =>
      Scaffold(body: Center(child: StyleList.loadingViewState()));
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return Text('search');
  }
}
