library http_task;

import 'dart:html';

import 'package:task/task.dart';

/// A [Task] representing a lazy Http Request.
class HttpTask extends Task<HttpRequest> {
  final String url;
  final String method;
  final bool withCredentials;
  final String responseType;
  final String mimeType;
  final Map<String, String> requestHeaders;
  final Object sendData;

  HttpTask(
    this.url,
    this.method, {
    this.withCredentials,
    this.responseType,
    this.mimeType,
    this.requestHeaders,
    this.sendData,
  });

  /// Performs the HTTP request, calling [onResult] when it finishes or
  /// [onError] if it fails with the resulting [HttpRequest].
  ///
  /// Calling this multiple times will create new HTTP requests.
  /// Returns an [Operation] which can be canceled if the request hasn't
  /// already completed.
  @override
  Operation run(void Function(HttpRequest) onResult,
      [void Function(Object) onError]) {
    var xhr = new HttpRequest();
    xhr.open(method ?? 'GET', url, async: true);

    if (withCredentials != null) {
      xhr.withCredentials = withCredentials;
    }

    if (responseType != null) {
      xhr.responseType = responseType;
    }

    if (mimeType != null) {
      xhr.overrideMimeType(mimeType);
    }

    if (requestHeaders != null) {
      requestHeaders.forEach((header, value) {
        xhr.setRequestHeader(header, value);
      });
    }

    xhr.onLoad.listen((e) {
      var accepted = xhr.status >= 200 && xhr.status < 300;
      var fileUri = xhr.status == 0; // file:// URIs have status of 0.
      var notModified = xhr.status == 304;
      var unknownRedirect = xhr.status > 307 && xhr.status < 400;

      if (accepted || fileUri || notModified || unknownRedirect) {
        onResult(xhr);
      } else {
        onError(xhr);
      }
    });

    xhr.onError.listen(onError);

    if (sendData != null) {
      xhr.send(sendData);
    } else {
      xhr.send();
    }

    return new _HttpOperation(xhr);
  }
}

class _HttpOperation extends Operation {
  HttpRequest _request;

  _HttpOperation(this._request);

  void cancel() {
    if (_request != null) {
      _request.abort();
      _request = null;
    }
  }
}
