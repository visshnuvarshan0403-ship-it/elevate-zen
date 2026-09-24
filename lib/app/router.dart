import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import '../patient/home_screen.dart';
import '../patient/case_screen.dart';
import '../patient/chat_screen.dart';
import '../patient/records_screen.dart';
import '../patient/previous_records_screen.dart';
import '../patient/profile_screen.dart';
import '../patient/mental_wellness_screen.dart';
import '../doctor/home_screen.dart';
import '../doctor/patients_screen.dart';
import '../doctor/profile_screen.dart';
import '../doctor/chat_screen.dart';
import '../doctor/patient_screen.dart';
import '../patient/doctor_chat_screen.dart';
import '../patient/document_upload_screen.dart';
import '../patient/abha_screen.dart';
import '../veterinary/veterinary_home_screen.dart';
import '../veterinary/veterinary_chat_screen.dart';
import '../veterinary/veterinary_records_screen.dart';

class ElevateZenRouter {
  static const String login = '/';

  static const String patientHome = '/patient';
  static const String patientCase = '/patient/case';
  static const String patientChat = '/patient/chat';
  static const String patientRecords = '/patient/records';
  static const String previousRecords = '/patient/previous-records';
  static const String patientProfile = '/patient/profile';
  static const String patientMentalWellness = '/patient/mental-wellness';
  static const String patientDoctorChat = '/patient/doctor-chat';
  static const String patientDocuments = '/patient/documents';
  static const String patientAbha = '/patient/abha';

  static const String doctorHome = '/doctor';
  static const String doctorPatients = '/doctor/patients';
  static const String doctorChat = '/doctor/chat';
  static const String doctorProfile = '/doctor/profile';
  static const String doctorPatient = '/doctor/patient';

  static const String veterinaryHome = '/veterinary';
  static const String veterinaryRecords = '/veterinary/records';
  static const String veterinaryIntake = '/veterinary/intake';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case patientHome:
        return MaterialPageRoute(
          builder: (_) => const PatientHomeScreen(),
          settings: settings,
        );

      case patientCase:
        return MaterialPageRoute(
          builder: (_) => const PatientCaseScreen(),
          settings: settings,
        );

      case patientChat:
        return MaterialPageRoute(
          builder: (_) => const PatientChatScreen(),
          settings: settings,
        );

      case patientRecords:
        return MaterialPageRoute(
          builder: (_) => const PatientRecordsScreen(),
          settings: settings,
        );

      case previousRecords:
        return MaterialPageRoute(
          builder: (_) => const PreviousRecordsScreen(),
          settings: settings,
        );

      case patientProfile:
        return MaterialPageRoute(
          builder: (_) => const PatientProfileScreen(),
          settings: settings,
        );
      
      case patientMentalWellness:
        return MaterialPageRoute(
          builder: (_) => const MentalWellnessScreen(),
          settings: settings,
        );

      case patientDoctorChat:
        return MaterialPageRoute(
          builder: (_) => const PatientDoctorChatScreen(),
          settings: settings,
        );

      case patientDocuments:
        return MaterialPageRoute(
          builder: (_) => const DocumentUploadScreen(),
          settings: settings,
        );

      case patientAbha:
        return MaterialPageRoute(
          builder: (_) => const AbhaScreen(),
          settings: settings,
        );

      case doctorHome:
        return MaterialPageRoute(
          builder: (_) => const DoctorHomeScreen(),
          settings: settings,
        );

      case doctorPatients:
        return MaterialPageRoute(
          builder: (_) => const DoctorPatientsScreen(),
          settings: settings,
        );
      
      case doctorPatient:
        return MaterialPageRoute(
          builder: (_) => const DoctorPatientScreen(),
          settings: settings,
        );

      case doctorChat:
        return MaterialPageRoute(
          builder: (_) => const DoctorChatScreen(),
          settings: settings,
        );

      case doctorProfile:
        return MaterialPageRoute(
          builder: (_) => const DoctorProfileScreen(),
          settings: settings,
        );

      case veterinaryHome:
        return MaterialPageRoute(
          builder: (_) => const VeterinaryHomeScreen(),
          settings: settings,
        );

      case veterinaryIntake:
        return MaterialPageRoute(
          builder: (_) => const VeterinaryChatScreen(),
          settings: settings,
        );

      case veterinaryRecords:
        return MaterialPageRoute(
          builder: (_) => const VeterinaryRecordsScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderScreen(
            title: 'Page Not Found',
          ),
          settings: settings,
        );
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}