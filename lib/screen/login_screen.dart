import 'package:cocoa_sense/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;
  bool rememberMe = false;

  final Color primaryColor = const Color(0xFF2D7A4F);

  void _login() async {
    if (!_formKey.currentState!.validate()) {
      debugPrint("❌ Form validation gagal");
      return;
    }

    setState(() => isLoading = true);

    debugPrint("🔄 Mencoba login...");
    debugPrint("📧 Email: ${emailController.text}");
    debugPrint("🔐 Password length: ${passwordController.text.length}");

    try {
      // Simulasi koneksi server
      await Future.delayed(const Duration(seconds: 2));

      // Simulasi response (ganti nanti dengan API Laravel)
      // bool serverConnected = true;
      bool loginSuccess =
          emailController.text == "admin@email.com" &&
          passwordController.text == "123456";

      // if (!serverConnected) {
      //   debugPrint("❌ Tidak tersambung ke server");
      //   throw Exception("Server tidak merespon");
      // }

      if (loginSuccess) {
        debugPrint("✅ Login BERHASIL");
        debugPrint("🟢 Status: 200 OK");

        Get.offAllNamed(AppRoutes.main);
      } else {
        debugPrint("❌ Login GAGAL");
        debugPrint("🔴 Status: 401 Unauthorized");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau password salah")),
        );
      }
    } catch (e) {
      debugPrint("🚨 ERROR TERJADI");
      debugPrint("Detail error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi kesalahan koneksi")),
      );
    } finally {
      setState(() => isLoading = false);
      debugPrint("🔚 Proses login selesai\n");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/OIP.png',
                            width: 160,
                            height: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: Icon(
                                  Icons.eco,
                                  size: 125,
                                  color: const Color(0xFF2D7A4F),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          // Text(
                          //   "Selamat Datang",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //     color: primaryColor,
                          //   ),
                          // ),
                          const SizedBox(height: 6),
                          const Text(
                            "Silakan login untuk melanjutkan",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Email Field
                    const Text(
                      "Email",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        hintText: "contoh@email.com",
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email tidak boleh kosong";
                        }
                        if (!value.contains("@")) {
                          return "Format email tidak valid";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    /// Password Field
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        hintText: "Masukkan password",
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: primaryColor, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        if (value.length < 6) {
                          return "Minimal 6 karakter";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 8),

                    /// Remember + Forgot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text("Ingat saya"),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Lupa password?",
                            style: TextStyle(color: primaryColor),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: isLoading ? null : _login,
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Masuk",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
