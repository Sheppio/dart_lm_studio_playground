//import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

void main(List<String> arguments) async {
  print('Running...');
  final dio = Dio();
  // var response = await dio.post('http://192.168.1.132:1234/v1/chat/completions', data: {
  //   "model": "TheBloke/Mistral-7B-Instruct-v0.2-GGUF/mistral-7b-instruct-v0.2.Q6_K.gguf",
  //   "messages": [
  //     {"role": "system", "content": "You are an fitness coach"},
  //     {"role": "user", "content": "Give me 3 short, fitness related, motivational quotes in a number list format."}
  //   ],
  //   "temperature": 0.7,
  //   "max_tokens": -1,
  //   "stream": false
  // });
  // print(response.data.toString());
  Response<ResponseBody> rs = await dio.post<ResponseBody>('http://192.168.1.132:1234/v1/chat/completions',
      options: Options(responseType: ResponseType.stream),
      data: {
        "model": "TheBloke/Mistral-7B-Instruct-v0.2-GGUF/mistral-7b-instruct-v0.2.Q6_K.gguf",
        "seed": DateTime.now().microsecondsSinceEpoch,
        "messages": [
          {"role": "system", "content": "You are an Fitness coach"},
          {
            "role": "user",
            "content":
                "Give me only one single line, original, short, fitness related, motivational quote. Do not include an explanation. Do not include who said it.  Do not include a hashtag."
          }
        ],
        "temperature": 0.7,
        "max_tokens": -1,
        "stream": true
      });

  StreamTransformer<Uint8List, List<int>> unit8Transformer = StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      sink.add(List<int>.from(data));
    },
  );

  var contentSoFar = '';

  rs.data?.stream
      .transform(unit8Transformer)
      .transform(const Utf8Decoder())
      .transform(const LineSplitter())
      .listen((event) {
    print(event);
    if (event.length > 6) {
      //print("*${event.substring(6, 7)}*");
      if (event.substring(6, 7) == '{') {
        Map<String, dynamic> j = json.decode(event.substring(6));
        //print(j);
        //print(j['choices'][0]['delta']['content']);

        if (j['choices'][0]['delta']['content'] != null) {
          contentSoFar = contentSoFar + j['choices'][0]['delta']['content'];
        }
        print(contentSoFar);
      }
    }
  });
}
