import 'package:flutter/material.dart';

void main() {
  runApp(const HealthSystemApp());
}

class HealthSystemApp extends StatelessWidget {
  const HealthSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const HealthSystemHome(),
    );
  }
}

class HealthSystemHome extends StatefulWidget {
  const HealthSystemHome({super.key});

  @override
  State<HealthSystemHome> createState() => _HealthSystemHomeState();
}

class _HealthSystemHomeState extends State<HealthSystemHome> {
  // Login Section
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  bool loggedIn = false;

  // Patients Section
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();
  String gender = 'Male';
  final List<Map<String, dynamic>> patients = [];

  void doLogin() {
    if (emailCtrl.text.trim() == 'admin' && passCtrl.text.trim() == '1234') {
      setState(() => loggedIn = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid credentials (use admin / 1234)')),
      );
    }
  }

  void addPatient() {
    if (nameCtrl.text.trim().isEmpty || ageCtrl.text.trim().isEmpty) return;
    setState(() {
      patients.add({
        'name': nameCtrl.text.trim(),
        'age': int.tryParse(ageCtrl.text.trim()) ?? 0,
        'gender': gender,
        'notes': notesCtrl.text.trim(),
      });
      nameCtrl.clear();
      ageCtrl.clear();
      notesCtrl.clear();
      gender = 'Male';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loggedIn ? 'Health Dashboard' : 'Health Login'),
        actions: [
          if (loggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => setState(() => loggedIn = false),
            ),
        ],
      ),
      body: loggedIn ? _buildDashboard() : _buildLogin(),
    );
  }

  Widget _buildLogin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.health_and_safety, size: 60, color: Colors.teal),
                const SizedBox(height: 16),
                const Text('Health System Login', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: doLogin,
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Add New Patient', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Patient Name')),
          const SizedBox(height: 8),
          TextField(
            controller: ageCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Age'),
          ),
          const SizedBox(height: 8),
          DropdownButton<String>(
            value: gender,
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => gender = v ?? 'Male'),
          ),
          const SizedBox(height: 8),
          TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: addPatient,
              icon: const Icon(Icons.add),
              label: const Text('Add Patient'),
            ),
          ),
          const Divider(height: 30),
          const Text('Patient List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...patients.map((p) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text('${p['name']} (${p['age']} yrs)'),
                subtitle: Text('${p['gender']} - ${p['notes']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => setState(() => patients.remove(p)),
                ),
              ),
            );
          }).toList(),
          if (patients.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: Text('No patients added yet')),
            ),
        ],
      ),
    );
  }
}
