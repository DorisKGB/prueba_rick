enum Pages { home }

extension PagesExtension on Pages {
  String getPath() {
    return switch (this) {
      Pages.home => '/home',
    };
  }
}
