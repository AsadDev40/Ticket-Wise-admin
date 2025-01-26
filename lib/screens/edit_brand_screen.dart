import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ticket_wise_admin/Model/brand_model.dart';
import 'package:ticket_wise_admin/provider/brand_provider.dart';
import 'package:ticket_wise_admin/provider/file_upload_provider.dart';
import 'package:ticket_wise_admin/provider/image_picker_provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:ticket_wise_admin/widgets/custom_text_fields.dart';

import 'package:provider/provider.dart';

class EditBrandScreen extends StatefulWidget {
  final BrandModel brand; // Pass the existing brand data

  const EditBrandScreen({super.key, required this.brand});

  @override
  EditBrandScreenState createState() => EditBrandScreenState();
}

class EditBrandScreenState extends State<EditBrandScreen> {
  // Declare brandController here
  final TextEditingController brandController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text field with existing brand data
    brandController.text = widget.brand.brandName; // Update to use brand name
  }

  @override
  void dispose() {
    brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);
    final fileUploadProvider = Provider.of<FileUploadProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 30),
                child: Stack(
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: PrimaryColor),
                      ),
                      child: imagePickerProvider.selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                imagePickerProvider.selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                widget.brand
                                    .brandImageurl, // Update to use brand image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Choose Brand Photo',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () async {
                                          await imagePickerProvider
                                              .pickImageFromCamera();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.camera,
                                          size: 30,
                                          color: Colors.purple,
                                        ),
                                        label: const Text(
                                          'Camera',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          await imagePickerProvider
                                              .pickImageFromGallery();
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.image,
                                          color: Colors.purple,
                                        ),
                                        label: const Text(
                                          'Gallery',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: CustomTextField(
                  controller: brandController,
                  hintText: 'Enter Brand Name:', // Update hint text for brand
                  hintStyle: const TextStyle(fontSize: 15, color: PrimaryColor),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                  textStyle: const TextStyle(color: PrimaryColor),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(190, 40)),
                  alignment: Alignment.center,
                ),
                child: const Text(
                  'UPDATE',
                  style: TextStyle(color: PrimaryColor),
                ),
                onPressed: () async {
                  EasyLoading.show();
                  if (brandController.text.isNotEmpty) {
                    String? imageUrl;
                    if (imagePickerProvider.selectedImage != null) {
                      imageUrl = await fileUploadProvider.fileUpload(
                        file: imagePickerProvider.selectedImage!,
                        fileName: brandController.text,
                        folder: 'brands', // Update folder to brands
                      );
                    } else {
                      imageUrl =
                          widget.brand.brandImageurl; // Use existing image URL
                    }

                    await brandProvider.updateBrand(
                      BrandModel(
                        brandId: widget.brand.brandId, // Keep existing ID
                        brandImageurl: imageUrl
                            .toString(), // Update to use brand image URL
                        brandName: brandController.text,
                      ),
                    );
                    EasyLoading.dismiss();
                    Navigator.pop(context);
                  } else {
                    EasyLoading.showError(
                        'Please fill all the fields and select an image.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
