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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search input
          SWInput(
            outData: bloc.outSearchInput,
            inData: bloc.inSearchInput,
            decoration: (error) => InputDecoration(
              labelText: 'Search by Name',
              labelStyle: context.body1,
              hintText: 'Enter character name...',
              prefixIcon: Icon(Icons.search, color: context.colors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: context.colors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              errorText: error,
            ),
          ),
          const SizedBox(height: 16),

          // Status and Gender filters
          Row(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: bloc.outSelectedStatusInput,
                  builder: (context, asyncSnapshot) {
                    return DropdownButtonFormField<String?>(
                      value: asyncSnapshot.data,
                      decoration: InputDecoration(
                        labelText: 'Status',
                        labelStyle: context.body1,
                        prefixIcon: Icon(Icons.favorite_border, color: context.colors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
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
              const SizedBox(width: 12),
              Expanded(
                child: StreamBuilder(
                  stream: bloc.outSelectedGenderInput,
                  builder: (context, asyncSnapshot) {
                    return DropdownButtonFormField<String?>(
                      value: asyncSnapshot.data,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: context.body1,
                        prefixIcon: Icon(Icons.wc, color: context.colors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: context.colors.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
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
          const SizedBox(height: 16),

          // Species and Type filters
          Row(
            children: [
              Expanded(
                child: SWInput(
                  outData: bloc.outSelectedSpeciesInput,
                  inData: bloc.inSelectedSpeciesInput,
                  decoration: (error) => InputDecoration(
                    labelText: 'Species',
                    labelStyle: context.body1,
                    hintText: 'e.g., Human',
                    prefixIcon: Icon(Icons.science_outlined, color: context.colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    errorText: error,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SWInput(
                  outData: bloc.outSelectedTypeInput,
                  inData: bloc.inSelectedTypeInput,
                  decoration: (error) => InputDecoration(
                    labelText: 'Type',
                    labelStyle: context.body1,
                    hintText: 'Optional',
                    prefixIcon: Icon(Icons.category_outlined, color: context.colors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: context.colors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    errorText: error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Reset button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => bloc.resetFilter(),
              icon: Icon(Icons.menu, color: context.colors.neutral),
              label: Text(
                'Reset Filters',
                style: context.body1.copyWith(
                  color: context.colors.neutral,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: context.colors.primary),
                foregroundColor: context.colors.primary,
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}