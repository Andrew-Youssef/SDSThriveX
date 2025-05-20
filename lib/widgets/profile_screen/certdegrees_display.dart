import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screens/core/models/cert_degree_model.dart';
import 'package:screens/features/profile/profile_edit/edit_profile_attributes/edit_individual/edit_cert_degree.dart';
import 'package:screens/providers/user_provider.dart';

class MyExistingCertDegreesWidget extends StatefulWidget {
  final String selectedUserId;

  const MyExistingCertDegreesWidget({super.key, required this.selectedUserId});

  @override
  State<MyExistingCertDegreesWidget> createState() =>
      MyExistingCertDegreesWidgetState();
}

class MyExistingCertDegreesWidgetState
    extends State<MyExistingCertDegreesWidget> {
  CertDegreesModel? selectedCertDegree;
  UserProvider? selectedUserProvider;
  bool _hadLoadedProfile = false;
  bool _isLoggedInUser = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      if (!_hadLoadedProfile) {
        _hadLoadedProfile = true;

        UserProvider userProvider = Provider.of<UserProvider>(context);
        if (widget.selectedUserId == userProvider.userId) {
          selectedUserProvider = userProvider;
          _isLoggedInUser = true;
          _isLoading = false;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            selectedUserProvider = UserProvider();
            await selectedUserProvider!.setTemporaryProfile(
              widget.selectedUserId,
            );
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    ThemeData theme = Theme.of(context);
    List<CertDegreesModel> certDegrees = selectedUserProvider!.certDegrees;

    if (certDegrees.isEmpty) {
      return Text(
        'Add some certDegrees!',
        style: theme.textTheme.displayMedium,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            certDegrees.map((cert) {
              final String startDate =
                  '${cert.dateStarted.toLocal().toString().split(' ')[0]}';
              final String endDate =
                  '${cert.dateEnded?.toLocal().toString().split(' ')[0] ?? "Present"}';

              return GestureDetector(
                onTap:
                    _isLoggedInUser
                        ? () {
                          if (selectedCertDegree == cert) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MyEditCertDegreeScreen(
                                      certDegree: cert,
                                    ),
                              ),
                            );
                          }
                          setState(() {
                            selectedCertDegree = cert;
                          });
                        }
                        : null,
                onLongPress:
                    _isLoggedInUser
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      MyEditCertDegreeScreen(certDegree: cert),
                            ),
                          );
                        }
                        : null,
                child: Container(
                  decoration: BoxDecoration(
                    border:
                        cert == selectedCertDegree
                            ? Border.all(color: theme.primaryColor, width: 3)
                            : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              cert.certificateName,
                              style: theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                startDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endDate,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.institutionName,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cert.description,
                        style: theme.textTheme.displayMedium,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }).toList(),
      );
    }
  }
}
