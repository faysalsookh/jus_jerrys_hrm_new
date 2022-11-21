import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hrm_app/screens/appFlow/home/home_provider.dart';
import 'package:hrm_app/utils/res.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CheckStatusSection extends StatelessWidget {
  final HomeProvider? provider;

  const CheckStatusSection({Key? key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return provider?.isCheckIn != null
        ? Visibility(
            visible: provider?.isCheckIn ?? false,
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: InkWell(
                  onTap: () {
                    Provider.of<HomeProvider>(context, listen: false)
                        .loadHomeData(context);
                    provider?.getAttendanceMethod(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: SvgPicture.asset(
                            provider?.checkStatus == "Check In"
                                ? 'assets/home_icon/in.svg'
                                : 'assets/home_icon/out.svg',
                            height: 40,
                            width: 40,
                            placeholderBuilder: (BuildContext context) =>
                                Container(
                                    padding: const EdgeInsets.all(30.0),
                                    child: const CircularProgressIndicator()),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  provider?.checkStatus == "Check In"
                                      ? "Start Time"
                                      : "Done For Today?",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                      letterSpacing: 0.5)),
                              const SizedBox(height: 10),
                              Text(
                                provider?.checkStatus ?? 'Check In',
                                style: const TextStyle(
                                    color: AppColors.colorPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: const Color(0xFFE8E8E8),
                  highlightColor: Colors.white,
                  child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8E8E8),
                        borderRadius: BorderRadius.circular(
                            10), // radius of 10// green as background color
                      )),
                ),
              ],
            ),
          );
  }
}
