import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ticket_wise_admin/Model/category_model.dart';
import 'package:ticket_wise_admin/provider/category_provider.dart';
import 'package:ticket_wise_admin/provider/file_upload_provider.dart';
import 'package:ticket_wise_admin/provider/image_picker_provider.dart';
import 'package:ticket_wise_admin/widgets/constants.dart';
import 'package:ticket_wise_admin/widgets/custom_text_fields.dart';
import 'package:provider/provider.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  AddCategoryScreenState createState() => AddCategoryScreenState();
}

class AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController categoryController = TextEditingController();

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
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: PrimaryColor,
        title: Text(
          'Add Category',
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
                          : const Icon(
                              Icons.category,
                              size: 80,
                              color: PrimaryColor,
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
                                    'Choose Category Photo',
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
              const SizedBox(height: 25),
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
                  backgroundColor: WidgetStateProperty.all(PrimaryColor),
                ),
                child:
                    const Text('SUBMIT', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  EasyLoading.show();
                  if (imagePickerProvider.selectedImage != null) {
                    String? imageUrl = await fileUploadProvider.fileUpload(
                      file: imagePickerProvider.selectedImage!,
                      fileName: categoryController.text,
                      folder: 'categories',
                    );
                    if (imageUrl != null) {
                      await categoryProvider.addCategory(
                        CategoryModel(
                          categoryId: '',
                          categoryImageurl: imageUrl,
                          categoryName: categoryController.text,
                        ),
                      );
                      categoryController.clear();
                      imagePickerProvider.reset();

                      Navigator.pop(context);
                      EasyLoading.dismiss();
                    }
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
