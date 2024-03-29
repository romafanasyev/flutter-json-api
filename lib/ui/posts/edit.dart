import 'package:flutter/material.dart';
import 'package:flutter_api/models/post.dart';
import 'package:flutter_api/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PostEditForm extends StatefulWidget {
  @override
  createState() => PostEditFormState();
}

class PostEditFormState extends State<PostEditForm> {
  Post post;

  static final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  final _titleNode = FocusNode();
  final _bodyNode = FocusNode();

  PostEditFormState();

  @override
  Widget build(BuildContext context) {

    post = ModalRoute.of(context).settings.arguments;
    _titleController.text = post.title;
    _bodyController.text = post.body;

    submit() async {
      var url = 'https://milioners.herokuapp.com/api/v1/posts/${post.id}';
      try {
        var response = await http.put(url, headers: User.headers,
            body: convert.jsonEncode({'title': _titleController.text, 'body': _bodyController.text})
        );
        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'Post was successfully edited.');
          Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
        }
        else
          showDialog(context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(convert.jsonDecode(response.body)['errors'].toString()),
                );
              }
          );
      } catch(e) {
        showDialog(context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("(Please check your Internet connection.)"),
              );
            }
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text("Edit Post")
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    focusNode: _titleNode,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: _titleController,
                    onFieldSubmitted: (term) {
                      _titleNode.unfocus();
                      FocusScope.of(context).requestFocus(_bodyNode);
                    },
                    decoration: InputDecoration(hintText: 'title'),
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Enter some text';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _bodyNode,
                    decoration: InputDecoration(hintText: 'body'),
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    controller: _bodyController,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'Enter some text';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          submit();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
