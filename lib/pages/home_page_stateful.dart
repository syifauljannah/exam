import 'package:flutter/material.dart';
import 'package:exam2/models/album.dart';
import 'package:exam2/services/album_service.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<Album> albums = [];
  bool isLoading = true;

  void fetchAlbums() async {
    final result = await AlbumService.fetchAlbums();
    albums = result;
    setState(() {});
    isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    fetchAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Api Stateful'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final user = albums[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.thumbnailUrl),
                    ),
                    title: Text('${user.id} ${user.title}'),
                    subtitle: Text(user.url),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => showEditDialog(user),
                          icon: const Icon(Icons.edit),
                          color: Colors.blue,
                        ),
                        IconButton(
                          onPressed: () => deleteAlbum(user.id),
                          icon: const Icon(Icons.delete),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  void deleteAlbum(int id) async {
    try {
      await AlbumService.deleteAlbum(id);
      setState(() {
        albums.removeWhere((album) => album.id == id);
      });
    } catch (e) {
      print('Gagal Untuk Menghapus Album:$e');
    }
  }

  void updateAlbum(Album album) async {
    try {
      await AlbumService.updateAlbum(album);
      setState(() {
        final index = albums.indexWhere((a) => a.id == album.id);
        if (index != -1) {
          albums[index] = album;
        }
      });
    } catch (e) {
      print('Gagal Untuk Mengedit Album: $e');
    }
  }

  void showEditDialog(Album album) {
    final titleController = TextEditingController(text: album.title);
    final urlController = TextEditingController(text: album.url);
    final thumbnailUrlController =
        TextEditingController(text: album.thumbnailUrl);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Album'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: urlController,
                decoration: const InputDecoration(labelText: 'URL'),
              ),
              TextField(
                controller: thumbnailUrlController,
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedAlbum = Album(
                  albumId: album.albumId,
                  id: album.id,
                  title: titleController.text,
                  url: urlController.text,
                  thumbnailUrl: thumbnailUrlController.text,
                );
                updateAlbum(updatedAlbum);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
