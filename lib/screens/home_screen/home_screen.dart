import 'package:digitaldocumentid/documnts/document_list.dart';
import 'package:flutter/material.dart';
import 'document_tile.dart';
import '../../widget/drower.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    // final List<DocumentFormat> documents = DocumentList().documents;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: DrowerWidget(),
      body: FutureBuilder(
        future: DocumentList().documents(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: MediaQuery.of(context).size.width / 2,
                    childAspectRatio: 1 / 2,
                    mainAxisExtent: MediaQuery.of(context).size.width / 2.5,
                  ),
                  itemBuilder: (BuildContext context, index) {
                    return DocumentTile(
                      doc: (snapshot.data as List)[index],
                    );
                  },
                  itemCount:snapshot.connectionState ==
                      ConnectionState.waiting?0: (snapshot.data as List).length,
                ),
              ),
      ),
    );
  }
}
