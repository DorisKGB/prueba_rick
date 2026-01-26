class EPage<T> {
int? count;
int? pages;
String? next;
String? prev;
List<T>? results;

    EPage({
      required this.count,
      required this.pages,
      required this.next,
      required this.prev,
      required this.results,
    });
}