import 'package:bpstate/bpstate.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rick/core/enum/c_status_gender.dart';
import 'package:prueba_rick/core/enum/c_status_options.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';
import 'package:prueba_rick/presentation/utils/extension/extension_build_context.dart';
import 'package:prueba_rick/presentation/utils/widgets/sw_input.dart';

class VHome extends StatefulWidget {
  const VHome({super.key});

  @override
  State<VHome> createState() => _VHomeState();
}

class _VHomeState extends State<VHome> {
  late BHome bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<BHome>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Character Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SWInput(
                  outData: bloc.outSearchInput,
                  inData: bloc.inSearchInput,
                  decoration: (error) => InputDecoration(
                    labelText: 'Search by Name',
                    labelStyle: context.body1,
                    border: const OutlineInputBorder(),
                    errorText: error,
                  ),
                ),
                const SizedBox(height: 10),
                
                Row(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: bloc.outSelectedStatusInput,
                        builder: (context, asyncSnapshot) {
                          return DropdownButtonFormField<String?>(
                            initialValue: null,
                            decoration: InputDecoration(
                              labelText: 'Status',
                              labelStyle: context.body1,
                              border: OutlineInputBorder(),
                            ),
                            items: CStatusOptions.values.map((status) {
                              return DropdownMenuItem(
                                value: status.name,
                                child: Text(status.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              bloc.inSelectedStatusInput(value!);
                              bloc.setFilter();
                            },
                          );
                        }
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: StreamBuilder(
                        stream: bloc.outSelectedGenderInput,
                        builder: (context, asyncSnapshot) {
                          return DropdownButtonFormField<String?>(
                            initialValue: null,
                            decoration: InputDecoration(labelText: 'Gender', labelStyle: context.body1, border: OutlineInputBorder()),
                            items: CStatusGender.values.map((gender) {
                              return DropdownMenuItem(
                                value: gender.name,
                                child: Text(gender.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              bloc.inSelectedGenderInput(value!);
                              bloc.setFilter();
                            },
                          );
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: SWInput(
                        outData: bloc.outSelectedSpeciesInput,
                        inData: bloc.inSelectedSpeciesInput,
                        decoration: (error) => InputDecoration(
                          labelText: 'Species',
                          labelStyle: context.body1,
                          border: const OutlineInputBorder(),
                          errorText: error,
                        ),                        
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SWInput(
                        outData: bloc.outSelectedTypeInput,
                        inData: bloc.inSelectedTypeInput,
                        decoration: (error) => InputDecoration(
                          labelText: 'Type',
                          labelStyle: context.body1,
                          border: const OutlineInputBorder(),
                          errorText: error,
                        )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: ()=> bloc.setFilter(), 
                  child: Text('Apply Filters', style: context.body1)
                ),
              ],
            ),
          ),
          
          const Divider(),

          Expanded(
            child: StreamBuilder(
              stream: bloc.outPage,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text(asyncSnapshot.error.toString()),
                  );
                } else if (asyncSnapshot.hasData) {
                  final results = asyncSnapshot.data!.results;
                  if (results != null && results.isNotEmpty) {
                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: character.image != null
                                    ? Image.network(
                                        character.image!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.broken_image, size: 50),
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
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No characters found'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
