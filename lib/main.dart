////vertexai

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'response.dart';
import 'sql.dart';
import 'package:dart_openai/openai.dart';
import 'package:googleapis_auth/auth_io.dart';
import "package:googleapis/healthcare/v1.dart";

void main() {
  runApp(Chat());
}

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Chatpage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Chatpage extends StatefulWidget {
  @override
  State<Chatpage> createState() => _Chatpage();
}

class _Chatpage extends State<Chatpage> {
  List<String?> responses = [];
  List<String> _usertexts = [];
  TextEditingController textcontroller = TextEditingController();
  String c_id = "";
  bool button_view = true;
  late AuthClient client;

  @override
  initState() {
    // final accountCredentials= ServiceAccountCredentials.fromJson({
    //   "private_key_id": "9b6bca11290451a17d2ba98a2cd5ecccd814b27a",
    //   "private_key": "-----BEGIN PRIVATE KEY-----"
    //       "\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCJQ/iu7ruAyL8i"
    //       "\nCB9w1uh0tTPxU7xnc8kt8d7fY3bZiv9vg2Bub7JEgfGw/qW7d5p1gCrgDZ31JYa9"
    //       "\nEZmWCYLPSJccLySPWuRwXaO40kRi5/m+hiUsSAuhvpZAzyc+JLMS8+uqXlN+88vS"
    //       "\n8hVg4YiUrJf4cdlB6ANp/V8fvvvUrcawafodVyYQQn9k9OZv10mTPOUxV+b9sYls"
    //       "\ntnwVEh9Nnxt8WrHg13b+o/ilbfQNmAJ/9B2BxbdU0QxxLlvs17mwpsOJ8F06aKMP"
    //       "\nRrq/PBjj+QnrkvManTyAmtckIl+7acdTgAHQhXvrTTYGUrTpiHZaXxWuIoBNUgPE"
    //       "\njoo5y2FZAgMBAAECggEAIJZfN/KL17Vw8OyiQDj5G1n4gKq7QAk0QgDZw0l7Cgbu"
    //       "\ngQQc1OMWHJ8H6NfvsyugIxSgOSxqa2xzCjhfMMhFwp2uaD3F7XWr5YRJjeN3Yk7F"
    //       "\n0wZIVXSuNEJJrA2x+JYgYFfBw2Lc6jcJVOVtj2BDu14lPxGSPUwOYW+KUYBXC4Sz"
    //       "\n7uZDN++enyZ2o0Xnu2CebJYIRlcQ9sMv5hNu2O5myh0+/Ut1JL6pWfCjlatNoN4C"
    //       "\nIepBdzMLfECZAD5cphcQBMnYtLEb7lbTvV66liquuXGBNWfIVK5OvqbANLm7YAjp"
    //       "\nJn78wNznmasFHLa29TAsl9erB2VZXTs7/QtfHiiMPQKBgQC/xH1RTQQgKbKC6KY/"
    //       "\nfxE/TY60VHve+uPE1tOD/HlfPtbhXyt1/KXQeb9D9s5wtasBaRiDnKKSnXJes4oE"
    //       "\nSAKtQAvKt56QhgaETgIbR6f8n5Vj0AmtzIRWIcSj4WtoAc6YoSuz6NCMAztth+ef"
    //       "\nRK3I+FfWMlABzEAfgAy17LegjQKBgQC3PhdhMxlSpys27fgY1TuBvmPb8muwLv8A"
    //       "\nzlm3mopRD3XUNxVnDfPjwiN47ef3Z89FtgI5Zgo94azaxOVuXPqxaXAW5PCkahDL"
    //       "\nzd44Ml+rgebpDifEFPi89P5sftNQ2+D3zvG61enel4OTsJncGkY6DudZsYeClEtj"
    //       "\nzN2r6jIO/QKBgQCG0GLtWgBxf/7gKyBc+T6tyx9sxQwEWUrw4bn3SvIktG+qJxbN"
    //       "\nrpz/b+e3pvXApOagajryo5ZjDk8OJpf7pIhFNgZUMDxIDADe2FyAwyJk5efHMMTt"
    //       "\nKx9J0hmEwH+asdKE2KF5rE2YcNlBik6aWFT4OSa/DcXTTb0yp/nHl7AMLQKBgHcD"
    //       "\nL+Ikcwz4oBukAV/3lheVVXwz/fdG/r5CR4j1KWKufOPhBtiQ+ldx7uIK+n74gGmR"
    //       "\nZe5rtLkuSrsn6K9+WiBCD9f+x8CxVslXoz2ykepti1DQrckvqcHoCRrkYFEDDiFE"
    //       "\n2kFzz9qPY5jXuYZ31ia9KUta/10y/agLFeojSHHtAoGAJr+iJXRzBQqusFBVNmfq"
    //       "\nislwqAqUrUJ/z3aOfEXdtWpM3eW8csmSwsKeDd4wptPXEv4gCaUDHbwIhMDnlp+0"
    //       "\n4SjSySUpXNNoWkfzonNETRy8pj3iw3IsXCvPebgDxNJN4YzCzPyrfQl6MCAg6Tzb\n3jDcDV5ueu1OGnjZMoIiC0w=\n-----END PRIVATE KEY-----\n",

    //   "client_email": "healthcare-nlp@healthcare-nlp-386522.iam.gserviceaccount.com",
    //   "client_id": "101638777049825429937",
    //   "type": "service_account"
    // });

    // List<String> scopes=["https://www.googleapis.com/auth/cloud-platform"];

    // final accountCredentials= ServiceAccountCredentials.fromJson({
    //   "private_key_id": "61bce9afce9c07fcc282f736c65351fd6f3cca74",
    //   "private_key": "-----BEGIN PRIVATE KEY-----"
    //   "\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDCfk1/N2cG9K5T"
    //   "\nlZJdqoRtkkmb53PSoVBVd0baUuCsGQB3pP4sPaFIGfELeNzTMRQjA9fy8jB3lZTj"
    //   "\nDd2f9fFiPvEKSkvAkNaXkcQzv0SVhO4vNsUr492wssSI+HYehBCbPUr8KWepAFtg"
    //   "\nt/3CNwPkIw/ynOdOWkYfA3Zr8LOVP8kxUOvO5SpyQ7fBiMFY0vkl3eUejQ1xq/Y5"
    //   "\na4kU/l5xG/BViUz4s5okM/8+7epoedva2DR9gyHGGWeWqH0kZuMsEBuXSdd/iV03"
    //   "\n0EbCE/ZF9sJWqYCZEy+UKG6YaBBnOLPMZmnU+DDNBNBhLF2iJpoGd6X1Y8zubeQH"
    //   "\n/vuIYhUTAgMBAAECggEAX+OTY7A17FkABZeNlP530em4vtOq5+K+T5TB6uvHdzHQ"
    //   "\naCyBX+B2vqyDietpu/nLesPvWQkM2jh2Mkdox++itZRglHkyxdri4dFtETIwpyLl"
    //   "\np4NyTIRIjVBl0z3kRoFICrF6Yb4sLEdPxeyQgItNMNIUj8HJzHh3b9zuKqN+dosj"
    //   "\nGyBA56XbsBt1f9x0gX5gR1TF6mY9T4iYqCd+KFK81d7UIuIjQJxHRVTxdVS3Raqg"
    //   "\n+ECiSPwuuBbYiSA54A0N8Bu4LhIcUCHffBTZJ0PL8Wm1MCQalAwftURAtEHdgIS/"
    //   "\nMIw/QBwbkY9KOeNQUogT9isAR3evEJLkEu6KC3MueQKBgQDkHl9xhoi9oBl/CFdG"
    //   "\n719/a8/DH0yFGg0t3A9TfLA2HILz0emW7eRHDqlloNGHUCabPKYEWaSgZP5/C+Dp"
    //   "\nqZSjg1ySrFf+hezT/MdQHJG0hvzQ/Ons5YPYY6fNQPVY9LCXtVI2NzEPoScD+z4u"
    //   "\n2fiU4rWkQkQDes52q6MfWGy6PQKBgQDaQ9NIaoTafcqwbfDlGHKAtZIEXyKN4+G/"
    //   "\nEKgNwnLU87GurEhTyH+CWxiArIFuptI0m42LO909dAtl6nWpAyUbg1LE212lE9XK"
    //   "\nadlwgFepQBmnXefV//a4yCgpirSVFxkqkjDgZfMWw18AHjsdBxneNED6ISi4R80O"
    //   "\n+8G79OgRjwKBgQCH0NmMcsf49lgXvPSRpDUcXSkOiBT77h3Inwt07njPTrxcxC6q"
    //   "\nEKrn73/FpTD6uiqyJDLHxkNwx5CKPZ1EIRYBIFW+cePWAxCUyhw0wz2w2Omu19XC"
    //   "\nmIeeDv86AiHRO6XkPS1cYBHSt2TORwinxljs8+mniViLJdPE7b2qDPB3FQKBgQCm"
    //   "\nW3HLTRzLZ3s4c+NaygJj5YBQgq5UlW73cNuV+TIK617vMnLCIRxGn+YSFOlmDBJF"
    //   "\ndJYynEMpVqxlVomtcy8yRCquzkAW1QJrD7hiTgACiU/ESAevDTPgbPZni0fOJtfQ"
    //   "\nobJNJodcPzbGYURPAJ2PxiYMP3/IzTkXBX4JI0ZKMwKBgQCTzHz/eCTdNy8+7mtK"
    //   "\nLWtTTPEJJSmkVZG8Kxc5rZF2RAdQIrBdn5jM+im94wdug328/tYbmLyRI3HmHBAM"
    //   "\neKfU1DvIZwgv6zUfhAxmFUliPWjxBCry0emddSKH0X0CIYimsuDHostZO00Pi0wg"
    //   "\nEuLjvKUaZYgOjoWd30SCoFd0jA==\n-----END PRIVATE KEY-----\n",

    //   "client_email": "text-summarization-vertex-ai@text-summarization-vertex-ai.iam.gserviceaccount.com",
    //   "client_id": "114337071845277274348",
    //   "type": "service_account"
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    // client = await clientViaServiceAccount(accountCredentials, scopes);});
    // super.initState();
  }

