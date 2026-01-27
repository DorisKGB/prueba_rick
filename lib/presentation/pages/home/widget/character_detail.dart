import 'package:flutter/material.dart';
import 'package:prueba_rick/core/entities/e_character.dart';

class CharacterDetail extends StatelessWidget {
  const CharacterDetail({super.key, required this.character});
  final ECharacter character;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(character.image ?? ''),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) =>
                            const Icon(Icons.person, size: 50),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    character.name ?? 'Unknown Name',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _buildDetailRow('Status', character.status),
                _buildDetailRow('Species', character.species),
                _buildDetailRow('Gender', character.gender),
                _buildDetailRow('Type', character.type),
                _buildDetailRow('Origin', character.origin?.name),
                _buildDetailRow('Location', character.location?.name),
                const SizedBox(height: 20),
                const Text(
                  'Episodes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (character.episode != null && character.episode!.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: character.episode!.length,
                      itemBuilder: (context, index) {
                        final episodeUrl = character.episode![index];
                        final episodeId = episodeUrl.split('/').last;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.movie_creation_outlined),
                          title: Text('Episode $episodeId'),
                          subtitle: Text(episodeUrl),
                        );
                      },
                    ),
                  )
                else
                  const Text('No episodes found.'),
              ],
            ),
          ),
        );
  }
}
  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }