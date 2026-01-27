import 'package:bpstate/bpstate.dart';
import 'package:flutter/material.dart';
import 'package:prueba_rick/core/enum/c_status_gender.dart';
import 'package:prueba_rick/core/enum/c_status_options.dart';
import 'package:prueba_rick/presentation/pages/home/bloc/b_home.dart';
import 'package:prueba_rick/presentation/utils/extension/extension_build_context.dart';
import 'package:prueba_rick/presentation/utils/widgets/sw_input.dart';

class FiltersSection extends StatelessWidget {
  const FiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<BHome>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SWInput(
            outData:  bloc.outSearchInput,
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
                      initialValue: asyncSnapshot.data,
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
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StreamBuilder(
                  stream: bloc.outSelectedGenderInput,
                  builder: (context, asyncSnapshot) {
                    return DropdownButtonFormField<String?>(
                      initialValue: asyncSnapshot.data,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: context.body1,
                        border: OutlineInputBorder(),
                      ),
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
                  },
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
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => bloc.resetFilter(),
            child: Text('Reset filters', style: context.body1),
          ),
        ],
      ),
    );
  }
}