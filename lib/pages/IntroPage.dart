import 'package:flutter/material.dart';
import 'package:weather_app/pages/HomePage.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // anh nen phia sau
            Positioned.fill(
              child: Image.asset(
                'assets/images/bg_intro.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // lop phu lam mo nhe
            Container(color: Colors.black.withValues(alpha: 0.3)),

            // noi dung chinh
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Đề tài: Ứng dụng thời tiết \n Nhóm 8',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Thành viên:\n Phạm Gia Huy: 22010043 \n Đỗ Huy Dương: 22010179',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // nut chuyen sang HomePage
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5896FD).withValues(
                          alpha: 0.65,
                        ), // màu xanh lam với opacity 75%
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(
                        Icons.cloud_outlined,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Bắt đầu xem thời tiết',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomePage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
