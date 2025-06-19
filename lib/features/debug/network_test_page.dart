import 'package:blocpatternflutter/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

class NetworkTestPage extends StatefulWidget {
  const NetworkTestPage({super.key});

  @override
  State<NetworkTestPage> createState() => _NetworkTestPageState();
}

class _NetworkTestPageState extends State<NetworkTestPage> {
  String _testResults = 'Tap "Test Network" to start';
  bool _isLoading = false;

  Future<void> _testNetwork() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Testing network connectivity...\n';
    });

    final dio = Dio();

    // Test 1: Basic Internet
    try {
      setState(() {
        _testResults += '\n1. Testing basic internet connectivity...';
      });

      final response = await dio.get('https://httpbin.org/get');
      if (response.statusCode == 200) {
        setState(() {
          _testResults += '\n✅ Basic internet: OK';
        });
      }
    } catch (e) {
      setState(() {
        _testResults += '\n❌ Basic internet failed: $e';
      });
    }

    // Test 2: Google (reliable)
    try {
      setState(() {
        _testResults += '\n\n2. Testing Google connectivity...';
      });

      final response = await dio.get('https://www.google.com');
      if (response.statusCode == 200) {
        setState(() {
          _testResults += '\n✅ Google: OK';
        });
      }
    } catch (e) {
      setState(() {
        _testResults += '\n❌ Google failed: $e';
      });
    }

    // Test 3: Business Class Profile domain
    try {
      setState(() {
        _testResults += '\n\n3. Testing businessclassprofile.com...';
      });

      final response = await dio.get('https://businessclassprofile.com');
      if (response.statusCode == 200) {
        setState(() {
          _testResults += '\n✅ businessclassprofile.com: OK';
        });
      }
    } catch (e) {
      setState(() {
        _testResults += '\n❌ businessclassprofile.com failed: $e';
      });
    }

    // Test 4: API endpoint
    try {
      setState(() {
        _testResults += '\n\n4. Testing API endpoint...';
      });

      final response = await dio.get('https://businessclassprofile.com/api/');
      setState(() {
        _testResults += '\n✅ API endpoint accessible: ${response.statusCode}';
      });
    } catch (e) {
      setState(() {
        _testResults += '\n❌ API endpoint failed: $e';
      });
    }

    setState(() {
      _isLoading = false;
      _testResults += '\n\n--- Test Complete ---';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.go(AppRoutes.signIn),
        ),
        title: const Text('Network Test'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _testNetwork,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test Network'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _testResults,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
