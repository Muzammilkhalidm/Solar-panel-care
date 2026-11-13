
import '../../../core/constants/app_assets.dart';

/// Immutable onboarding slide data.
class OnboardingData {
  const OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  /// Named accessors mirroring AppAssets for readability in lists.
  static const String solarFarmImage = AppAssets.imgSolarFarm;
}
