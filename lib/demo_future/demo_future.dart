void main() {
  testFuture.then((value) {
    print("then with $value");
  }).catchError((err) {
    print(err);
  }).whenComplete(() => print("end here!"));

  print("main");
}

Future<String> testFuture = Future(() {
  print('Chay vao day');
  return "1";
});
