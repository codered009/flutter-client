import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/buttons/elevated_button.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class DocumentTile extends StatelessWidget {
  const DocumentTile(this.document);

  final DocumentEntity document;

  void showDocumentModal(BuildContext context) {
    showDialog<Column>(
        context: context,
        builder: (BuildContext context) {
          final localization = AppLocalization.of(context);

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context)
                  .viewInsets
                  .bottom, // stay clear of the keyboard
            ),
            child: SingleChildScrollView(
              child: FormCard(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        color: Colors.red,
                        icon: Icons.delete,
                        label: localization.delete,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        icon: Icons.check_circle,
                        label: localization.done,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DocumentPreview(document),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        InkWell(
          onTap: () => showDocumentModal(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, top: 16, right: 16, bottom: 28),
                  child: Text(document.name ?? '',
                      style: Theme.of(context).textTheme.subhead),
                ),
                DocumentPreview(document),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class DocumentPreview extends StatelessWidget {
  const DocumentPreview(this.document);

  final DocumentEntity document;

  @override
  Widget build(BuildContext context) {
    final state = StoreProvider.of<AppState>(context).state;
    return document.preview != null && document.preview.isNotEmpty
        ? CachedNetworkImage(
            key: ValueKey(document.preview),
            imageUrl: document.previewUrl(state.authState.url),
            httpHeaders: {'X-Ninja-Token': state.selectedCompany.token},
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Text(
                  '$error: $url',
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                ))
        : Icon(Icons.insert_drive_file);
  }
}
