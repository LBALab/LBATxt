# LBA Text Editor 2

This program allows you to edit dialogue lines Little Big Adventure 1 and 2 games.
Dialogues are placed in the Text.HQR files in both games.

The format in both games is identical. The data contains maps lists of text lines for each area. Eeach text line has a byte defining the text's display mode: dialogue (3-line), floating (1-line) or fullscreen. Each text file also has an index associated which tell the game what number each text line should be referenced by in the scripts. This allows for grouping of text lines in the files by character or by dialogue.

The program has a built-in simple text editor, and also can use a user-defined text editor (it will monitor the saving action of the user editor, and update the line in the text file automatically).

This program is released under GNU GPL license.
