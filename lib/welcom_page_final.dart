import 'package:flutter/material.dart';
import 'package:suivie_diplome/login_page_admin.dart';
import 'package:suivie_diplome/pages/student/student_login_page.dart';
import 'package:suivie_diplome/theme.dart';

class WelcomePageFinale extends StatelessWidget {
  const WelcomePageFinale({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/ESTFBS.png'),
              Text('Bienvenue au service de suivie de diplôme, vous êtes...'),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return LogInPageStudent();
                  }));
                },
                color: primaryColor,
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Etudiant',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text('Ou'),
              const SizedBox(
                height: 12,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return LogInPageAdmin();
                  }));
                },
                color: primaryColor,
                minWidth: double.infinity,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  'Un Administrateur',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
