import 'package:flutter/material.dart';

class VodContent extends StatefulWidget {
  final List<dynamic> contentList;
  final String category;
  final List<Map<String, dynamic>> contentCategories;

  VodContent({required this.contentList, required this.category, required this.contentCategories});

  @override
  State<VodContent> createState() => _VodContentState();
}

class _VodContentState extends State<VodContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conteúdo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total de filmes: ${widget.contentList.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Categoria: ${widget.category}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Todas as categorias:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            // Lista de todas as categorias
            Text(
              'Todas as categorias:' +widget.contentCategories.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
