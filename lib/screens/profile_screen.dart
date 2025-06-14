import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  User? user;

  String name = '';
  String phone = '';
  DateTime? dob;
  String address = '';
  String profileUrl = '';
  DateTime? createdAt;
  String email = '';

  bool loading = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _ensureUserDocumentExists();
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> _ensureUserDocumentExists() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'name': user!.displayName ?? '',
        'email': user!.email ?? '',
        'phone': '',
        'dob': null,
        'address': '',
        'photoUrl': user!.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data() ?? {};

    setState(() {
      name = data['name'] ?? '';
      phone = (data['phone'] ?? '').toString();
      dob = (data['dob'] as Timestamp?)?.toDate();
      address = data['address'] ?? '';
      profileUrl = data['photoUrl'] ?? user!.photoURL ?? '';
      createdAt = (data['createdAt'] as Timestamp?)?.toDate();
      email = data['email'] ?? user!.email ?? '';
      loading = false;
    });
  }

  Future<void> pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && user != null) {
      final file = File(pickedFile.path);
      final ref = FirebaseStorage.instance.ref('profiles/${user!.uid}.jpg');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'photoUrl': url});
      setState(() => profileUrl = url);
    }
  }

  Future<void> saveProfile() async {
    if (_formKey.currentState!.validate() && user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': name,
        'phone': int.tryParse(phone) ?? phone,
        'dob': dob,
        'address': address,
        'photoUrl': profileUrl,
        'email': email,
        'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated')));
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) Navigator.of(context).pop(); // Or replace with Navigator.pushReplacement to login
  }

  Future<void> deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action is permanent.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
      await user!.delete();
      await FirebaseAuth.instance.signOut();
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dob ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) setState(() => dob = picked);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(child: Text('No user is signed in.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout', onPressed: logout),
          IconButton(icon: const Icon(Icons.delete_forever), tooltip: 'Delete Account', onPressed: deleteAccount),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: pickAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
                  child: profileUrl.isEmpty
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                  backgroundColor: Colors.deepPurple.shade200,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                label: 'Name',
                initialValue: name,
                onChanged: (val) => name = val,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              _buildTextField(
                label: 'Phone',
                initialValue: phone,
                onChanged: (val) => phone = val,
                keyboardType: TextInputType.phone,
              ),
              GestureDetector(
                onTap: pickDate,
                child: AbsorbPointer(
                  child: _buildTextField(
                    label: 'Date of Birth',
                    initialValue: dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
                  ),
                ),
              ),
              _buildTextField(
                label: 'Address',
                initialValue: address,
                onChanged: (val) => address = val,
              ),
              _buildTextField(
                label: 'Email',
                initialValue: email,
                readOnly: true,
              ),
              _buildTextField(
                label: 'Joining Date',
                initialValue: createdAt != null ? DateFormat('yyyy-MM-dd').format(createdAt!) : '',
                readOnly: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout, color: Colors.deepPurple),
                label: const Text('Logout', style: TextStyle(color: Colors.deepPurple)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.deepPurple),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: deleteAccount,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
