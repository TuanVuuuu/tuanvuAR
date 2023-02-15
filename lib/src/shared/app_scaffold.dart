// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api
part of '../../../libary/one_libary.dart';

// ignore: must_be_immutable
class AppScaffold extends StatefulWidget {
  AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
    this.drawer,
    this.onDrawerChanged,
    this.endDrawer,
    this.onEndDrawerChanged,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.drawerScrimColor,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.restorationId,
  })  : assert(primary != null),
        assert(extendBody != null),
        assert(extendBodyBehindAppBar != null),
        assert(drawerDragStartBehavior != null);

  var floatingActionButton;

  var appBar;

  var body;

  var floatingActionButtonLocation;

  var floatingActionButtonAnimator;

  var persistentFooterButtons;

  var persistentFooterAlignment;

  var drawer;

  var onDrawerChanged;

  var endDrawer;

  var onEndDrawerChanged;

  var bottomNavigationBar;

  var bottomSheet;

  var backgroundColor;

  var resizeToAvoidBottomInset;

  var primary;

  var drawerDragStartBehavior;

  var extendBody;

  var extendBodyBehindAppBar;

  var drawerScrimColor;

  var drawerEdgeDragWidth;

  var drawerEnableOpenDragGesture;

  var endDrawerEnableOpenDragGesture;

  var restorationId;

  @override
  _AppScaffoldState createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: DefaultTextStyle(
          style: OneTheme.of(context).body2,
          child: Scaffold(
            key: widget.key,
            appBar: widget.appBar,
            body: widget.body,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
            persistentFooterButtons: widget.persistentFooterButtons,
            persistentFooterAlignment: widget.persistentFooterAlignment,
            drawer: widget.drawer,
            onDrawerChanged: widget.onDrawerChanged,
            endDrawer: widget.endDrawer,
            onEndDrawerChanged: widget.onEndDrawerChanged,
            bottomNavigationBar: widget.bottomNavigationBar,
            bottomSheet: widget.bottomSheet,
            backgroundColor: widget.backgroundColor,
            resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
            primary: widget.primary,
            drawerDragStartBehavior: widget.drawerDragStartBehavior,
            extendBody: widget.extendBody,
            extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
            drawerScrimColor: widget.drawerScrimColor,
            drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
            drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
            endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
            restorationId: widget.restorationId,
          )),
    );
  }
}
