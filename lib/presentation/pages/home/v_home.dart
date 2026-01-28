import 'package:bpstate/bpstate.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';
import 'package:prueba_rick/presentation/pages/home/widget/character_detail.dart';
import 'package:prueba_rick/presentation/pages/home/widget/filters_section.dart';
import 'package:prueba_rick/presentation/utils/extension/extension_build_context.dart';

class VHome extends StatefulWidget {
  const VHome({super.key});

  @override
  State<VHome> createState() => _VHomeState();
}

class _VHomeState extends State<VHome> {
  late BHome bloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<BHome>(context);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      bloc.loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.neutral1,
      appBar: AppBar(
        title: Text(
          'Rick & Morty Characters',
          style: context.subtitle1.copyWith(color: context.colors.primary),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: context.colors.neutral,
        foregroundColor: context.colors.primary,
      ),
      body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),        
        child: Column(
          children: [
            const FiltersSection(),
            Expanded(
              child: StreamBuilder<EPage<ECharacter>?>(
                stream: bloc.outPage,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Oops! Something went wrong',
                              style: context.body1.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: context.colors.neutral5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              asyncSnapshot.error.toString(),
                              style: context.body1.copyWith(
                                color: context.colors.neutral3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => bloc.getCharacters(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Try Again'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                      asyncSnapshot.data == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: context.colors.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Loading characters...',
                            style: context.body1.copyWith(
                              color: context.colors.neutral4,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  final List<ECharacter>? results = asyncSnapshot.data!.results;
                  if (results == null || results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: context.colors.neutral3,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No characters found',
                            style: context.body1.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: context.colors.neutral4,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filters',
                            style: context.body1.copyWith(
                              color: context.colors.neutral3,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await bloc.getCharacters();
                    },
                    color: context.colors.primary,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final character = results[index];
                        return _buildCharacterCard(context, character);
                      },
                    ),
                  );
                },
              ),
            ),
        
            itemLoadingMoresCharacter(),
          ],
        ),
      ),
    );
  }

  StreamBuilder<bool> itemLoadingMoresCharacter() {
    return StreamBuilder<bool>(
            stream: bloc.outLoading,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData && asyncSnapshot.data == true) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.colors.neutral,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.neutral8.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Loading more characters...',
                        style: context.body1.copyWith(
                          color: context.colors.neutral5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          );
  }

  Widget _buildCharacterCard(BuildContext context, ECharacter character) {
    final statusColor = _getStatusColor(character.status);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shadowColor: context.colors.primary.withAlpha(100),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.colors.primary.withAlpha(50),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showCharacterDetail(context, character),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  character.image != null
                      ? Image.network(
                          character.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: context.colors.neutral2,
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: context.colors.neutral3,
                                ),
                              ),
                        )
                      : Container(
                          color: context.colors.neutral2,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: context.colors.neutral3,
                          ),
                        ),
                  if (character.status != null)
                    itemStatus(statusColor, character),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        character.name ?? 'Unknown',
                        style: context.body1.copyWith(
                          fontWeight: FontWeight.w700, 
                          color: context.colors.primary                       
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      character.gender != null ? Row(
                        children: [
                           Icon(
                              Icons.people,
                              size: 14,
                              color: context.colors.primary,
                            ),
                            const SizedBox(width: 4),                        
                          Text(
                            character.gender ?? 'Unknown',
                            style: context.body2.copyWith(
                              color: context.colors.neutral4,                       
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ) : const SizedBox(),
                      if (character.species != null) ...[                      
                        Row(
                          children: [
                            Icon(
                              Icons.science_outlined,
                              size: 14,
                              color: context.colors.primary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                character.species!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.colors.neutral4,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned itemStatus(Color statusColor, ECharacter character) {
    return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            character.status!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'alive':
        return Color(0xFF00452C);
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCharacterDetail(BuildContext context, ECharacter character) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return CharacterDetail(character: character);
      },
    );
  }
}
