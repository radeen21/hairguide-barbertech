import 'package:flutter/material.dart';
import 'package:hairguide_barberpedia/features/user/auth/presentation/register/register_controller.dart';

class RegisterPage extends StatefulWidget {
  final RegisterController controller;

  const RegisterPage({
    super.key,
    required this.controller,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool _isFormValid = false;
  bool _hasSubmitted = false;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_validateForm);
    _dobController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);

    _validateForm();
  }

  void _validateForm() {
    final valid =
        _nameController.text.trim().isNotEmpty &&
        _dobController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _passwordController.text ==
            _confirmPasswordController.text;

    if (_isFormValid != valid) {
      debugPrint(" FORM VALID = $valid");
      setState(() => _isFormValid = valid);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      _dobController.text =
          "${date.year}-${_two(date.month)}-${_two(date.day)}";
    }
  }

  String _two(int v) => v.toString().padLeft(2, "0");

  
  Future<void> _handleRegister() async {
    setState(() => _hasSubmitted = true);

    if (!_isFormValid) {
      debugPrint("FORM INVALID");
      return;
    }

    try {
      await widget.controller.register(
        context: context,
        email: _emailController.text.trim(),
        phone: _normalizePhone(_phoneController.text.trim()),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        dob: _dobController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _normalizePhone(String phone) {
    if (phone.startsWith("0")) {
      return "+62${phone.substring(1)}";
    }
    if (phone.startsWith("62")) {
      return "+$phone";
    }
    return phone;
  }

  bool _isFieldInvalid(TextEditingController c) {
    if (!_hasSubmitted) return false;
    return c.text.trim().isEmpty;
  }

  bool _isPasswordMismatch() {
    if (!_hasSubmitted) return false;
    return _passwordController.text !=
        _confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// BACK
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Daftar Akun",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _inputField(
                    "Nama Lengkap",
                    _nameController,
                    isError: _isFieldInvalid(_nameController),
                  ),

                  _inputField(
                    "Tanggal Lahir",
                    _dobController,
                    readOnly: true,
                    onTap: _pickDate,
                    isError: _isFieldInvalid(_dobController),
                  ),

                  _inputField(
                    "Email",
                    _emailController,
                    isError: _isFieldInvalid(_emailController),
                  ),

                  _inputField(
                    "Nomor HP",
                    _phoneController,
                    keyboardType: TextInputType.phone,
                    isError: _isFieldInvalid(_phoneController),
                  ),

                  _passwordField(
                    "Buat Password",
                    _passwordController,
                    showPassword,
                    () => setState(() => showPassword = !showPassword),
                    isError: _isFieldInvalid(_passwordController),
                  ),

                  _passwordField(
                    "Konfirmasi Password",
                    _confirmPasswordController,
                    showConfirmPassword,
                    () =>
                        setState(() => showConfirmPassword = !showConfirmPassword),
                    isError: _isPasswordMismatch(),
                  ),

                  const SizedBox(height: 30),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid
                            ? const Color(0xFFF6AD03)
                            : const Color(0xFF444444),
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: _isFormValid
                              ? const Color(0xFFF6AD03)
                              : const Color(0xFF444444),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(120),
                        ),
                      ),
                      child: const Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),

                  /// LOGIN
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? ",
                          style: TextStyle(color: Colors.white70)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login di sini",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        /// LOADING
        if (widget.controller.isLoading)
          Container(
            color: Colors.black.withOpacity(0.6),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          ),
      ],
    );
  }

  // ================= UI HELPERS =================

  Widget _inputField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
    bool isError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label, isError),
      ),
    );
  }

  Widget _passwordField(
    String label,
    TextEditingController controller,
    bool show,
    VoidCallback toggle, {
    bool isError = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: !show,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(label, isError).copyWith(
          suffixIcon: IconButton(
            icon: Icon(
              show ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, bool isError) {
    final borderColor = isError ? Colors.red : Colors.white24;

    return InputDecoration(
      filled: true,
      fillColor: Colors.black,
      labelText: label,
      labelStyle: TextStyle(
        color: isError ? Colors.redAccent : Colors.white70,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isError ? Colors.red : const Color(0xFFF6AD03),
          width: 2,
        ),
      ),
    );
  }
}
