import 'package:flutter/material.dart';
import 'constants.dart' as constants;
import 'form_route.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(constants.appTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(
                  Icons.delete_sweep,
                  size: 50,
                ),
                Text(
                  constants.mainHeader,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 45
                  ),
                ),
              ],
            ),
            const Text(
              constants.mainSubHeader,
            ),
            const SizedBox(height: 40),
            const Text('This is some information about what this is and how it works...'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormRoute())
          );
        },
        label: const Text("Report It Now!"),
        tooltip: 'Report fly tipping',
        icon: const Icon(Icons.delete_sweep),
        backgroundColor: Colors.pink,
        // child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
