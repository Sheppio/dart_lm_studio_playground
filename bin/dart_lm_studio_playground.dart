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

//--------------------------------------------------

  // Response<ResponseBody> rs = await dio.post<ResponseBody>('http://192.168.1.132:1234/v1/chat/completions',
  //     options: Options(responseType: ResponseType.stream),
  //     data: {
  //       //"model": "TheBloke/Mistral-7B-Instruct-v0.2-GGUF/mistral-7b-instruct-v0.2.Q6_K.gguf",
  //       "seed": DateTime.now().microsecondsSinceEpoch,

  //       "messages": [
  //         {"role": "system", "content": "You are an Fitness coach"},
  //         {
  //           "role": "user",
  //           "content":
  //               "Give me only one single line, original, short, fitness related, motivational quote. Do not include an explanation. Do not include who said it.  Do not include a hashtag."
  //         }
  //       ],
  //       "temperature": 0.7,
  //       "max_tokens": -1,
  //       "stream": true
  //     });

  // StreamTransformer<Uint8List, List<int>> unit8Transformer = StreamTransformer.fromHandlers(
  //   handleData: (data, sink) {
  //     sink.add(List<int>.from(data));
  //   },
  // );

  // var contentSoFar = '';

  // rs.data?.stream
  //     .transform(unit8Transformer)
  //     .transform(const Utf8Decoder())
  //     .transform(const LineSplitter())
  //     .listen((event) {
  //   print(event);
  //   if (event.length > 6) {
  //     //print("*${event.substring(6, 7)}*");
  //     if (event.substring(6, 7) == '{') {
  //       Map<String, dynamic> j = json.decode(event.substring(6));
  //       //print(j);
  //       //print(j['choices'][0]['delta']['content']);

  //       if (j['choices'][0]['delta']['content'] != null) {
  //         contentSoFar = contentSoFar + j['choices'][0]['delta']['content'];
  //       }
  //       print(contentSoFar);
  //     }
  //   }
  // });

//--------------------------------------------------

  var sysInst = '''
You are a helpful assistant with access to the following functions. Use them if required and ensure response is valid JSON. - 

Do not assume any information.  If you don't fully understand and cant match the request to a function, respond with {"error": "No function found"}

{
    "function_name": "order_pizza",
    "description": "Order a pizza with custom toppings",
    "parameters": {
        "type": "object",
        "properties": {
            "size": {
                "type": "string",
                "description": "Size of the pizza (small, medium, large)"
            },
            "toppings": {
                "type": "array",
                "items": {
                    "type": "string"
                },
                "description": "List of toppings for the pizza"
            }
        },
        "required": [
            "size",
            "toppings"
        ]
    }
}

{
    "function_name": "shopping_list_update",
    "description": "Adds and removes items from a shopping list",
"properties": {
    "actions": {
      "type": "array",
      "items": [
        {
          "type": "object",
          "properties": {
            "item": {
              "type": "string",
                "description": "item to be added or removed from the shopping list"
            },
            "state": {
              "type": "boolean",
                "description": "false if the item should be removed and true if it should be turned added"
            }
          },
          "required": [
            "item",
            "state"
          ]
        }
      ]
    }
  },
  "required": [
    "actions"
  ]
    }
}

{
    "function_name": "light_switch",
    "description": "Turns lights on or off in a specified room",
"properties": {
    "actions": {
      "type": "array",
      "items": [
        {
          "type": "object",
          "properties": {
            "room": {
              "type": "string",
                "description": "The room name where the lights are located"
            },
            "state": {
              "type": "boolean",
                "description": "false if the lights should be turned off, true if they should be turned on"
            }
          },
          "required": [
            "room",
            "state"
          ]
        }
      ]
    }
  },
  "required": [
    "actions"
  ]
    }
}


{
    "function_name": "order_taxi",
    "description": "Order a taxi to a destination",
    "parameters": {
        "type": "object",
        "properties": {
            "destination": {
                "type": "string",
                "description": "Destination of the taxi"
            }
        },
        "required": [
            "destination"
        ]
    }
}

''';

  var response = await dio.post('http://192.168.1.132:1234/v1/chat/completions', data: {
    "model": "TheBloke/Mistral-7B-Instruct-v0.2-GGUF/mistral-7b-instruct-v0.2.Q6_K.gguf",
    "responseFormat": "json",
    "messages": [
      {"role": "system", "content": sysInst},
      //{"role": "user", "content": "I'd like a large pizza with anchovies and pepperoni"}
      //{"role": "user", "content": "I'd like to go to Reading town centre."}
      //{"role": "user", "content": "Give me a recipe for a taco"}
      //{"role": "user", "content": "Turn the lights on in the kitchen and off in the bathroom"}
      //{"role": "user", "content": "Bedroom lights on."}
      //{"role": "user", "content": "Bedroom lights on and order me a taxi to London."}
      //{"role": "user", "content": "Bedroom lights on and order me a taxi to London along with a chicken  small pizza."}
      //{"role": "user", "content": "Bedroom lights on turn the radio off"} //this fails
      //{"role": "user", "content": "Turn the radio off"} // this tries to turn the lights off
      {
        "role": "user",
        "content": "Add peas, beetroot and chicken to my shopping list, but remove beef and pork."
      } // this tries to turn the lights off
    ],
    "temperature": 0.5,
    "max_tokens": -1,
    "stream": false
  });
  print(response.data.toString());
}
