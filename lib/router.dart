import 'package:chit/layout/scafold_home.dart';
import 'package:chit/modules/chit/views/add_user.dart';
import 'package:chit/modules/chit/views/chit_user_list_view.dart';
import 'package:chit/modules/home/home.dart';
import 'package:chit/modules/profile/profile.dart';
import 'package:chit/modules/transaction/views/add_transaction.dart';
import 'package:chit/modules/transaction/views/transaction_list_view.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: <RouteBase>[
    // #docregion configuration-builder
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        // Return the widget that implements the custom shell (in this case
        // using a BottomNavigationBar). The StatefulNavigationShell is passed
        // to be able access the state of the shell and to navigate to other
        // branches in a stateful way.
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      // #enddocregion configuration-builder
      // #docregion configuration-branches
      branches: <StatefulShellBranch>[
        // The route branch for the first tab of the bottom navigation bar.
        StatefulShellBranch(
          navigatorKey: _sectionANavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the first tab of the
              // bottom navigation bar.
              path: '/home',
              builder:
                  (BuildContext context, GoRouterState state) => const Home(),
            ),
          ],
          // To enable preloading of the initial locations of branches, pass
          // 'true' for the parameter `preload` (false is default).
        ),
        // #enddocregion configuration-branches

        // The route branch for the second tab of the bottom navigation bar.
        StatefulShellBranch(
          // It's not necessary to provide a navigatorKey if it isn't also
          // needed elsewhere. If not provided, a default key will be used.
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the second tab of the
              // bottom navigation bar.
              path: '/user',
              builder:
                  (BuildContext context, GoRouterState state) => ChitListPage(),
              routes: <RouteBase>[
                GoRoute(
                  path: '/add',
                  builder:
                      (BuildContext context, GoRouterState state) =>
                          AddUserPage(),
                ),
                GoRoute(
                  name: 'transactions',
                  path: '/transactions/:chitId',
                  builder: (context, state) {
                    final chitId =
                        int.tryParse(state.pathParameters['chitId']!) ?? 0;
                    return TransactionListPage(chitId: chitId);
                  },
                ),
                GoRoute(
                  name: 'addTransaction',
                  path: '/transactions/:chitId/add',
                  builder: (context, state) {
                    final chitId =
                        int.tryParse(state.pathParameters['chitId']!) ?? 0;
                    return AddTransaction(chitId: chitId);
                  },
                ),
                GoRoute(
                  path: '/404',
                  builder:
                      (context, state) => const Scaffold(
                        body: Center(child: Text("Page Not Found")),
                      ),
                ),
              ],
            ),
          ],
        ),

        // The route branch for the third tab of the bottom navigation bar.
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              // The screen to display as the root in the third tab of the
              // bottom navigation bar.
              path: '/profile',
              builder:
                  (BuildContext context, GoRouterState state) =>
                      const Profile(),
            ),
          ],
        ),
      ],
    ),
  ],
);
