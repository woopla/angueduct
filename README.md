# Angueduct
Simple example for a full stack Dart application, using the [Aqueduct]("https://aqueduct.io/") framework on the back-end and [Angular]("https://webdev.dartlang.org/angular/guide") on the front-end.

In order to minimize the number or running services, a specific Aqueduct `HTTPController` class handles static files, and sends the Angular application to the browser.

# How to run

First, get it all ready and running:
```shell
> pub get
> pub build
> dart bin/start.dart
```

Then point your browser to [http://localhost:8080](http://localhost:8080).