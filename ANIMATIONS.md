# Creating a New Animation

The `animations` directory contains predefined animations but you can also create your own custom animations by following these steps:

## Steps to Create a New Animation

1. **Create a New Script File**

   Create a new file in the animations directory ending with `.sh`. This will be the name of the animation i.e. `classic.sh` for an animation named `classic`.

   ```bash
   touch /path/to/animations/classic.sh
   ```

2. **Define the Animation Frames**

   Inside the script, define an array named `__animations__frames` containing the animation frames. i.e

   ```bash
   # Name: classic
   __animations__frames=('-' '\' '|' '/')
   ```

3. **Use the Animation**

   Use the `-a` option with the animation name (excluding the `.sh`) to use your new animation i.e

   ```bash
   animate.sh -a classic sleep 5
   ```
