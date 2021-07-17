import 'package:flutter/cupertino.dart';
import 'package:places/src/core/base_view_model.dart';
import 'package:provider/provider.dart';


class BaseWidget<T extends BaseViewModel> extends StatefulWidget {

  const BaseWidget({Key? key, required this.model, required this.builder, this.onModelReady}) : super(key: key);
  final T model;
  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T model)? onModelReady;

  @override
  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends BaseViewModel> extends State<BaseWidget<T>> {

 // late T model;   // late initialization

  @override
  void initState() {   //will call before build method
    super.initState();
  //  model = widget.model;
    if(widget.onModelReady!=null){
      widget.onModelReady!(widget.model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.model,
        child: Consumer<T>(
          builder: widget.builder,
        )
    );
  }
}
