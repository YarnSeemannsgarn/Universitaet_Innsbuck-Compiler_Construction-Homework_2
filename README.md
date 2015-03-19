How to run the programme
========================

First of all build the programme:

      $ make

Afterwards you can run the progamme (solution) with an input file and an output file, which will be the input with capitalized keywords, non-redundant whitespaces and old-style Pascal comments:

      $ ./solution sample.pas sample_gen.pas
      $ ./solution task5.pas task5_gen.pas

If you want to clean up just do:

      $ make clean