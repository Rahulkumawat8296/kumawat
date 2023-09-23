
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Crud extends StatefulWidget {
  const Crud({Key? key}) : super(key: key);

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {

  final CollectionReference _table = FirebaseFirestore.instance.collection('user');

  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController branch = TextEditingController();

  String? get docId => null;

  

  _create()async{
    await showModalBottomSheet(context: context, builder:(BuildContext context){
      return Padding(
        padding: EdgeInsets.only(top: 20,left: 20,right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField( controller: name, decoration: InputDecoration(hintText: "Name")),
            TextField( controller: age, decoration: InputDecoration(hintText: "Age"),),
            TextField( controller: branch, decoration: InputDecoration(hintText: "Branch"),),
            SizedBox(height: 30,),
            ElevatedButton(onPressed: ()async{
              String? name1 = name.text;
              int? age1 = int.parse(age.text);
              String? branch1 = branch.text;
              _table.doc(docId).update({"Name":name1, "Age":age1, "Branch":branch1});
              name.text='';
              age.text='';

            }, child: Text("Add Data"))
          ],

        ),
      );
    });
  }

  _delete(String docId)async{
    await _table.doc(docId).delete();
  }
  _update(String docId){
    ElevatedButton(onPressed: ()async{
      String? name1 = name.text;
      int? age1 = int.parse(age.text);
      String? branch1 = branch.text;
      _table.doc(docId).update({"Name":name1, "Age":age1, "Branch":branch1});
      name.text='';
      age.text='';

    }, child: Text("Add Data"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _table.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData) {
          return ListView.builder(
         itemCount: streamSnapshot.data!.docs.length,
           itemBuilder: (context, index) {
          final DocumentSnapshot documentSnapshot =
          streamSnapshot.data!.docs[index];
          return Card(
            child: ListTile(
              title:Text( documentSnapshot["Name"]),
              subtitle: Text(documentSnapshot['Branch']),
             trailing: SizedBox(
               width: 100,
               child: Row(
                 children: [
                   IconButton(onPressed: (){}, icon:Icon(Icons.update)),
                   IconButton(onPressed: (){
                     _delete(documentSnapshot.id);
                   }, icon: Icon(Icons.delete)),
                 ],
               ),
             ),
            ),
          );
          },
        );

        }
        return Text("");
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _create();
        },child: Icon(Icons.add),
      ),
    );
  }



}