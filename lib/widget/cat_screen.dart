import 'package:catinder/model/cat.dart';
import 'package:catinder/state/tinder_notifier.dart';
import 'package:catinder/widget/cat_widget.dart';
import 'package:flutter/material.dart';

class CatScreen extends StatefulWidget {
  final Cat cat;

  const CatScreen({required this.cat, super.key});

  @override
  State<StatefulWidget> createState() => CatScreenState();
}

class CatScreenState extends State<CatScreen> {
  late Cat cat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    cat = widget.cat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          CatWidget(height: 350, cat: cat),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _CatDescription(cat: cat),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatDescription extends StatelessWidget {
  final Cat cat;

  const _CatDescription({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
      child: Text(
        cat.description,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
      ),
    );
  }
}
