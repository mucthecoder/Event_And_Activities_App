import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.onTap, required this.pageIndex});
  final int pageIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        color: const Color(0xfefefeff),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home, pageIndex == 0, onTap: () => onTap(0)),
            navItem(Icons.search, pageIndex == 1, onTap: () => onTap(1)),
            navItem(Icons.person, pageIndex == 2, onTap: () => onTap(2)),
          ],
        ),
      ),
    );
  }

  Widget navItem(IconData icon, bool selected, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SvgPicture.asset(
          'assets/$icon.svg',
          color: selected ? Colors.blue : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }
}
