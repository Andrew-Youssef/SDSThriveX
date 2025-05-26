import 'package:flutter/material.dart';
import 'package:thrivex/providers/user_provider.dart';

class MyAiSummaryWidget extends StatefulWidget {
  final UserProvider userProvider;

  const MyAiSummaryWidget({super.key, required this.userProvider});

  @override
  State<MyAiSummaryWidget> createState() => _MyAiSummaryWidgetState();
}

class _MyAiSummaryWidgetState extends State<MyAiSummaryWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  bool _hadLoadedProfile = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      if (!_hadLoadedProfile) {
        _hadLoadedProfile = true;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await widget.userProvider.generateSummary();
          setState(() {
            _isLoading = false;
          });
        });
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    if (_isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary',
            textAlign: TextAlign.left,
            style: theme.textTheme.titleMedium,
          ),
          Center(child: CircularProgressIndicator()),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Summary',
            textAlign: TextAlign.left,
            style: theme.textTheme.titleMedium,
          ),
          Text(widget.userProvider.aiSummary!),
        ],
      );
    }
  }
}
