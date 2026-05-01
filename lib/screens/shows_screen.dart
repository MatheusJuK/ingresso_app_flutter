import 'package:flutter/material.dart';
import '../utils/constantes.dart';
import '../data/shows_data.dart';
import '../widgets/show_card.dart';

 
class ShowsScreen extends StatelessWidget {
  const ShowsScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildShowList(),
        ],
      ),
    );
  }
 
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 130,
      floating: false,
      pinned: true,
      backgroundColor: bgColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'INGRESSOS',
              style: TextStyle(
                color: accentColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
            Text(
              'Shows & Festivais',
              style: TextStyle(
                color: textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: textPrimary),
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
 
  SliverPadding _buildShowList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ShowCard(show: shows[index]),
          childCount: shows.length,
        ),
      ),
    );
  }
}
 