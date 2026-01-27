import 'package:bpstate/bpstate.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rick/core/entities/e_character.dart';
import 'package:prueba_rick/core/entities/e_page.dart';
import 'package:prueba_rick/core/enum/c_status_gender.dart';
import 'package:prueba_rick/core/enum/c_status_options.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';
import 'package:prueba_rick/presentation/pages/home/widget/character_detail.dart';
import 'package:prueba_rick/presentation/pages/home/widget/filters_section.dart';
import 'package:prueba_rick/presentation/utils/extension/extension_build_context.dart';
import 'package:prueba_rick/presentation/utils/widgets/sw_input.dart';

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
      appBar: AppBar(title: const Text('Character Search')),
      body: Column(
        children: [
          FiltersSection(),
          const Divider(),
          Expanded(
            child: StreamBuilder<EPage<ECharacter>?>(
              stream: bloc.outPage,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          asyncSnapshot.error.toString(),
                          style: context.body1.copyWith(
                            color: context.colors.neutral3,
                          ),
                        ),
                        TextButton(
                          onPressed: () => bloc.getCharacters(),
                          child: Text(
                            'Retry',
                            style: context.body1.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                    asyncSnapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                final List<ECharacter>? results = asyncSnapshot.data!.results;
                if (results == null || results.isEmpty) {
                  return const Center(child: Text('No results found'));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    await bloc.getCharacters();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final character = results[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 4,
                        child: InkWell(
                          onTap: () => _showCharacterDetail(context, character),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: character.image != null
                                    ? Image.network(
                                        character.image!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      )
                                    : const Icon(Icons.person, size: 50),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  character.name ?? 'Unknown',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          StreamBuilder<bool>(
            stream: bloc.outLoading,
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.hasData && asyncSnapshot.data == true) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Uploading more characters...',
                    style: context.body1.copyWith(
                      color: context.colors.neutral5,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
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
