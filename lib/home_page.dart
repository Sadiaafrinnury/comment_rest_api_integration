import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rest_comment_api/model/model.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
List<CommentModel>commentList = [];

Future<List<CommentModel>>fetchComments()async{
  final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/comments"));

  if(response.statusCode==200){
    List<dynamic>data = jsonDecode(response.body);

    return data.map((json) => CommentModel.fromJson(json)).toList();
  }else{
    throw Exception("failed to load Comments");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
            "Comment Api",
          style: TextStyle(
              color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder(
          future: fetchComments(),
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }else if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty){
              return Center(child: Text("No Comments found"),);
            }else {
              return ListView.builder(
                  itemBuilder: (context, index) {
                    final comment = snapshot.data![index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(comment.name,
                        style: TextStyle(
                            color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                        ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(comment.email,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                color: Colors.red
                              ),),
                            SizedBox(height: 5,),
                            Text(
                              comment.body,
                              style: TextStyle(
                                  color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  },);
            }
          },)
    );
  }
}
