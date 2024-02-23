import 'package:flutter/material.dart';
import 'package:parichay/colors/pallete.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class Transport extends StatefulWidget {
  const Transport({super.key});

  @override
  State<Transport> createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  final List<TransportOption> transportOptions = [
    TransportOption(
      title: 'Flight',
      url: 'https://www.skyscanner.co.in',
      icon: Icons.airplanemode_active,
    ),
    TransportOption(
      title: 'Train',
      url: 'https://www.irctc.co.in/nget/train-search',
      icon: Icons.train,
    ),
    TransportOption(
      title: 'Cab',
      url: 'https://www.uber.com/in/en',
      icon: Icons.local_taxi,
    ),
    TransportOption(
      title: 'Bus',
      url: 'https://www.redbus.in',
      icon: Icons.directions_bus,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transport"),
        backgroundColor: Pallete.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
          ),
          itemCount: transportOptions.length,
          itemBuilder: (context, index) {
            return TransportTile(
              title: transportOptions[index].title,
              url: transportOptions[index].url,
              icon: transportOptions[index].icon,
            );
          },
        ),
      ),
    );
  }
}

class TransportOption {
  final String title;
  final String url;
  final IconData icon;

  TransportOption({
    required this.title,
    required this.url,
    required this.icon,
  });
}

class TransportTile extends StatelessWidget {
  final String title;
  final String url;
  final IconData icon;

  TransportTile({
    required this.title,
    required this.url,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // print("This is transport ${url}");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(title: title, url: url),
          ),
        );
      },
      child: Card(
        color: Pallete.primaryCard,
        margin: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // alignment: Alignment.center,
            children: [
              Icon(icon, size: 50.0),
              Positioned(
                bottom: 10.0, // Adjust the position as needed
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({required this.url, required this.title});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse(widget.url));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(body: WebViewWidget(controller: controller)));
  }
}
