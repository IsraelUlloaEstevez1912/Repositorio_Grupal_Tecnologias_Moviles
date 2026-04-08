class AppRoutes {
  static const home = '/home';
  static const schedule = '/schedule';
  static const center = '/center';
  static const alerts = '/alerts';
  static const profile = '/profile';
}

class AppRouteArgs {
  const AppRouteArgs({this.userRole = 'estudiante'});

  final String userRole;
}
