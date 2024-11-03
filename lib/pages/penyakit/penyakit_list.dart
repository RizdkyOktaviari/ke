import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../helpers/app_localizations.dart';
import '../../helpers/providers/auth_provider.dart';
import '../../helpers/providers/knowledge_provider.dart';
import 'detail.dart';

class PenyakitListPage extends StatefulWidget {
  @override
  State<PenyakitListPage> createState() => _PenyakitListPageState();
}

class _PenyakitListPageState extends State<PenyakitListPage> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      await Provider.of<KnowledgeProvider>(context, listen: false)
          .fetchKnowledge(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.diseaseMenu),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<KnowledgeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final knowledgeList = provider.knowledgeList;

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: knowledgeList.length,
            itemBuilder: (context, index) {
              final knowledge = knowledgeList[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(

                  title: Text(
                    knowledge.title,
                    style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  ),
                  subtitle: Text(
                    knowledge.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(knowledge: knowledge),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Pengetahuan {
  final String title;
  final String description;

  Pengetahuan({required this.title, required this.description});
}
