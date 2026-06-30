import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomList extends StatefulWidget {
  VoidCallback? callBack;
  Text? labelText;
  Icon? iconButton;
  ButtonStyle? buttonStyle;
  OutlinedBorder? buttonShape;
  Color? buttonColor;
  EdgeInsetsGeometry? buttonPadding;
  Widget child;
  Widget? headerRightMenu;
  List<Widget>? headerChildren;
  String? titlePage = "Ini Judul";
  VoidCallback? navigationBackCall;
  Widget? menuItem;
  CustomList({
    super.key, // Tambahkan key
    this.labelText,
    this.buttonStyle,
    this.callBack,
    this.buttonShape,
    this.buttonColor,
    this.buttonPadding,
    this.iconButton,
    required this.child,
    this.titlePage,
    this.headerChildren,
    this.navigationBackCall,
    this.headerRightMenu,
  });
  @override
  _TemplateListState createState() => _TemplateListState();
}

class _TemplateListState extends State<CustomList> {
  @override
  Widget build(BuildContext context) {
    // Media query tetap dipertahankan
    // ignore: unused_local_variable
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      // Atur background Scaffold ke warna putih/abu-abu terang.
      // Warna ini akan terlihat di bawah area header.
      // backgroundColor: Colors.white,

      // Gunakan Column sebagai body utama
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFF1DB954), // green soft modern
                  Color.fromARGB(255, 18, 154, 100),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                // Tetap ada corner radius di bawah
                // bottomRight: Radius.circular(28),
                bottomLeft: Radius.circular(28),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            iconSize: 20,
                            onPressed: widget.navigationBackCall ??
                                () async {
                                  Navigator.pop(context);
                                },
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.titlePage ?? "Ini Judul",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                        widget.headerRightMenu != null
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: widget.headerRightMenu!,
                              )
                            : const SizedBox(width: 44),
                      ],
                    ),
                  ),
                  if (widget.headerChildren != null)
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: widget.headerChildren!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return widget.headerChildren![index];
                      },
                    ),
                ],
              ),
            ),
          ),

          // 2. BODY CONTENT (Area Di Bawah Header)
          // Sekarang ini adalah Expanded, yang mengambil sisa ruang.
          Expanded(
            child: Container(
              // Hapus margin top jika tidak diperlukan lagi,
              // biarkan konten langsung menyentuh header, atau tambahkan sedikit padding.
              // Jika Anda ingin efek "mengambang", gunakan margin/padding di widget.child
              // Container ini tidak perlu BoxDecoration karena Scaffold sudah berwarna putih.
              // Jika ingin background body berbeda, ganti warna di sini atau di Scaffold.
              width: double.infinity,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
