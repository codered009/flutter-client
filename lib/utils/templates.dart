import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/invoice_model.dart';
import 'package:invoiceninja_flutter/data/web_client.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

import 'dialogs.dart';

void loadTemplate({
  BuildContext context,
  String subject,
  String body,
  Function(String, String) onComplete,
}) {
  final webClient = WebClient();
  final state = StoreProvider.of<AppState>(context).state;
  final credentials = state.credentials;
  final invoice =
      state.invoiceState.map[state.invoiceState.list.first] ?? InvoiceEntity();
  final url = credentials.url + '/templates/invoice/${invoice.id}';
  const encoder = const Utf8Encoder();

  webClient
      .post(url, credentials.token,
          data: json.encode({'subject': subject, 'body': body}))
      .then((dynamic response) {
    print('### response');
    print(response);
    /*
    final String contentBase64 =
        base64Encode(encoder.convert(response));
    print(response);
    onSuccess(contentBase64);
     */
  }).catchError((dynamic error) {
    showErrorDialog(context: context, message: '$error');
    final hase64Body = base64Encode(encoder.convert(body));
    onComplete(subject, 'data:text/html;base64,$hase64Body');
  });
}
