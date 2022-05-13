import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mio_amore/helpers/constants.dart';
import 'package:mio_amore/helpers/date_formater.dart';
import 'package:mio_amore/models/get_verified_model.dart';
import 'package:mio_amore/models/user_profile_model.dart';
import 'package:mio_amore/providers/verification_provider.dart';
import 'package:mio_amore/views/custom/custom_button.dart';
import 'package:mio_amore/views/settings/verification/photo_id_page.dart';
import 'package:mio_amore/views/settings/verification/selfie_page.dart';

class GetVerifiedPage extends ConsumerStatefulWidget {
  final UserProfileModel user;

  const GetVerifiedPage({Key? key, required this.user}) : super(key: key);

  @override
  ConsumerState<GetVerifiedPage> createState() => _GetVerifiedPageState();
}

class _GetVerifiedPageState extends ConsumerState<GetVerifiedPage> {
  bool _submitAgain = false;
  @override
  Widget build(BuildContext context) {
    final _verificationProvider = ref.watch(verificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: _submitAgain
          ? const _NotVerifiedPart(submitAgain: true)
          : widget.user.isVerified
              ? const Center(
                  child: Text('You are verified'),
                )
              : FutureBuilder<GetVerifiedModel?>(
                  future: _verificationProvider.getVerifiedStatus(),
                  builder: (BuildContext context,
                      AsyncSnapshot<GetVerifiedModel?> snapshot) {
                    return snapshot.hasError
                        ? const Center(
                            child: Text('Error'),
                          )
                        : snapshot.data == null
                            ? const _NotVerifiedPart(submitAgain: false)
                            : _VerifiedPart(
                                data: snapshot.data!,
                                onPressedSubmitAgain: () {
                                  setState(() {
                                    _submitAgain = true;
                                  });
                                },
                              );
                  },
                ),
    );
  }
}

class _VerifiedPart extends StatelessWidget {
  final GetVerifiedModel data;
  final VoidCallback onPressedSubmitAgain;
  const _VerifiedPart({
    Key? key,
    required this.data,
    required this.onPressedSubmitAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNotApproved = data.isPending == false && data.isApproved == false;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _isNotApproved
                      ? Icon(
                          Icons.warning,
                          color: Colors.red,
                          size: MediaQuery.of(context).size.width * 0.15,
                        )
                      : Icon(
                          Icons.hourglass_bottom,
                          color: Colors.blue,
                          size: MediaQuery.of(context).size.width * 0.15,
                        ),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  Text(
                    _isNotApproved
                        ? 'Not Approved'
                        : 'Your account is pending verification',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  Text(
                    _isNotApproved
                        ? data.statusMessage ??
                            "Your account is not approved. Please submit your documents again to verify your account."
                        : "You have submitted your documents.\nWe will verify your documents and update the status of your account.",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.defaultNumericValue),
                  _isNotApproved
                      ? CustomButton(
                          text: "Submit again",
                          onPressed: onPressedSubmitAgain,
                        )
                      : const SizedBox(),
                  const Divider(height: AppConstants.defaultNumericValue),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    "Submitted at: ${DateFormatter.toWholeDate(data.createdAt)}",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                const SizedBox(height: AppConstants.defaultNumericValue / 4),
                Text(
                    "Last Updated at: ${DateFormatter.toWholeDate(data.updatedAt)}",
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _NotVerifiedPart extends ConsumerStatefulWidget {
  final bool submitAgain;
  const _NotVerifiedPart({
    Key? key,
    required this.submitAgain,
  }) : super(key: key);

  @override
  ConsumerState<_NotVerifiedPart> createState() => _NotVerifiedPartState();
}

class _NotVerifiedPartState extends ConsumerState<_NotVerifiedPart> {
  File? _photoIdFrontView;
  File? _photoIdBackView;
  File? _selfie;

  void _onSubmit() async {
    final _verificationProvider = ref.read(verificationProvider);

    EasyLoading.show(status: 'Uploading...');
    String? _photoIdFrontPath =
        await _savePictures(_photoIdFrontView!, "photoIdFront");
    String? _photoIdBackPath =
        await _savePictures(_photoIdBackView!, "photoIdBack");
    String? _selfiePath = await _savePictures(_selfie!, "selfie");

    if (_photoIdFrontPath == null ||
        _photoIdBackPath == null ||
        _selfiePath == null) {
      EasyLoading.showInfo("Something went wrong. Please try again later.");
      return;
    } else {
      GetVerifiedModel _form = GetVerifiedModel(
        id: FirebaseAuth.instance.currentUser!.uid,
        userId: FirebaseAuth.instance.currentUser!.uid,
        photoIdFrontViewUrl: _photoIdFrontPath,
        photoIdBackViewUrl: _photoIdBackPath,
        selfieUrl: _selfiePath,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPending: true,
        isApproved: false,
      );
      if (widget.submitAgain) {
        await _verificationProvider.updateVerificationForm(_form);
      } else {
        await _verificationProvider.submitVerificationForm(_form);
      }
      EasyLoading.showSuccess("Submitted successfully");
    }
  }

  Future<String?> _savePictures(File file, String title) async {
    Reference _storageReference = FirebaseStorage.instance
        .ref()
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("Verification Pictures")
        .child(title);

    String? _url;

    UploadTask _uploadTask = _storageReference.putFile(file);
    await _uploadTask.whenComplete(() async =>
        await _storageReference.getDownloadURL().then((value) => _url = value));
    return _url;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure to discard verification?'),
              actions: [
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(AppConstants.defaultNumericValue),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Submit documents",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(height: AppConstants.defaultNumericValue / 2),
              Text(
                "We need to verify your information.\n Please submit the documents below.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: AppConstants.defaultNumericValue * 4),
              VerificationSingleStep(
                leadingIcon: Icons.credit_card,
                onTap: () async {
                  final List<File>? _results = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoIdPage(
                        frontView: _photoIdFrontView,
                        backView: _photoIdBackView,
                      ),
                    ),
                  );
                  setState(() {
                    _photoIdFrontView = _results?.first;
                    _photoIdBackView = _results?.last;
                  });
                },
                title: "Photo ID",
                trailingIcon:
                    _photoIdFrontView != null && _photoIdBackView != null
                        ? Icons.check
                        : Icons.arrow_forward,
              ),
              const SizedBox(height: AppConstants.defaultNumericValue),
              VerificationSingleStep(
                leadingIcon: Icons.camera_alt,
                onTap: () async {
                  final File? _result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelfiePage(selfie: _selfie),
                    ),
                  );
                  setState(() {
                    _selfie = _result;
                  });
                },
                title: "Take a selfie",
                trailingIcon:
                    _selfie != null ? Icons.check : Icons.arrow_forward,
              ),
              const SizedBox(height: AppConstants.defaultNumericValue * 2),
              _photoIdBackView != null &&
                      _photoIdFrontView != null &&
                      _selfie != null
                  ? CustomButton(text: "Submit", onPressed: _onSubmit)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class VerificationSingleStep extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final IconData trailingIcon;
  final VoidCallback onTap;
  const VerificationSingleStep({
    Key? key,
    required this.leadingIcon,
    required this.title,
    required this.trailingIcon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.all(16),
      title: Text(title),
      leading: Icon(leadingIcon),
      trailing: CircleAvatar(
          backgroundColor: AppConstants.primaryColor,
          foregroundColor: Colors.white,
          child: Icon(trailingIcon)),
      onTap: onTap,
    );
  }
}
