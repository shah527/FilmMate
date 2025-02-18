import numpy as np
import cv2

# Capturing video through webcam
webcam = cv2.VideoCapture(0)

# Default: Detect all colors
selected_color = "all"

# Print instructions
print("Please press the following keys to detect specific colors:")
print("r: Detect Red")
print("g: Detect Green")
print("b: Detect Blue")
print("a: Detect All Colors")
print("1: Detect Neon Green")
print("2: Detect Neon Pink")
print("3: Detect Neon Blue")
print("4: Detect Neon Yellow")
print("5: Detect Neon Orange")
print("6: Detect Neon Purple")
print("q: Quit the program")

while True:
    # Read the video frame
    ret, imageFrame = webcam.read()
    if not ret:
        break

    # Convert the image to HSV color space
    hsvFrame = cv2.cvtColor(imageFrame, cv2.COLOR_BGR2HSV)

    # Define color ranges (HSV format)
    color_ranges = {
    "red": ([136, 87, 111], [180, 255, 255]),
    "green": ([25, 52, 72], [102, 255, 255]),
    "blue": ([94, 80, 2], [120, 255, 255]),
    "neon_green": ([60, 150, 100], [75, 255, 255]),  # #39FF14
    "neon_pink": ([145, 50, 100], [160, 255, 255]),  # #FF10F0
    "neon_blue": ([110, 50, 100], [125, 255, 255]),  # #1F51FF
    "neon_yellow": ([30, 150, 100], [40, 255, 255]),  # #FFFF33
    "neon_orange": ([15, 150, 100], [25, 255, 255]),  # #FFA500
    "neon_purple": ([130, 50, 100], [150, 255, 255])  # #B026FF
    }

    # Kernel for morphological operations
    kernel = np.ones((5, 5), np.uint8)

    # Dictionary to store detected objects
    detected_objects = {}

    # Process only the selected color or all colors
    for color, (lower, upper) in color_ranges.items():
        if selected_color == "all" or selected_color == color:
            # Convert HSV values to numpy arrays
            lower_bound = np.array(lower, np.uint8)
            upper_bound = np.array(upper, np.uint8)

            # Create mask for the current color
            mask = cv2.inRange(hsvFrame, lower_bound, upper_bound)

            # Apply dilation to remove noise
            mask = cv2.dilate(mask, kernel)

            # Find contours
            contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

            # Find the largest object of the color
            max_area = 0
            largest_contour = None

            for contour in contours:
                area = cv2.contourArea(contour)
                if area > 500:  # Filter small objects
                    if area > max_area:
                        max_area = area
                        largest_contour = contour

            if largest_contour is not None:
                detected_objects[color] = largest_contour

    # Draw bounding boxes for detected objects
    for color, contour in detected_objects.items():
        x, y, w, h = cv2.boundingRect(contour)
        color_map = {
            "red": (0, 0, 255),
            "green": (0, 255, 0),
            "blue": (255, 0, 0),
            "neon_green": (57, 255, 20),
            "neon_pink": (255, 16, 240),
            "neon_blue": (31, 81, 255),
            "neon_yellow": (255, 255, 51),
            "neon_orange": (255, 165, 0),
            "neon_purple": (176, 38, 255)
        }
        cv2.rectangle(imageFrame, (x, y), (x + w, y + h), color_map[color], 2)
        cv2.putText(imageFrame, f"{color.replace('_', ' ').capitalize()} Object", (x, y - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, color_map[color], 2)

    # Display the frame
    cv2.imshow("Color Detection", imageFrame)

    # Listen for user input
    key = cv2.waitKey(10) & 0xFF
    if key == ord('q'):  # Quit the program
        break
    elif key == ord('r'):  # Detect only Red
        selected_color = "red"
        print("Detecting Red")
    elif key == ord('g'):  # Detect only Green
        selected_color = "green"
        print("Detecting Green")
    elif key == ord('b'):  # Detect only Blue
        selected_color = "blue"
        print("Detecting Blue")
    elif key == ord('a'):  # Detect All Colors
        selected_color = "all"
        print("Detecting All Colors")
    elif key == ord('1'):  # Detect Neon Green
        selected_color = "neon_green"
        print("Detecting Neon Green")
    elif key == ord('2'):  # Detect Neon Pink
        selected_color = "neon_pink"
        print("Detecting Neon Pink")
    elif key == ord('3'):  # Detect Neon Blue
        selected_color = "neon_blue"
        print("Detecting Neon Blue")
    elif key == ord('4'):  # Detect Neon Yellow
        selected_color = "neon_yellow"
        print("Detecting Neon Yellow")
    elif key == ord('5'):  # Detect Neon Orange
        selected_color = "neon_orange"
        print("Detecting Neon Orange")
    elif key == ord('6'):  # Detect Neon Purple
        selected_color = "neon_purple"
        print("Detecting Neon Purple")

# Cleanup
webcam.release()
cv2.destroyAllWindows()
