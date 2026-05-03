import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../router/app_router.dart';

/// Search page with a prominent search field and results grid.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final isDesktop = context.screenWidth >= AppConstants.desktopBreakpoint;

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: Text('Search', style: textStyles.pageTitle),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.go(AppRoutes.settings),
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline),
                  onPressed: () => context.push(AppRoutes.profile),
                ),
                const SizedBox(width: 8),
              ],
            ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          if (isDesktop)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 32, top: 32, bottom: 16),
                child: Text('Search', style: textStyles.pageTitle),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: textStyles.body,
                decoration: InputDecoration(
                  hintText: 'Artists, songs, or albums',
                  hintStyle: textStyles.caption,
                  prefixIcon: Icon(Icons.search, color: colors.onSurfaceVariant),
                  filled: true,
                  fillColor: colors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onSubmitted: (query) {
                  // TODO: Trigger search usecase
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 24, bottom: 16),
              child: Text('Browse Categories', style: textStyles.sectionHeader),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isDesktop ? 4 : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: _mockCategories.length,
              itemBuilder: (context, index) {
                final cat = _mockCategories[index];
                return _CategoryCard(
                  title: cat['title']!,
                  colors: colors,
                  textStyles: textStyles,
                );
              },
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final AppColors colors;
  final AppTextStyles textStyles;

  const _CategoryCard({
    required this.title,
    required this.colors,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primary.withValues(alpha: 0.7),
              colors.primaryVariant.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: textStyles.cardTitle.copyWith(color: colors.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}

final _mockCategories = [
  {'title': 'Pop'},
  {'title': 'Rock'},
  {'title': 'Hip-Hop'},
  {'title': 'Electronic'},
  {'title': 'R&B'},
  {'title': 'Jazz'},
  {'title': 'Classical'},
  {'title': 'K-Pop'},
];
