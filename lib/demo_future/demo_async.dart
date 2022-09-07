void main() async {
  try {
    String res = await testFuture;
    print("run value with $res");
  } catch (err) {
    print(err);
  } finally {
    print('end here');
  }
}

Future<String> testFuture = Future(() {
  print('Chay vao day');
  return "1";
});
