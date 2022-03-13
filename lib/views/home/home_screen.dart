import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_vision_frontend/cubits/food_image/food_image_cubit.dart';
import 'package:food_vision_frontend/models/color_palette.dart';
import 'package:food_vision_frontend/views/home/widgets/image_container.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.lavanderWeb,
      body: MultiBlocListener(
        listeners: [
          BlocListener<FoodImageCubit, FoodImageState>(
            listener: (context, state) {
              if (state is FoodImageEmptyUrl) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'You failed to provide an image',
                      style: GoogleFonts.robotoMono(
                        color: ColorPalette.carribeanGreen,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: ColorPalette.manatee,
                  ),
                );
              } else if (state is FoodImageError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: GoogleFonts.robotoMono(
                        color: ColorPalette.manatee,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: const Color.fromARGB(255, 173, 39, 29),
                  ),
                );
              }
            },
          ),
        ],
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Expanded(
                child: Text(
                  'Food Vision Front-End',
                  style: GoogleFonts.spaceMono(
                    fontSize: 44,
                    color: ColorPalette.carribeanGreen,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            BlocBuilder<FoodImageCubit, FoodImageState>(
              builder: (context, state) {
                if (state is FoodImageLoading) {
                  return const ImageContainer(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FoodImageLoaded) {
                  return ImageContainer(
                    child: Image.network(
                      state.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                } else if (state is FoodImageError) {
                  return ImageContainer(
                    child: Center(
                      child: Text(
                        'Error fetching image',
                        style: GoogleFonts.robotoMono(
                          color: const Color.fromARGB(255, 173, 39, 29),
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                }

                return ImageContainer(
                  child: Center(
                    child: Text(
                      'No image provided',
                      style: GoogleFonts.robotoMono(
                        color: ColorPalette.carribeanGreen,
                        fontSize: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
