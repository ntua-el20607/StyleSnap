import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 430,
      height: 932,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Positioned(
            left: 3,
            top: 58,
            child: Container(
              width: 424,
              height: 91,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 366,
                    height: 89,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("assets/images/profile_pic.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 35,
            top: 474,
            child: Container(
              width: 360,
              height: 2,
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
            ),
          ),
          Positioned(
            left: 35,
            top: 673,
            child: Container(
              width: 360,
              height: 2,
              decoration: const BoxDecoration(color: Color(0xFFD9D9D9)),
            ),
          ),
          Positioned(
            left: 103,
            top: 542,
            child: Container(
              width: 222,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5099999904632568),
              ),
            ),
          ),
          const Positioned(
            left: 130,
            top: 508,
            child: Text(
              'Total Outfits',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontFamily: 'Ribeye Marrow',
                fontWeight: FontWeight.w400,
                height: 0.04,
              ),
            ),
          ),
          Positioned(
            left: 69,
            top: 401,
            child: Container(
              width: 292,
              height: 53,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF9747FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                      height: 0.06,
                      letterSpacing: 0.10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 184,
            top: 729,
            child: Container(
              width: 62,
              height: 62,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://via.placeholder.com/62x62"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Positioned(
            left: 144,
            top: 179,
            child: Container(
              width: 142,
              height: 192,
              padding: const EdgeInsets.only(bottom: 11.71),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 142,
                    height: 142.29,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 142,
                          height: 142.29,
                          decoration: const ShapeDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://via.placeholder.com/142x142"),
                              fit: BoxFit.fill,
                            ),
                            shape: OvalBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'John Wick',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            height: 0.06,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            top: 842,
            child: SizedBox(
              width: 400,
              height: 90,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: Container(
                      width: 400,
                      height: 90,
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  const Positioned(
                    left: 333,
                    top: 22,
                    child: SizedBox(
                      width: 43.85,
                      height: 46.22,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 28.44,
                            child: SizedBox(
                              width: 43.85,
                              height: 17.78,
                              child: Text(
                                'Profile',
                                style: TextStyle(
                                  color: Color(0xFF9747FF),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 257,
                    top: 22,
                    child: SizedBox(
                      width: 48,
                      height: 46.20,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 28.20,
                            child: SizedBox(
                              width: 48,
                              height: 18,
                              child: Text(
                                'Search',
                                style: TextStyle(
                                  color: Color(0xFF9747FF),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 168,
                    top: 13,
                    child: SizedBox(
                      width: 64,
                      height: 64,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const ShapeDecoration(
                                color: Color(0xFF9747FF),
                                shape: OvalBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 96,
                    top: 20,
                    child: SizedBox(
                      height: 47.78,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 30,
                            child: SizedBox(
                              width: 43.85,
                              height: 17.78,
                              child: Text(
                                'Friends',
                                style: TextStyle(
                                  color: Color(0xFF9747FF),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 7,
                            top: 0,
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: 2.50,
                                          top: 6.23,
                                          child: SizedBox(
                                            width: 25,
                                            height: 17.52,
                                            // Your Friends icon or content here
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 31,
                    top: 22,
                    child: SizedBox(
                      width: 40.30,
                      height: 46,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 28.23,
                            child: SizedBox(
                              width: 40.30,
                              height: 17.78,
                              child: Text(
                                'Home',
                                style: TextStyle(
                                  color: Color(0xFF9747FF),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
