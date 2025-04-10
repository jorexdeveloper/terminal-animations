# Creating a New Animation

The `animations` directory contains predefined animation scripts that can be used with `animate.sh`. You can also create your own custom animations by following these steps:

## Steps to Create a New Animation

1. **Create a New Script File**

    Create a new `.sh` file in the `animations` directory. The file name will be the name of the animation (e.g., `spinner.sh` for an animation named `spinner`).

    ```bash
    touch /path/to/animations/<animation-name>.sh
    ```

2. **Define the Animation Frames**

    Inside the script, define an array named `frames` containing the animation frames. i.e

    ```bash
    frames=("⠁" "⠂" "⠄" "⡀" "⢀" "⠠" "⠐" "⠈")
    ```

3. **Save the Script**

    Save the script and ensure it is readable by the `animate.sh` script.

4. **Test the Animation**

    Use the `-a` option in `animate.sh` to test your new animation:

    ```bash
    _ -a <animation-name> sleep 5
    ```

## Example Animation Script

Here is an example of a custom animation script named `spinner.sh`:

```bash
# Name: spinner
# filepath: /path/to/animations/spinner.sh

frames=("⠁" "⠂" "⠄" "⡀" "⢀" "⠠" "⠐" "⠈")
```

## Notes

-   Ensure the script only defines the `frames` array.
-   Avoid adding any other logic or commands in the animation script.
-   The animation name must be unique within the `animations` directory.
