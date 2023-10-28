class CourseDetails {
  String courseName;
  String courseId;
  String courseDocumentId;
  String coursePrice;
  String courseDescription;
  String createdBy;
  String amountPayable;
  String discount;
  bool isItComboCourse;
  String courseImageUrl;
  String courseLanguage;
  List courses;
  dynamic curriculum;
  String numOfVideos;
  String FcSerialNumber;
  String courseContent;
  bool? show;
  bool? free;
  String? duration;
  String reviews;
  bool? trialCourse;
  String trialDays;
  bool? multiCombo;
  bool? international;
  String? dataly_actual_price;
  String? dataly_discounted_price;
  String? dataly_FcSerialNumber;

  CourseDetails(
      {required this.courseName,
      required this.courseId,
      required this.coursePrice,
      required this.courseDescription,
      required this.amountPayable,
      required this.discount,
      required this.isItComboCourse,
      required this.courseImageUrl,
      required this.courseLanguage,
      required this.courses,
      required this.curriculum,
      required this.numOfVideos,
      required this.createdBy,
      required this.courseDocumentId,
      required this.FcSerialNumber,
      required this.courseContent,
      this.show,
      this.free,
      this.duration,
      required this.reviews,
      this.trialCourse,
      required this.trialDays,
      this.multiCombo,
      this.international,
        this.dataly_actual_price,
        this.dataly_discounted_price,
        this.dataly_FcSerialNumber

      });
}
