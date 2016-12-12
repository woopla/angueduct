part of quiz;

class StaticFilesController extends HTTPController {
  final String basePath;
  final String defaultFile;

  StaticFilesController({this.basePath: "build/web", this.defaultFile: "index.html"});

  // Initially based on https://github.com/stablekernel/aqueduct/issues/157
  @httpGet getFile() async {
    String realPath = request.path.remainingPath;
    if (realPath.length == 0) {
      realPath = defaultFile;
    }
    String filePath = path.join(basePath, realPath);
    io.File file = new io.File(filePath);
    var fileContents = file.readAsStringSync();

    String contentType = mime.lookupMimeType(filePath);

    return new Response.ok(fileContents)
      ..contentType = io.ContentType.parse(contentType);
  }
}
