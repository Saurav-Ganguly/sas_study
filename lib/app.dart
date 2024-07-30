import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sas_study_v2/screens/home_screen.dart';
import 'package:sas_study_v2/screens/practice_screen.dart';
import 'package:sas_study_v2/services/navigation_service.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavigationService(initialScreen: const HomeScreen()),
      child: MaterialApp(
        title: 'SAS Study App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<NavigationService>(
          builder: (context, navigationService, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('SAS Study'),
              ),
              body: navigationService.currentScreen,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: navigationService.currentIndex,
                onTap: (index) {
                  navigationService.setIndex(index);
                  if (index == 0) {
                    navigationService.navigateTo(const HomeScreen());
                  } else {
                    navigationService.navigateTo(const PracticeScreen());
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Study',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.run_circle),
                    label: 'Practice',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