  get_response3(String text) async {
    Uri url = Uri.https("apresults1.pythonanywhere.com", "/textsummarisation");
    print(url);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    };
    Map data = {"text": text};
    http.Response res =
        await http.post(url, body: jsonEncode(data), headers: headers);
    if (res.statusCode == 200) {
      Map final_res = jsonDecode(res.body);
      return final_res["response"];
    } else {
      print(jsonDecode(res.body));
      return "error";
    }
  }

  // get_response1(String text){
  //   OpenAI.apiKey= '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';
  //   Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat.createStream(
  //     model: "gpt-3.5-turbo",
  //     messages: [
  //       OpenAIChatCompletionChoiceMessageModel(
  //         content: text,
  //         role: OpenAIChatMessageRole.user,
  //       )
  //     ],
  //   );
  //   chatStream.listen((event) {
  //     setState(() {
  //       responses[responses.length-1]=responses[responses.length-1]!+event.choices.first.delta.content!;
  //     });
  //   },onDone: () => setState(() {
  //     button_view=true;
  //   }),onError: (e){setState((){responses[responses.length-1]="something went wrong";});});

  // }

  get_response2(String text) async {
    // var url = Uri.https("healthcare.googleapis.com","/v1beta1/nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp:analyzeEntities");
    // var url1 =Uri.parse("https://healthcare.googleapis.com/v1beta1/{nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp}:analyzeEntities");
    // print(url);
    // print(url1);
    // Map body = {
    //   'documentContent':text
    // };
    AnalyzeEntitiesRequest request =
        AnalyzeEntitiesRequest(documentContent: text);
    AnalyzeEntitiesResponse res = await CloudHealthcareApi(
      client,
    ).projects.locations.services.nlp.analyzeEntities(request,
        "projects/healthcare-nlp-386522/locations/asia-south1/services/nlp");
    // var res = await client.post(url,body:body );
    List<TableRow> entitymentions = [];
    entitymentions.add(TableRow(children: [
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text("content",
              style: TextStyle(fontWeight: FontWeight.bold))),
      // Container(padding: const EdgeInsets.only(left: 5),child:const Text("linked entities",style: TextStyle(fontWeight:FontWeight.bold))),
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text(
            "Certainity Assesment",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text("Temporal Assesment",
              style: TextStyle(fontWeight: FontWeight.bold))),
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text("subject",
              style: TextStyle(fontWeight: FontWeight.bold))),
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text("type",
              style: TextStyle(fontWeight: FontWeight.bold))),
    ]));
    linkdcl(List<LinkedEntity>? le) {
      List arr = [];
      if (le != null) {
        for (var d in le) {
          arr.add(d.entityId);
          return arr;
        }
      } else {
        return "NaN";
      }
    }

    try {
      int len = 0;
      if (res.entityMentions != null) {
        len = res.entityMentions!.length;
      }
      for (int i = 0; i < len; i++) {
        entitymentions.add(TableRow(children: [
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entityMentions![i].text!.content!)),
          // Container(padding: const EdgeInsets.only(left: 5),child:Text("${linkdcl(res.entityMentions![i].linkedEntities)}")),
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entityMentions![i].certaintyAssessment == null
                  ? "NaN"
                  : res.entityMentions![i].certaintyAssessment!.value!)),
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entityMentions![i].temporalAssessment == null
                  ? "NaN"
                  : res.entityMentions![i].temporalAssessment!.value!)),
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entityMentions![i].subject == null
                  ? "NaN"
                  : res.entityMentions![i].subject!.value!)),
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entityMentions![i].type!))
        ]));
      }
    } on Exception catch (e) {
      print(e);
    }

    List<TableRow> entity = [];
    entity.add(TableRow(children: [
      // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Entity Id",style: TextStyle(fontWeight:FontWeight.bold),)),
      Container(
          padding: const EdgeInsets.only(left: 5),
          child: const Text("Preffered Term",
              style: TextStyle(fontWeight: FontWeight.bold))),
    ]));
    try {
      int len = 0;
      if (res.entities != null) {
        len = res.entities!.length;
      }
      for (int i = 0; i < len; i++) {
        entity.add(TableRow(children: [
          // Container(padding: const EdgeInsets.only(left: 5),child:Text(res.entities![i].entityId!)),
          Container(
              padding: const EdgeInsets.only(left: 5),
              child: Text(res.entities![i].preferredTerm!))
        ]));
      }
    } on Exception catch (e) {}

    // List<TableRow> relationships=[];
    // relationships.add(
    //   TableRow(
    //     children: [
    //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Subject Id",style: TextStyle(fontWeight:FontWeight.bold))),
    //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Object Id",style: TextStyle(fontWeight:FontWeight.bold))),
    //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Confidence",style: TextStyle(fontWeight:FontWeight.bold)))
    //     ]
    //   )
    // );
    // try{
    //   int len=0;
    //   if (res.relationships!=null){
    //   len = res.relationships!.length;}
    //   for(int i=0;i<len;i++){
    //     relationships.add(TableRow(
    //       children: [
    //         Container(padding: const EdgeInsets.only(left: 5),child:Text(res.relationships![i].subjectId!)),
    //         Container(padding: const EdgeInsets.only(left: 5),child:Text(res.relationships![i].objectId!)),
    //         Container(padding: const EdgeInsets.only(left: 5),child:Text("${res.relationships![i].confidence!}"))
    //       ]
    //     ));
    //   }
    // }on Exception catch(e){print(e);}

    // for (int i=0; i<res.entities!.length;i++){
    //   print("""${res.entities![i].preferredTerm}
    //   ${res.entities![i].entityId}
    //   ${res.entities![i].vocabularyCodes}""");
    // }
    // // for (int? i=0 ; i<res.relationships?.length;i++){
    // //   print("""${res.relationships![i].subjectId}
    // //   ${res.relationships![i].objectId}
    // //   ${res.relationships![i].confidence}
    // //   """);
    // // }
    // for (int i=0; i<res.entityMentions!.length;i++){
    //   print("""${res.entityMentions![i].text!.content}
    //   ${res.entityMentions![i].type}
    //   """);
    // }
    // print("hi");
    // print(res.entityMentions!.first.text!.content);
    return [entity, entitymentions];
  }

  Widget chatscreen(
      BuildContext context, List<String?> responses, List<String> _userinputs) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 83,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 180),
                  child: Chatlist(context, responses, _userinputs)),
              Inputwidget(context),
            ],
          ),
        ));
  }

  Widget Chatlist(
      BuildContext context, List<String?> responses, List<String> _userinputs) {
    return Container(
        height: MediaQuery.of(context).size.height - 180,
        child: ListView.builder(
            reverse: true,
            itemCount: _userinputs.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  ChatBubble(context, _userinputs.reversed.toList()[i],
                      Alignment.bottomRight, true),
                  const SizedBox(
                    height: 10,
                  ),
                  // if(responses.length<_userinputs.length) ChatBubble(context, i==0?"Waiting for response":responses.reversed.toList()[i], Alignment.bottomLeft, false),
                  ChatBubble(context, responses.reversed.toList()[i],
                      Alignment.bottomLeft, false),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }));
  }

  Widget Inputwidget(
    BuildContext context,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8, 15, 8, 10),
      elevation: 3,
      child: Row(children: [
        Container(
          width: MediaQuery.of(context).size.width - 64,
          child: TextFormField(
            maxLines: 3,
            minLines: 1,
            controller: textcontroller,
            decoration: InputDecoration(
                hintText: "Enter your message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ),
        button_view
            ? IconButton(
                onPressed: () async {
                  String text = textcontroller.text;
                  print(text);
                  setState(() {
                    _usertexts.add(text);
                    textcontroller.text = "";
                    responses.add("Waiting for the response"
                        //   [
                        //   [const TableRow(children:[ Text("waiting for response")])],
                        //   [const TableRow(children:[ Text("waiting for response")])],
                        //   [const TableRow(children:[ Text("waiting for response")])]
                        // ]
                        );
                  });
                  var response;
                  var response1;
                  if (text.toLowerCase().contains("balance")) {
                    response = await connecting(
                        "balance", "customer", text.substring(text.length - 5));
                    if (response.length != 0) {
                      response =
                          "your remaining account balance is ${response}";
                    } else {
                      response = "error";
                    }
                  } else if (text.toLowerCase().contains("date")) {
                    response = await connecting("opening_date", "customer",
                        text.substring(text.length - 5));
                    if (response.length != 0) {
                      response = "your account opening date is ${response}";
                    } else {
                      response = "error";
                    }
                  } else if (text.toLowerCase().contains("transaction")) {
                    response = await connecting("last_transaction_date",
                        "customer", text.substring(text.length - 5));
                    if (response.length != 0) {
                      response = "your last transaction date is ${response}";
                    } else {
                      response = "error";
                    }
                  } else if (text.toLowerCase().contains("product")) {
                    response = await connecting("crosssell", "product",
                        text.substring(text.length - 5));
                    if (response.length != 0) {
                      response = "products available for you are ${response}";
                    } else {
                      response = "error";
                    }
                  } else {
                    setState(() {
                      button_view = false;
                    });
                    response = await get_response3(text);
                  }
                  if (response != "error") {
                    responses.add(response);
                    setState(() {
                      responses.removeAt(responses.length - 2);
                      button_view = true;
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Something went wrong",
                        backgroundColor: Colors.red);
                    setState(() {
                      // responses.add("sorry unable to respond to you, please reach us at 9999999999");
                    });
                  }
                },
                icon: Icon(
                  Icons.send,
                  color: Colors.black.withOpacity(0.6),
                ))
            : SizedBox.shrink()
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text(
                  "AiProff",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.indigo[300],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [chatscreen(context, responses, _usertexts)],
                ),
              ),
            ));
  }
}

Widget appbar(BuildContext context) {
  return Card(
      elevation: 6,
      child: Container(
        alignment: Alignment.bottomCenter,
        height: 75,
        width: double.infinity,
        color: Colors.indigo[300],
        child: Row(
          children: [
            // IconButton(onPressed: (){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
            // }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
            const SizedBox(
              width: 20,
            ),
            const Text(
              "AI",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Card(
                elevation: 5,
                margin: const EdgeInsets.fromLTRB(105, 5, 10, 5),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.generating_tokens_sharp,
                        color: Colors.yellow,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "10",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ));
}

Widget ChatBubble_Table(BuildContext context, List<List<TableRow>> tables,
    Alignment alignment, bool user) {
  return Align(
    alignment: alignment,
    child: Container(
      padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
      child: Column(children: [
        Table(
          children: tables[0],
          border: TableBorder.all(width: 2, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Table(
          children: tables[1],
          border: TableBorder.all(width: 2, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        // Table(children: tables[2],
        // border: TableBorder.all(width: 2,color: Colors.black),
        // )h
      ]),
    ),
  );
}

Widget ChatBubble(
  BuildContext context,
  String? text,
  Alignment alignment,
  bool user,
) {
  return Align(
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
        constraints: const BoxConstraints(maxWidth: 200, minHeight: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: user
              ? Colors.pinkAccent.withOpacity(0.3)
              : Colors.blueAccent.withOpacity(0.3),
        ),
        child: text == ""
            ? SelectableText("sorry unable to fetch",
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.black54))
            : SelectableText(text!,
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.black54)),
      ));
}
//       // //////vertexai





// // ////////////////////
// // import 'package:flutter/material.dart';
// // import 'package:googleapis/cloudasset/v1.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'dart:convert';
// // import 'response.dart';
// // import 'sql.dart';
// // import 'package:dart_openai/openai.dart';
// // import 'package:googleapis_auth/auth_io.dart';
// // import "package:googleapis/healthcare/v1.dart";

// // void main() {
// //   runApp(Chat());
// // }

// // class Chat extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Chatpage(),
// //     );
// //   }
// // }

// // class Chatpage extends StatefulWidget {
// //   @override
// //   State<Chatpage> createState() => _Chatpage();
// // }

// // class _Chatpage extends State<Chatpage> {
// //   List<List<List<TableRow>>> responses = [];
// //   List<String> _usertexts = [];
// //   TextEditingController textcontroller = TextEditingController();
// //   String c_id = "";
// //   bool button_view = true;
// //   late AuthClient client;

// //   @override
// //   initState() {
// //     final accountCredentials = ServiceAccountCredentials.fromJson({
// //       "private_key_id": "9b6bca11290451a17d2ba98a2cd5ecccd814b27a",
// //       "private_key": "-----BEGIN PRIVATE KEY-----"
// //           "\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCJQ/iu7ruAyL8i"
// //           "\nCB9w1uh0tTPxU7xnc8kt8d7fY3bZiv9vg2Bub7JEgfGw/qW7d5p1gCrgDZ31JYa9"
// //           "\nEZmWCYLPSJccLySPWuRwXaO40kRi5/m+hiUsSAuhvpZAzyc+JLMS8+uqXlN+88vS"
// //           "\n8hVg4YiUrJf4cdlB6ANp/V8fvvvUrcawafodVyYQQn9k9OZv10mTPOUxV+b9sYls"
// //           "\ntnwVEh9Nnxt8WrHg13b+o/ilbfQNmAJ/9B2BxbdU0QxxLlvs17mwpsOJ8F06aKMP"
// //           "\nRrq/PBjj+QnrkvManTyAmtckIl+7acdTgAHQhXvrTTYGUrTpiHZaXxWuIoBNUgPE"
// //           "\njoo5y2FZAgMBAAECggEAIJZfN/KL17Vw8OyiQDj5G1n4gKq7QAk0QgDZw0l7Cgbu"
// //           "\ngQQc1OMWHJ8H6NfvsyugIxSgOSxqa2xzCjhfMMhFwp2uaD3F7XWr5YRJjeN3Yk7F"
// //           "\n0wZIVXSuNEJJrA2x+JYgYFfBw2Lc6jcJVOVtj2BDu14lPxGSPUwOYW+KUYBXC4Sz"
// //           "\n7uZDN++enyZ2o0Xnu2CebJYIRlcQ9sMv5hNu2O5myh0+/Ut1JL6pWfCjlatNoN4C"
// //           "\nIepBdzMLfECZAD5cphcQBMnYtLEb7lbTvV66liquuXGBNWfIVK5OvqbANLm7YAjp"
// //           "\nJn78wNznmasFHLa29TAsl9erB2VZXTs7/QtfHiiMPQKBgQC/xH1RTQQgKbKC6KY/"
// //           "\nfxE/TY60VHve+uPE1tOD/HlfPtbhXyt1/KXQeb9D9s5wtasBaRiDnKKSnXJes4oE"
// //           "\nSAKtQAvKt56QhgaETgIbR6f8n5Vj0AmtzIRWIcSj4WtoAc6YoSuz6NCMAztth+ef"
// //           "\nRK3I+FfWMlABzEAfgAy17LegjQKBgQC3PhdhMxlSpys27fgY1TuBvmPb8muwLv8A"
// //           "\nzlm3mopRD3XUNxVnDfPjwiN47ef3Z89FtgI5Zgo94azaxOVuXPqxaXAW5PCkahDL"
// //           "\nzd44Ml+rgebpDifEFPi89P5sftNQ2+D3zvG61enel4OTsJncGkY6DudZsYeClEtj"
// //           "\nzN2r6jIO/QKBgQCG0GLtWgBxf/7gKyBc+T6tyx9sxQwEWUrw4bn3SvIktG+qJxbN"
// //           "\nrpz/b+e3pvXApOagajryo5ZjDk8OJpf7pIhFNgZUMDxIDADe2FyAwyJk5efHMMTt"
// //           "\nKx9J0hmEwH+asdKE2KF5rE2YcNlBik6aWFT4OSa/DcXTTb0yp/nHl7AMLQKBgHcD"
// //           "\nL+Ikcwz4oBukAV/3lheVVXwz/fdG/r5CR4j1KWKufOPhBtiQ+ldx7uIK+n74gGmR"
// //           "\nZe5rtLkuSrsn6K9+WiBCD9f+x8CxVslXoz2ykepti1DQrckvqcHoCRrkYFEDDiFE"
// //           "\n2kFzz9qPY5jXuYZ31ia9KUta/10y/agLFeojSHHtAoGAJr+iJXRzBQqusFBVNmfq"
// //           "\nislwqAqUrUJ/z3aOfEXdtWpM3eW8csmSwsKeDd4wptPXEv4gCaUDHbwIhMDnlp+0"
// //           "\n4SjSySUpXNNoWkfzonNETRy8pj3iw3IsXCvPebgDxNJN4YzCzPyrfQl6MCAg6Tzb\n3jDcDV5ueu1OGnjZMoIiC0w=\n-----END PRIVATE KEY-----\n",
// //       "client_email":
// //           "healthcare-nlp@healthcare-nlp-386522.iam.gserviceaccount.com",
// //       "client_id": "101638777049825429937",
// //       "type": "service_account"
// //     });
// //     List<String> scopes = ["https://www.googleapis.com/auth/cloud-healthcare"];
// //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// //       client = await clientViaServiceAccount(accountCredentials, scopes);
// //     });
// //     super.initState();
// //   }

// //   // get_response1(String text){
// //   //   OpenAI.apiKey= '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';
// //   //   Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat.createStream(
// //   //     model: "gpt-3.5-turbo",
// //   //     messages: [
// //   //       OpenAIChatCompletionChoiceMessageModel(
// //   //         content: text,
// //   //         role: OpenAIChatMessageRole.user,
// //   //       )
// //   //     ],
// //   //   );
// //   //   chatStream.listen((event) {
// //   //     setState(() {
// //   //       responses[responses.length-1]=responses[responses.length-1]!+event.choices.first.delta.content!;
// //   //     });
// //   //   },onDone: () => setState(() {
// //   //     button_view=true;
// //   //   }),onError: (e){setState((){responses[responses.length-1]="something went wrong";});});

// //   // }

// //   get_response2(String text) async {
// //     // var url = Uri.https("healthcare.googleapis.com","/v1beta1/nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp:analyzeEntities");
// //     // var url1 =Uri.parse("https://healthcare.googleapis.com/v1beta1/{nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp}:analyzeEntities");
// //     // print(url);
// //     // print(url1);
// //     // Map body = {
// //     //   'documentContent':text
// //     // };
// //     AnalyzeEntitiesRequest request =
// //         AnalyzeEntitiesRequest(documentContent: text);
// //     AnalyzeEntitiesResponse res = await CloudHealthcareApi(
// //       client,
// //     ).projects.locations.services.nlp.analyzeEntities(request,
// //         "projects/healthcare-nlp-386522/locations/asia-south1/services/nlp");
// //     // var res = await client.post(url,body:body );
// //     List<TableRow> entitymentions = [];
// //     entitymentions.add(TableRow(children: [
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text("content",
// //               style: TextStyle(fontWeight: FontWeight.bold))),
// //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("linked entities",style: TextStyle(fontWeight:FontWeight.bold))),
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text(
// //             "Certainity Assesment",
// //             style: TextStyle(fontWeight: FontWeight.bold),
// //           )),
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text("Temporal Assesment",
// //               style: TextStyle(fontWeight: FontWeight.bold))),
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text("subject",
// //               style: TextStyle(fontWeight: FontWeight.bold))),
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text("type",
// //               style: TextStyle(fontWeight: FontWeight.bold))),
// //     ]));
// //     linkdcl(List<LinkedEntity>? le) {
// //       List arr = [];
// //       if (le != null) {
// //         for (var d in le) {
// //           arr.add(d.entityId);
// //           return arr;
// //         }
// //       } else {
// //         return "NaN";
// //       }
// //     }

// //     try {
// //       int len = 0;
// //       if (res.entityMentions != null) {
// //         len = res.entityMentions!.length;
// //       }
// //       for (int i = 0; i < len; i++) {
// //         entitymentions.add(TableRow(children: [
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entityMentions![i].text!.content!)),
// //           // Container(padding: const EdgeInsets.only(left: 5),child:Text("${linkdcl(res.entityMentions![i].linkedEntities)}")),
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entityMentions![i].certaintyAssessment == null
// //                   ? "NaN"
// //                   : res.entityMentions![i].certaintyAssessment!.value!)),
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entityMentions![i].temporalAssessment == null
// //                   ? "NaN"
// //                   : res.entityMentions![i].temporalAssessment!.value!)),
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entityMentions![i].subject == null
// //                   ? "NaN"
// //                   : res.entityMentions![i].subject!.value!)),
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entityMentions![i].type!))
// //         ]));
// //       }
// //     } on Exception catch (e) {
// //       print(e);
// //     }

// //     List<TableRow> entity = [];
// //     entity.add(TableRow(children: [
// //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Entity Id",style: TextStyle(fontWeight:FontWeight.bold),)),
// //       Container(
// //           padding: const EdgeInsets.only(left: 5),
// //           child: const Text("Preffered Term",
// //               style: TextStyle(fontWeight: FontWeight.bold))),
// //     ]));
// //     try {
// //       int len = 0;
// //       if (res.entities != null) {
// //         len = res.entities!.length;
// //       }
// //       for (int i = 0; i < len; i++) {
// //         entity.add(TableRow(children: [
// //           // Container(padding: const EdgeInsets.only(left: 5),child:Text(res.entities![i].entityId!)),
// //           Container(
// //               padding: const EdgeInsets.only(left: 5),
// //               child: Text(res.entities![i].preferredTerm!))
// //         ]));
// //       }
// //     } on Exception catch (e) {}

// //     // List<TableRow> relationships=[];
// //     // relationships.add(
// //     //   TableRow(
// //     //     children: [
// //     //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Subject Id",style: TextStyle(fontWeight:FontWeight.bold))),
// //     //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Object Id",style: TextStyle(fontWeight:FontWeight.bold))),
// //     //       // Container(padding: const EdgeInsets.only(left: 5),child:const Text("Confidence",style: TextStyle(fontWeight:FontWeight.bold)))
// //     //     ]
// //     //   )
// //     // );
// //     // try{
// //     //   int len=0;
// //     //   if (res.relationships!=null){
// //     //   len = res.relationships!.length;}
// //     //   for(int i=0;i<len;i++){
// //     //     relationships.add(TableRow(
// //     //       children: [
// //     //         Container(padding: const EdgeInsets.only(left: 5),child:Text(res.relationships![i].subjectId!)),
// //     //         Container(padding: const EdgeInsets.only(left: 5),child:Text(res.relationships![i].objectId!)),
// //     //         Container(padding: const EdgeInsets.only(left: 5),child:Text("${res.relationships![i].confidence!}"))
// //     //       ]
// //     //     ));
// //     //   }
// //     // }on Exception catch(e){print(e);}

// //     // for (int i=0; i<res.entities!.length;i++){
// //     //   print("""${res.entities![i].preferredTerm}
// //     //   ${res.entities![i].entityId}
// //     //   ${res.entities![i].vocabularyCodes}""");
// //     // }
// //     // // for (int? i=0 ; i<res.relationships?.length;i++){
// //     // //   print("""${res.relationships![i].subjectId}
// //     // //   ${res.relationships![i].objectId}
// //     // //   ${res.relationships![i].confidence}
// //     // //   """);
// //     // // }
// //     // for (int i=0; i<res.entityMentions!.length;i++){
// //     //   print("""${res.entityMentions![i].text!.content}
// //     //   ${res.entityMentions![i].type}
// //     //   """);
// //     // }
// //     // print("hi");
// //     // print(res.entityMentions!.first.text!.content);
// //     return [entity, entitymentions];
// //   }

// //   Widget chatscreen(BuildContext context, List<List<List<TableRow>>> responses,
// //       List<String> _userinputs) {
// //     return Container(
// //         width: double.infinity,
// //         height: MediaQuery.of(context).size.height - 83,
// //         color: Colors.white,
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: [
// //               Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 4),
// //                   constraints: BoxConstraints(
// //                       minHeight: MediaQuery.of(context).size.height - 180),
// //                   child: Chatlist(context, responses, _userinputs)),
// //               Inputwidget(context),
// //             ],
// //           ),
// //         ));
// //   }

// //   Widget Chatlist(BuildContext context, List<List<List<TableRow>>> responses,
// //       List<String> _userinputs) {
// //     return Container(
// //         height: MediaQuery.of(context).size.height - 180,
// //         child: ListView.builder(
// //             reverse: true,
// //             itemCount: _userinputs.length,
// //             itemBuilder: (context, i) {
// //               return Column(
// //                 children: [
// //                   ChatBubble(context, _userinputs.reversed.toList()[i],
// //                       Alignment.bottomRight, true),
// //                   const SizedBox(
// //                     height: 10,
// //                   ),
// //                   // if(responses.length<_userinputs.length) ChatBubble(context, i==0?"Waiting for response":responses.reversed.toList()[i], Alignment.bottomLeft, false),
// //                   ChatBubble_Table(context, responses.reversed.toList()[i],
// //                       Alignment.bottomLeft, false),
// //                   const SizedBox(
// //                     height: 10,
// //                   ),
// //                 ],
// //               );
// //             }));
// //   }

// //   Widget Inputwidget(
// //     BuildContext context,
// //   ) {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       color: Colors.white,
// //       margin: const EdgeInsets.fromLTRB(8, 15, 8, 10),
// //       elevation: 3,
// //       child: Row(children: [
// //         Container(
// //           width: MediaQuery.of(context).size.width - 64,
// //           child: TextFormField(
// //             maxLines: 3,
// //             minLines: 1,
// //             controller: textcontroller,
// //             decoration: InputDecoration(
// //                 hintText: "Enter your message",
// //                 border: OutlineInputBorder(
// //                   borderRadius: BorderRadius.circular(10),
// //                 )),
// //           ),
// //         ),
// //         button_view
// //             ? IconButton(
// //                 onPressed: () async {
// //                   String text = textcontroller.text;
// //                   print(text);
// //                   setState(() {
// //                     _usertexts.add(text);
// //                     textcontroller.text = "";
// //                     responses.add([
// //                       [
// //                         const TableRow(children: [Text("waiting for response")])
// //                       ],
// //                       [
// //                         const TableRow(children: [Text("waiting for response")])
// //                       ],
// //                       [
// //                         const TableRow(children: [Text("waiting for response")])
// //                       ]
// //                     ]);
// //                   });
// //                   var response;
// //                   var response1;
// //                   if (text.toLowerCase().contains("balance")) {
// //                     response = await connecting(
// //                         "balance", "customer", text.substring(text.length - 5));
// //                     if (response.length != 0) {
// //                       response =
// //                           "your remaining account balance is ${response}";
// //                     } else {
// //                       response = "error";
// //                     }
// //                   } else if (text.toLowerCase().contains("date")) {
// //                     response = await connecting("opening_date", "customer",
// //                         text.substring(text.length - 5));
// //                     if (response.length != 0) {
// //                       response = "your account opening date is ${response}";
// //                     } else {
// //                       response = "error";
// //                     }
// //                   } else if (text.toLowerCase().contains("transaction")) {
// //                     response = await connecting("last_transaction_date",
// //                         "customer", text.substring(text.length - 5));
// //                     if (response.length != 0) {
// //                       response = "your last transaction date is ${response}";
// //                     } else {
// //                       response = "error";
// //                     }
// //                   } else if (text.toLowerCase().contains("product")) {
// //                     response = await connecting("crosssell", "product",
// //                         text.substring(text.length - 5));
// //                     if (response.length != 0) {
// //                       response = "products available for you are ${response}";
// //                     } else {
// //                       response = "error";
// //                     }
// //                   } else {
// //                     setState(() {
// //                       button_view = false;
// //                     });
// //                     response = await get_response2(text);
// //                   }
// //                   if (response != "error") {
// //                     responses.add(response);
// //                     setState(() {
// //                       responses.removeAt(responses.length - 2);
// //                       button_view = true;
// //                     });
// //                   } else {
// //                     Fluttertoast.showToast(
// //                         msg: "Something went wrong",
// //                         backgroundColor: Colors.red);
// //                     setState(() {
// //                       // responses.add("sorry unable to respond to you, please reach us at 9999999999");
// //                     });
// //                   }
// //                 },
// //                 icon: Icon(
// //                   Icons.send,
// //                   color: Colors.black.withOpacity(0.6),
// //                 ))
// //             : SizedBox.shrink()
// //       ]),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Builder(
// //         builder: (context) => Scaffold(
// //               appBar: AppBar(
// //                 title: Text(
// //                   "AiProff",
// //                   style: TextStyle(color: Colors.white),
// //                 ),
// //                 backgroundColor: Colors.indigo[300],
// //               ),
// //               body: SingleChildScrollView(
// //                 child: Column(
// //                   children: [chatscreen(context, responses, _usertexts)],
// //                 ),
// //               ),
// //             ));
// //   }
// // }

// // Widget appbar(BuildContext context) {
// //   return Card(
// //       elevation: 6,
// //       child: Container(
// //         alignment: Alignment.bottomCenter,
// //         height: 75,
// //         width: double.infinity,
// //         color: Colors.indigo[300],
// //         child: Row(
// //           children: [
// //             // IconButton(onPressed: (){
// //             //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
// //             // }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
// //             const SizedBox(
// //               width: 20,
// //             ),
// //             const Text(
// //               "AI",
// //               style: TextStyle(
// //                   fontSize: 20,
// //                   fontWeight: FontWeight.bold,
// //                   color: Colors.white),
// //             ),
// //             Card(
// //                 elevation: 5,
// //                 margin: const EdgeInsets.fromLTRB(105, 5, 10, 5),
// //                 child: Container(
// //                   padding: EdgeInsets.symmetric(horizontal: 10),
// //                   decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(10),
// //                       color: Colors.white),
// //                   child: Row(
// //                     children: const [
// //                       Icon(
// //                         Icons.generating_tokens_sharp,
// //                         color: Colors.yellow,
// //                       ),
// //                       SizedBox(
// //                         width: 10,
// //                       ),
// //                       Text(
// //                         "10",
// //                         style: TextStyle(
// //                             fontWeight: FontWeight.bold, color: Colors.black),
// //                       ),
// //                     ],
// //                   ),
// //                 ))
// //           ],
// //         ),
// //       ));
// // }

// // Widget ChatBubble_Table(BuildContext context, List<List<TableRow>> tables,
// //     Alignment alignment, bool user) {
// //   return Align(
// //     alignment: alignment,
// //     child: Container(
// //       padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
// //       child: Column(children: [
// //         Table(
// //           children: tables[0],
// //           border: TableBorder.all(width: 2, color: Colors.black),
// //         ),
// //         const SizedBox(
// //           height: 5,
// //         ),
// //         Table(
// //           children: tables[1],
// //           border: TableBorder.all(width: 2, color: Colors.black),
// //         ),
// //         const SizedBox(
// //           height: 5,
// //         ),
// //         // Table(children: tables[2],
// //         // border: TableBorder.all(width: 2,color: Colors.black),
// //         // )h
// //       ]),
// //     ),
// //   );
// // }

// // Widget ChatBubble(
// //   BuildContext context,
// //   String? text,
// //   Alignment alignment,
// //   bool user,
// // ) {
// //   return Align(
// //       alignment: alignment,
// //       child: Container(
// //         padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
// //         constraints: const BoxConstraints(maxWidth: 200, minHeight: 40),
// //         decoration: BoxDecoration(
// //           borderRadius: BorderRadius.circular(10),
// //           color: user
// //               ? Colors.pinkAccent.withOpacity(0.3)
// //               : Colors.blueAccent.withOpacity(0.3),
// //         ),
// //         child: text == ""
// //             ? SelectableText("sorry unable to fetch",
// //                 style: const TextStyle(
// //                     fontStyle: FontStyle.italic, color: Colors.black54))
// //             : SelectableText(text!,
// //                 style: const TextStyle(
// //                     fontStyle: FontStyle.italic, color: Colors.black54)),
// //       ));
// // }

// // /////////////////






// // // import 'package:flutter/material.dart';
// // // import 'package:googleapis/cloudasset/v1.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:fluttertoast/fluttertoast.dart';
// // // import 'dart:convert';
// // // import 'response.dart';
// // // import 'sql.dart';
// // // import 'package:dart_openai/openai.dart';
// // // import 'package:googleapis_auth/auth_io.dart';
// // // import "package:googleapis/healthcare/v1.dart";

// // // void main() {
// // //   runApp(Chat());
// // // }

// // // class Chat extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       home: Chatpage(),
// // //       debugShowCheckedModeBanner: false,
// // //     );
// // //   }
// // // }

// // // class Chatpage extends StatefulWidget {
// // //   @override
// // //   State<Chatpage> createState() => _Chatpage();
// // // }

// // // class _Chatpage extends State<Chatpage> {
// // //   List<List<List<TableRow>>> responses = [];
// // //   List<String> _usertexts = [];
// // //   TextEditingController textcontroller = TextEditingController();
// // //   String c_id = "";
// // //   bool button_view = true;
// // //   late AuthClient client;

// // //   @override
// // //   initState() {
// // //     final accountCredentials = ServiceAccountCredentials.fromJson({
// // //       "private_key_id": "9b6bca11290451a17d2ba98a2cd5ecccd814b27a",
// // //       "private_key": "-----BEGIN PRIVATE KEY-----"
// // //           "\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCJQ/iu7ruAyL8i"
// // //           "\nCB9w1uh0tTPxU7xnc8kt8d7fY3bZiv9vg2Bub7JEgfGw/qW7d5p1gCrgDZ31JYa9"
// // //           "\nEZmWCYLPSJccLySPWuRwXaO40kRi5/m+hiUsSAuhvpZAzyc+JLMS8+uqXlN+88vS"
// // //           "\n8hVg4YiUrJf4cdlB6ANp/V8fvvvUrcawafodVyYQQn9k9OZv10mTPOUxV+b9sYls"
// // //           "\ntnwVEh9Nnxt8WrHg13b+o/ilbfQNmAJ/9B2BxbdU0QxxLlvs17mwpsOJ8F06aKMP"
// // //           "\nRrq/PBjj+QnrkvManTyAmtckIl+7acdTgAHQhXvrTTYGUrTpiHZaXxWuIoBNUgPE"
// // //           "\njoo5y2FZAgMBAAECggEAIJZfN/KL17Vw8OyiQDj5G1n4gKq7QAk0QgDZw0l7Cgbu"
// // //           "\ngQQc1OMWHJ8H6NfvsyugIxSgOSxqa2xzCjhfMMhFwp2uaD3F7XWr5YRJjeN3Yk7F"
// // //           "\n0wZIVXSuNEJJrA2x+JYgYFfBw2Lc6jcJVOVtj2BDu14lPxGSPUwOYW+KUYBXC4Sz"
// // //           "\n7uZDN++enyZ2o0Xnu2CebJYIRlcQ9sMv5hNu2O5myh0+/Ut1JL6pWfCjlatNoN4C"
// // //           "\nIepBdzMLfECZAD5cphcQBMnYtLEb7lbTvV66liquuXGBNWfIVK5OvqbANLm7YAjp"
// // //           "\nJn78wNznmasFHLa29TAsl9erB2VZXTs7/QtfHiiMPQKBgQC/xH1RTQQgKbKC6KY/"
// // //           "\nfxE/TY60VHve+uPE1tOD/HlfPtbhXyt1/KXQeb9D9s5wtasBaRiDnKKSnXJes4oE"
// // //           "\nSAKtQAvKt56QhgaETgIbR6f8n5Vj0AmtzIRWIcSj4WtoAc6YoSuz6NCMAztth+ef"
// // //           "\nRK3I+FfWMlABzEAfgAy17LegjQKBgQC3PhdhMxlSpys27fgY1TuBvmPb8muwLv8A"
// // //           "\nzlm3mopRD3XUNxVnDfPjwiN47ef3Z89FtgI5Zgo94azaxOVuXPqxaXAW5PCkahDL"
// // //           "\nzd44Ml+rgebpDifEFPi89P5sftNQ2+D3zvG61enel4OTsJncGkY6DudZsYeClEtj"
// // //           "\nzN2r6jIO/QKBgQCG0GLtWgBxf/7gKyBc+T6tyx9sxQwEWUrw4bn3SvIktG+qJxbN"
// // //           "\nrpz/b+e3pvXApOagajryo5ZjDk8OJpf7pIhFNgZUMDxIDADe2FyAwyJk5efHMMTt"
// // //           "\nKx9J0hmEwH+asdKE2KF5rE2YcNlBik6aWFT4OSa/DcXTTb0yp/nHl7AMLQKBgHcD"
// // //           "\nL+Ikcwz4oBukAV/3lheVVXwz/fdG/r5CR4j1KWKufOPhBtiQ+ldx7uIK+n74gGmR"
// // //           "\nZe5rtLkuSrsn6K9+WiBCD9f+x8CxVslXoz2ykepti1DQrckvqcHoCRrkYFEDDiFE"
// // //           "\n2kFzz9qPY5jXuYZ31ia9KUta/10y/agLFeojSHHtAoGAJr+iJXRzBQqusFBVNmfq"
// // //           "\nislwqAqUrUJ/z3aOfEXdtWpM3eW8csmSwsKeDd4wptPXEv4gCaUDHbwIhMDnlp+0"
// // //           "\n4SjSySUpXNNoWkfzonNETRy8pj3iw3IsXCvPebgDxNJN4YzCzPyrfQl6MCAg6Tzb\n3jDcDV5ueu1OGnjZMoIiC0w=\n-----END PRIVATE KEY-----\n",
// // //       "client_email":
// // //           "healthcare-nlp@healthcare-nlp-386522.iam.gserviceaccount.com",
// // //       "client_id": "101638777049825429937",
// // //       "type": "service_account"
// // //     });
// // //     List<String> scopes = ["https://www.googleapis.com/auth/cloud-healthcare"];
// // //     WidgetsBinding.instance.addPostFrameCallback((_) async {
// // //       client = await clientViaServiceAccount(accountCredentials, scopes);
// // //     });
// // //     super.initState();
// // //   }

// // //   // get_response1(String text){
// // //   //   OpenAI.apiKey= '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';
// // //   //   Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat.createStream(
// // //   //     model: "gpt-3.5-turbo",
// // //   //     messages: [
// // //   //       OpenAIChatCompletionChoiceMessageModel(
// // //   //         content: text,
// // //   //         role: OpenAIChatMessageRole.user,
// // //   //       )
// // //   //     ],
// // //   //   );
// // //   //   chatStream.listen((event) {
// // //   //     setState(() {
// // //   //       responses[responses.length-1]=responses[responses.length-1]!+event.choices.first.delta.content!;
// // //   //     });
// // //   //   },onDone: () => setState(() {
// // //   //     button_view=true;
// // //   //   }),onError: (e){setState((){responses[responses.length-1]="something went wrong";});});

// // //   // }

// // //   get_response2(String text) async {
// // //     // var url = Uri.https("healthcare.googleapis.com","/v1beta1/nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp:analyzeEntities");
// // //     // var url1 =Uri.parse("https://healthcare.googleapis.com/v1beta1/{nlpService=projects/healthcare-nlp-386522/locations/asia-south1/services/nlp}:analyzeEntities");
// // //     // print(url);
// // //     // print(url1);
// // //     // Map body = {
// // //     //   'documentContent':text
// // //     // };
// // //     AnalyzeEntitiesRequest request =
// // //         AnalyzeEntitiesRequest(documentContent: text);
// // //     AnalyzeEntitiesResponse res = await CloudHealthcareApi(
// // //       client,
// // //     ).projects.locations.services.nlp.analyzeEntities(request,
// // //         "projects/healthcare-nlp-386522/locations/asia-south1/services/nlp");
// // //     // var res = await client.post(url,body:body );
// // //     List<TableRow> entitymentions = [];
// // //     entitymentions.add(TableRow(children: [
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("content",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("linked entities",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text(
// // //             "Certainity Assesment",
// // //             style: TextStyle(fontWeight: FontWeight.bold),
// // //           )),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("Temporal Assesment",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("subject",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("type",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //     ]));
// // //     linkdcl(List<LinkedEntity>? le) {
// // //       List arr = [];
// // //       if (le != null) {
// // //         for (var d in le) {
// // //           arr.add(d.entityId);
// // //           return arr;
// // //         }
// // //       } else {
// // //         return "NaN";
// // //       }
// // //     }

// // //     try {
// // //       int len = 0;
// // //       if (res.entityMentions != null) {
// // //         len = res.entityMentions!.length;
// // //       }
// // //       for (int i = 0; i < len; i++) {
// // //         entitymentions.add(TableRow(children: [
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entityMentions![i].text!.content!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text("${linkdcl(res.entityMentions![i].linkedEntities)}")),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entityMentions![i].certaintyAssessment == null
// // //                   ? "NaN"
// // //                   : res.entityMentions![i].certaintyAssessment!.value!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entityMentions![i].temporalAssessment == null
// // //                   ? "NaN"
// // //                   : res.entityMentions![i].temporalAssessment!.value!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entityMentions![i].subject == null
// // //                   ? "NaN"
// // //                   : res.entityMentions![i].subject!.value!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entityMentions![i].type!))
// // //         ]));
// // //       }
// // //     } on Exception catch (e) {
// // //       print(e);
// // //     }

// // //     List<TableRow> entity = [];
// // //     entity.add(TableRow(children: [
// // //       // Container(
// // //       //     padding: const EdgeInsets.only(left: 5),
// // //       //     child: const Text(
// // //       //       "Entity Id",
// // //       //       style: TextStyle(fontWeight: FontWeight.bold),
// // //       //     )),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("Preffered Term",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //     ]));
// // //     try {
// // //       int len = 0;
// // //       if (res.entities != null) {
// // //         len = res.entities!.length;
// // //       }
// // //       for (int i = 0; i < len; i++) {
// // //         entity.add(TableRow(children: [
// // //           // Container(
// // //           //     padding: const EdgeInsets.only(left: 5),
// // //           //     child: Text(res.entities![i].entityId!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.entities![i].preferredTerm!))
// // //         ]));
// // //       }
// // //     } on Exception catch (e) {}

// // //     List<TableRow> relationships = [];
// // //     relationships.add(TableRow(children: [
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("Subject Id",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       Container(
// // //           padding: const EdgeInsets.only(left: 5),
// // //           child: const Text("Object Id",
// // //               style: TextStyle(fontWeight: FontWeight.bold))),
// // //       // Container(
// // //       //     padding: const EdgeInsets.only(left: 5),
// // //       //     child: const Text("Confidence",
// // //       //         style: TextStyle(fontWeight: FontWeight.bold)))
// // //     ]));
// // //     try {
// // //       int len = 0;
// // //       if (res.relationships != null) {
// // //         len = res.relationships!.length;
// // //       }
// // //       for (int i = 0; i < len; i++) {
// // //         relationships.add(TableRow(children: [
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.relationships![i].subjectId!)),
// // //           Container(
// // //               padding: const EdgeInsets.only(left: 5),
// // //               child: Text(res.relationships![i].objectId!)),
// // //           // Container(
// // //           //     padding: const EdgeInsets.only(left: 5),
// // //           //     child: Text("${res.relationships![i].confidence!}"))
// // //         ]));
// // //       }
// // //     } on Exception catch (e) {
// // //       print(e);
// // //     }

// // //     // for (int i=0; i<res.entities!.length;i++){
// // //     //   print("""${res.entities![i].preferredTerm}
// // //     //   ${res.entities![i].entityId}
// // //     //   ${res.entities![i].vocabularyCodes}""");
// // //     // }
// // //     // // for (int? i=0 ; i<res.relationships?.length;i++){
// // //     // //   print("""${res.relationships![i].subjectId}
// // //     // //   ${res.relationships![i].objectId}
// // //     // //   ${res.relationships![i].confidence}
// // //     // //   """);
// // //     // // }
// // //     // for (int i=0; i<res.entityMentions!.length;i++){
// // //     //   print("""${res.entityMentions![i].text!.content}
// // //     //   ${res.entityMentions![i].type}
// // //     //   """);
// // //     // }
// // //     // print("hi");
// // //     // print(res.entityMentions!.first.text!.content);
// // //     return [entity, entitymentions, relationships];
// // //   }

// // //   Widget chatscreen(BuildContext context, List<List<List<TableRow>>> responses,
// // //       List<String> _userinputs) {
// // //     return Container(
// // //         width: double.infinity,
// // //         height: MediaQuery.of(context).size.height - 83,
// // //         color: Colors.white,
// // //         child: SingleChildScrollView(
// // //           child: Column(
// // //             children: [
// // //               Container(
// // //                   padding: const EdgeInsets.symmetric(horizontal: 4),
// // //                   constraints: BoxConstraints(
// // //                       minHeight: MediaQuery.of(context).size.height - 180),
// // //                   child: Chatlist(context, responses, _userinputs)),
// // //               Inputwidget(context),
// // //             ],
// // //           ),
// // //         ));
// // //   }

// // //   Widget Chatlist(BuildContext context, List<List<List<TableRow>>> responses,
// // //       List<String> _userinputs) {
// // //     return Container(
// // //         height: MediaQuery.of(context).size.height - 180,
// // //         child: ListView.builder(
// // //             reverse: true,
// // //             itemCount: _userinputs.length,
// // //             itemBuilder: (context, i) {
// // //               return Column(
// // //                 children: [
// // //                   ChatBubble(context, _userinputs.reversed.toList()[i],
// // //                       Alignment.bottomRight, true),
// // //                   const SizedBox(
// // //                     height: 10,
// // //                   ),
// // //                   // if(responses.length<_userinputs.length) ChatBubble(context, i==0?"Waiting for response":responses.reversed.toList()[i], Alignment.bottomLeft, false),
// // //                   ChatBubble_Table(context, responses.reversed.toList()[i],
// // //                       Alignment.bottomLeft, false),
// // //                   const SizedBox(
// // //                     height: 10,
// // //                   ),
// // //                 ],
// // //               );
// // //             }));
// // //   }

// // //   Widget Inputwidget(
// // //     BuildContext context,
// // //   ) {
// // //     return Card(
// // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // //       color: Colors.white,
// // //       margin: const EdgeInsets.fromLTRB(8, 15, 8, 10),
// // //       elevation: 3,
// // //       child: Row(children: [
// // //         Container(
// // //           width: MediaQuery.of(context).size.width - 64,
// // //           child: TextFormField(
// // //             maxLines: 3,
// // //             minLines: 1,
// // //             controller: textcontroller,
// // //             decoration: InputDecoration(
// // //                 hintText: "Enter your message",
// // //                 border: OutlineInputBorder(
// // //                   borderRadius: BorderRadius.circular(10),
// // //                 )),
// // //           ),
// // //         ),
// // //         button_view
// // //             ? IconButton(
// // //                 onPressed: () async {
// // //                   String text = textcontroller.text;
// // //                   print(text);
// // //                   setState(() {
// // //                     _usertexts.add(text);
// // //                     textcontroller.text = "";
// // //                     responses.add([
// // //                       [
// // //                         const TableRow(children: [Text("waiting for response")])
// // //                       ],
// // //                       [
// // //                         const TableRow(children: [Text("waiting for response")])
// // //                       ],
// // //                       [
// // //                         const TableRow(children: [Text("waiting for response")])
// // //                       ]
// // //                     ]);
// // //                   });
// // //                   var response;
// // //                   var response1;
// // //                   if (text.toLowerCase().contains("balance")) {
// // //                     response = await connecting(
// // //                         "balance", "customer", text.substring(text.length - 5));
// // //                     if (response.length != 0) {
// // //                       response =
// // //                           "your remaining account balance is ${response}";
// // //                     } else {
// // //                       response = "error";
// // //                     }
// // //                   } else if (text.toLowerCase().contains("date")) {
// // //                     response = await connecting("opening_date", "customer",
// // //                         text.substring(text.length - 5));
// // //                     if (response.length != 0) {
// // //                       response = "your account opening date is ${response}";
// // //                     } else {
// // //                       response = "error";
// // //                     }
// // //                   } else if (text.toLowerCase().contains("transaction")) {
// // //                     response = await connecting("last_transaction_date",
// // //                         "customer", text.substring(text.length - 5));
// // //                     if (response.length != 0) {
// // //                       response = "your last transaction date is ${response}";
// // //                     } else {
// // //                       response = "error";
// // //                     }
// // //                   } else if (text.toLowerCase().contains("product")) {
// // //                     response = await connecting("crosssell", "product",
// // //                         text.substring(text.length - 5));
// // //                     if (response.length != 0) {
// // //                       response = "products available for you are ${response}";
// // //                     } else {
// // //                       response = "error";
// // //                     }
// // //                   } else {
// // //                     setState(() {
// // //                       button_view = false;
// // //                     });
// // //                     response = await get_response2(text);
// // //                   }
// // //                   if (response != "error") {
// // //                     responses.add(response);
// // //                     setState(() {
// // //                       responses.removeAt(responses.length - 2);
// // //                       button_view = true;
// // //                     });
// // //                   } else {
// // //                     Fluttertoast.showToast(
// // //                         msg: "Something went wrong",
// // //                         backgroundColor: Colors.red);
// // //                     setState(() {
// // //                       // responses.add("sorry unable to respond to you, please reach us at 9999999999");
// // //                     });
// // //                   }
// // //                 },
// // //                 icon: Icon(
// // //                   Icons.send,
// // //                   color: Colors.black.withOpacity(0.6),
// // //                 ))
// // //             : SizedBox.shrink()
// // //       ]),
// // //     );
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Builder(
// // //         builder: (context) => Scaffold(
// // //               appBar: AppBar(
// // //                 title: Text(
// // //                   "AiProff",
// // //                   style: TextStyle(color: Colors.white),
// // //                 ),
// // //                 backgroundColor: Colors.indigo[300],
// // //               ),
// // //               body: SingleChildScrollView(
// // //                 child: Column(
// // //                   children: [chatscreen(context, responses, _usertexts)],
// // //                 ),
// // //               ),
// // //             ));
// // //   }
// // // }

// // // Widget appbar(BuildContext context) {
// // //   return Card(
// // //       elevation: 6,
// // //       child: Container(
// // //         alignment: Alignment.bottomCenter,
// // //         height: 75,
// // //         width: double.infinity,
// // //         color: Colors.indigo[300],
// // //         child: Row(
// // //           children: [
// // //             // IconButton(onPressed: (){
// // //             //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
// // //             // }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
// // //             const SizedBox(
// // //               width: 20,
// // //             ),
// // //             const Text(
// // //               "AI",
// // //               style: TextStyle(
// // //                   fontSize: 20,
// // //                   fontWeight: FontWeight.bold,
// // //                   color: Colors.white),
// // //             ),
// // //             Card(
// // //                 elevation: 5,
// // //                 margin: const EdgeInsets.fromLTRB(105, 5, 10, 5),
// // //                 child: Container(
// // //                   padding: EdgeInsets.symmetric(horizontal: 10),
// // //                   decoration: BoxDecoration(
// // //                       borderRadius: BorderRadius.circular(10),
// // //                       color: Colors.white),
// // //                   child: Row(
// // //                     children: const [
// // //                       Icon(
// // //                         Icons.generating_tokens_sharp,
// // //                         color: Colors.yellow,
// // //                       ),
// // //                       SizedBox(
// // //                         width: 10,
// // //                       ),
// // //                       Text(
// // //                         "10",
// // //                         style: TextStyle(
// // //                             fontWeight: FontWeight.bold, color: Colors.black),
// // //                       ),
// // //                     ],
// // //                   ),
// // //                 ))
// // //           ],
// // //         ),
// // //       ));
// // // }

// // // Widget ChatBubble_Table(BuildContext context, List<List<TableRow>> tables,
// // //     Alignment alignment, bool user) {
// // //   return Align(
// // //     alignment: alignment,
// // //     child: Container(
// // //       padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
// // //       child: Column(children: [
// // //         Table(
// // //           children: tables[0],
// // //           border: TableBorder.all(width: 2, color: Colors.black),
// // //         ),
// // //         const SizedBox(
// // //           height: 5,
// // //         ),
// // //         Table(
// // //           children: tables[1],
// // //           border: TableBorder.all(width: 2, color: Colors.black),
// // //         ),
// // //         const SizedBox(
// // //           height: 5,
// // //         ),
// // //         Table(
// // //           children: tables[2],
// // //           border: TableBorder.all(width: 2, color: Colors.black),
// // //         )
// // //       ]),
// // //     ),
// // //   );
// // // }

// // // Widget ChatBubble(
// // //   BuildContext context,
// // //   String? text,
// // //   Alignment alignment,
// // //   bool user,
// // // ) {
// // //   return Align(
// // //       alignment: alignment,
// // //       child: Container(
// // //         padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
// // //         constraints: const BoxConstraints(maxWidth: 200, minHeight: 40),
// // //         decoration: BoxDecoration(
// // //           borderRadius: BorderRadius.circular(10),
// // //           color: user
// // //               ? Colors.pinkAccent.withOpacity(0.3)
// // //               : Colors.blueAccent.withOpacity(0.3),
// // //         ),
// // //         child: text == ""
// // //             ? SelectableText("sorry unable to fetch",
// // //                 style: const TextStyle(
// // //                     fontStyle: FontStyle.italic, color: Colors.black54))
// // //             : SelectableText(text!,
// // //                 style: const TextStyle(
// // //                     fontStyle: FontStyle.italic, color: Colors.black54)),
// // //       ));
// // // }









// // // // import 'package:flutter/material.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:fluttertoast/fluttertoast.dart';
// // // // import 'dart:convert';
// // // // import 'response.dart';
// // // // import 'sql.dart';
// // // // import 'package:dart_openai/openai.dart';

// // // // void main() {
// // // //   runApp(Chat());
// // // // }



// // // // class Chat extends StatelessWidget{
// // // //   @override
// // // //   Widget build(BuildContext context){
// // // //     return MaterialApp(
// // // //       home: Chatpage(),
// // // //     );
// // // //   }
// // // // }

// // // // class Chatpage extends StatefulWidget{
// // // //   @override
// // // //   State<Chatpage> createState() => _Chatpage();
// // // // }
// // // // class _Chatpage extends State<Chatpage>{
// // // //   List<String?> responses=["please include your userid at last of the text, it is a test version"];
// // // //   List<String> _usertexts=["hi"];
// // // //   TextEditingController textcontroller=TextEditingController();
// // // //   String c_id="";
// // // //   bool button_view=true;

// // // //   get_response1(String text){
// // // //     OpenAI.apiKey= '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';
// // // //     Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat.createStream(
// // // //       model: "gpt-3.5-turbo",
// // // //       messages: [
// // // //         OpenAIChatCompletionChoiceMessageModel(
// // // //           content: text,
// // // //           role: OpenAIChatMessageRole.user,
// // // //         )
// // // //       ],
// // // //     );
// // // //     chatStream.listen((event) {
// // // //       setState(() {
// // // //         responses[responses.length-1]=responses[responses.length-1]!+event.choices.first.delta.content!;
// // // //       });
// // // //     },onDone: () => setState(() {
// // // //       button_view=true;
// // // //     }),onError: (e){setState((){responses[responses.length-1]="something went wrong";});});

// // // //   }
// // // //   Widget chatscreen(BuildContext context,List<String?> responses , List<String> _userinputs){
// // // //     return Container(width: double.infinity,height: MediaQuery.of(context).size.height-83, color: Colors.white,
// // // //         child:SingleChildScrollView(child:Column(
// // // //           children: [
// // // //             Container(
// // // //                 padding:const EdgeInsets.symmetric(horizontal: 4),constraints: BoxConstraints(
// // // //                 minHeight: MediaQuery.of(context).size.height-180
// // // //             ),child:Chatlist(context, responses, _userinputs)),
// // // //             Inputwidget(context),
// // // //           ],
// // // //         ),
// // // //         )
// // // //     );
// // // //   }

// // // //   Widget Chatlist(BuildContext context,List<String?> responses , List<String> _userinputs){

// // // //     return Container(
// // // //         height: MediaQuery.of(context).size.height-180,
// // // //         child:ListView.builder(
// // // //             reverse: true,
// // // //             itemCount: _userinputs.length,
// // // //             itemBuilder:(context,i){
// // // //               return
// // // //                 Column(
// // // //                   children: [
// // // //                     ChatBubble(context,_userinputs.reversed.toList()[i] , Alignment.bottomRight, true),
// // // //                     const SizedBox(height: 10,),
// // // //                     // if(responses.length<_userinputs.length) ChatBubble(context, i==0?"Waiting for response":responses.reversed.toList()[i], Alignment.bottomLeft, false),
// // // //                     ChatBubble(context, responses.reversed.toList()[i], Alignment.bottomLeft, false),
// // // //                     const SizedBox(height: 10,),
// // // //                   ],
// // // //                 );
// // // //             })
// // // //     );
// // // //   }

// // // //   Widget Inputwidget(BuildContext context,){
// // // //     return Card(
// // // //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// // // //       color: Colors.white,
// // // //       margin: const EdgeInsets.fromLTRB(8, 15, 8, 10),
// // // //       elevation: 3,
// // // //       child:Row(
// // // //           children:[
// // // //             Container(width:MediaQuery.of(context).size.width-64,child:TextFormField(
// // // //               maxLines: 3,
// // // //               minLines: 1,
// // // //               controller: textcontroller,
// // // //               decoration:  InputDecoration(
// // // //                   hintText: "Enter your message",
// // // //                   border: OutlineInputBorder(borderRadius:  BorderRadius.circular(10),)
// // // //               ),
// // // //             ),),
// // // //             button_view?IconButton(onPressed:() async{
// // // //               String text=textcontroller.text;
// // // //               print(text);
// // // //               setState(() {
// // // //                 _usertexts.add(text);
// // // //                 textcontroller.text="";
// // // //                 responses.add("waiting for response from the server");
// // // //               });
// // // //               var response;
// // // //               var response1;
// // // //               if (text.toLowerCase().contains("balance")){
// // // //                response= await connecting("balance", "customer", text.substring(text.length-5));
// // // //                if (response.length!=0){
// // // //                response = "your remaining account balance is ${response}";}
// // // //                else{
// // // //                  response="error";
// // // //                }
// // // //               }
// // // //               else if (text.toLowerCase().contains("date")){
// // // //                 response= await connecting("opening_date", "customer", text.substring(text.length-5));
// // // //                 if (response.length!=0){
// // // //                 response="your account opening date is ${response}";}
// // // //                 else{
// // // //                   response="error";
// // // //                 }
// // // //               }
// // // //               else if (text.toLowerCase().contains("transaction")){
// // // //                 response= await connecting("last_transaction_date", "customer", text.substring(text.length-5));
// // // //                 if (response.length!=0){
// // // //                 response="your last transaction date is ${response}";}
// // // //                 else{
// // // //                   response="error";
// // // //                 }
// // // //               }
// // // //               else if (text.toLowerCase().contains("product")){
// // // //                 response = await connecting("crosssell", "product", text.substring(text.length-5) );
// // // //                 if (response.length!=0){
// // // //                 response="products available for you are ${response}";}
// // // //                 else{
// // // //                   response="error";
// // // //                 }
// // // //               }
// // // //               else{
// // // //               setState(() {
// // // //                 button_view=false;
// // // //               });
// // // //               get_response1(text);
// // // //               response=" ";
// // // //               }
// // // //               if(response!="error"){
// // // //                 responses.add(response);
// // // //                 setState(() {
// // // //                   responses.remove("waiting for response from the server");

// // // //                 });


// // // //               }
// // // //               else{
// // // //                 setState(() {
// // // //                   responses.add("sorry unable to respond to you, please reach us at 9999999999");
// // // //                 });

// // // //               }
// // // //             }, icon: Icon(Icons.send,color: Colors.black.withOpacity(0.6),)):SizedBox.shrink()
// // // //           ]
// // // //       ),
// // // //     );
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context){
// // // //     return Builder(builder: (context)=>

// // // //         Scaffold(
// // // //           appBar: AppBar(title: Text("Chatbot",style: TextStyle(color: Colors.white),),
// // // //           backgroundColor: Colors.indigo[300],),
// // // //           body:SingleChildScrollView(child: Column(
// // // //             children: [
// // // //               chatscreen(context, responses, _usertexts)
// // // //             ],
// // // //           ),
// // // //           ),
// // // //         ));
// // // //   }
// // // // }

// // // // Widget appbar(BuildContext context) {
// // // //   return Card(elevation:6,child:Container(
// // // //     alignment: Alignment.bottomCenter,
// // // //     height: 75,width: double.infinity,
// // // //     color: Colors.indigo[300],
// // // //     child: Row(
// // // //       children: [
// // // //         // IconButton(onPressed: (){
// // // //         //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
// // // //         // }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
// // // //         const SizedBox(width: 20,),
// // // //         const Text("AI",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
// // // //         Card(elevation: 5,margin: const EdgeInsets.fromLTRB(105, 5, 10, 5),
// // // //             child:Container(
// // // //               padding: EdgeInsets.symmetric(horizontal: 10),
// // // //               decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white),
// // // //               child: Row(children: const [
// // // //                 Icon(Icons.generating_tokens_sharp,color: Colors.yellow,),
// // // //                 SizedBox(width: 10,),
// // // //                 Text("10",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
// // // //               ],),
// // // //             ))
// // // //       ],
// // // //     ) ,
// // // //   ));
// // // // }





// // // // Widget ChatBubble(BuildContext context,String? text,Alignment alignment,bool user,){
// // // //   return Align( alignment:alignment,
// // // //       child:Container(
// // // //         padding: const EdgeInsets.fromLTRB(4, 3, 4, 5),
// // // //         constraints: const BoxConstraints(maxWidth: 200,minHeight:40),
// // // //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
// // // //           color: user?Colors.pinkAccent.withOpacity(0.3):Colors.blueAccent.withOpacity(0.3),),
// // // //         child: text==""?SelectableText("sorry unable to fetch",style: const TextStyle(fontStyle: FontStyle.italic,color: Colors.black54)):
// // // //         SelectableText(text!,style: const TextStyle(fontStyle: FontStyle.italic,color: Colors.black54))
// // // //         ,
// // // //       )
// // // //   );

// // // // }