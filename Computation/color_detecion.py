import numpy as np
import cv2

# Capturing video through webcam
webcam = cv2.VideoCapture(0)

# Default: Detect all colors
selected_color = "all"

while True:
    # Read the video frame
    ret, imageFrame = webcam.read()
    if not ret:
        break

    # Convert the image to HSV color space
    hsvFrame = cv2.cvtColor(imageFrame, cv2.COLOR_BGR2HSV)

    # Define color ranges
    color_ranges = {
        "red": ([136, 87, 111], [180, 255, 255]),
        "green": ([25, 52, 72], [102, 255, 255]),
        "blue": ([94, 80, 2], [120, 255, 255]),
    }

    # Kernel for morphological operations
    kernel = np.ones((5, 5), np.uint8)

    # Dictionary to store detected objects
    detected_objects = {}

    # Process only the selected color or all colors
    for color, (lower, upper) in color_ranges.items():
        if selected_color == "all" or selected_color == color:
            # Create mask for the current color
            lower_bound = np.array(lower, np.uint8)
            upper_bound = np.array(upper, np.uint8)
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
        color_map = {"red": (0, 0, 255), "green": (0, 255, 0), "blue": (255, 0, 0)}
        cv2.rectangle(imageFrame, (x, y), (x + w, y + h), color_map[color], 2)
        cv2.putText(imageFrame, f"{color.capitalize()} Object", (x, y - 10),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.8, color_map[color], 2)

    # Display the frame
    cv2.imshow("Color Detection", imageFrame)

    # Listen for user input
    key = cv2.waitKey(10) & 0xFF
    if key == ord('q'):  # Quit the program
        break
    elif key == ord('r'):  # Detect only Red
        selected_color = "red"
    elif key == ord('g'):  # Detect only Green
        selected_color = "green"
    elif key == ord('b'):  # Detect only Blue
        selected_color = "blue"
    elif key == ord('a'):  # Detect All Colors
        selected_color = "all"

# Cleanup
webcam.release()
cv2.destroyAllWindows()
