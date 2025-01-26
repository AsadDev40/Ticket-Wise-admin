// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ticket_wise_admin/Model/category_model.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/provider/file_upload_provider.dart';
import 'package:ticket_wise_admin/provider/image_picker_provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:ticket_wise_admin/widgets/custom_text_fields.dart';
import 'package:provider/provider.dart';

class EditCategoryScreen extends StatefulWidget {
  final CategoryModel category; // Pass the existing category data

  const EditCategoryScreen({super.key, required this.category});

  @override
  EditCategoryScreenState createState() => EditCategoryScreenState();
}

class EditCategoryScreenState extends State<EditCategoryScreen> {
  // Declare categoryController here
  final TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the text field and dropdown with existing category data
    categoryController.text = widget.category.categoryName;

    // Ensure the selected category type is one of the available types or null
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);
    final fileUploadProvider = Provider.of<FileUploadProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        title: const Text(
          'Edit Category',
          style: TextStyle(color: Colors.white),
        ),
      ),
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
                                widget.category.categoryImageurl,
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
                                    'Choose category Photo',
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
                                          color: PrimaryColor,
                                        ),
                                        label: const Text(
                                          'Camera',
                                          style: TextStyle(color: PrimaryColor),
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
                                          color: PrimaryColor,
                                        ),
                                        label: const Text(
                                          'Gallery',
                                          style: TextStyle(color: PrimaryColor),
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
                  controller: categoryController,
                  hintText: 'Enter Category Name:',
                  hintStyle: const TextStyle(fontSize: 15, color: PrimaryColor),
                  textAlign: TextAlign.left,
                  enableBorder: true,
                  textStyle: const TextStyle(color: PrimaryColor),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(const Size(190, 40)),
                    alignment: Alignment.center,
                    backgroundColor: WidgetStateProperty.all(PrimaryColor)),
                child: const Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  EasyLoading.show();
                  if (categoryController.text.isNotEmpty) {
                    String? imageUrl;
                    if (imagePickerProvider.selectedImage != null) {
                      imageUrl = await fileUploadProvider.fileUpload(
                        file: imagePickerProvider.selectedImage!,
                        fileName: categoryController.text,
                        folder: 'categories',
                      );
                    } else {
                      imageUrl = widget.category.categoryImageurl;
                    }

                    await categoryProvider.updateCategory(
                      CategoryModel(
                        categoryId:
                            widget.category.categoryId, // Keep existing ID
                        categoryImageurl: imageUrl!,
                        categoryName: categoryController.text,
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
