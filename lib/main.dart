import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🎨 Theme
import 'theme/app_theme.dart';

// 🧠 BLoC
import 'bloc/auth_bloc.dart';
import 'bloc/loan_bloc.dart';

// 📱 Screens
import 'screens/splash/splash_screen.dart';
import 'screens/luxury_login_screen.dart';
import 'screens/luxury_dashboard_screen.dart';

/// 🏦 CMO Loan App - Premium Mobile Banking Experience
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const CMOLoanApp());
}

class CMOLoanApp extends StatelessWidget {
  const CMOLoanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔐 Auth BLoC - จัดการ Login/Logout ทั้งแอป
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        // 📊 Loan BLoC - จัดการข้อมูลสินเชื่อ
        BlocProvider<LoanBloc>(
          create: (context) => LoanBloc(),
        ),
      ],
      child: ScreenUtilInit(
        // 📐 Design size จากต้นฉบับ
        designSize: const Size(420, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            // 🎨 Theme Configuration
            theme: AppTheme.lightTheme,
            
            // ️ App Configuration
            title: 'CMO Loan App - Premium',
            debugShowCheckedModeBanner: false,
            
            // 🌐 Localization - รองรับภาษาไทย
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('th', 'TH'),
              Locale('en', 'US'),
            ],
            locale: const Locale('th', 'TH'),
            
            // 🌟 เริ่มจาก Splash Screen
            home: const SplashScreen(),
            
            // 🗺️ Routes
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LuxuryLoginScreen(),
              '/dashboard': (context) => const LuxuryDashboardScreen(),
            },
            
            // 📱 Builder สำหรับ Responsive
            builder: (context, child) {
              return MediaQuery(
                // 📏 ป้องกัน text scaling ผิดปกติ
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0,
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
