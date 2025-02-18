from flask import Flask, request, jsonify
import numpy as np
import cv2

app = Flask(__name__)

# Initialize webcam
webcam = cv2.VideoCapture(0)

# Define color ranges
color_ranges = {
    "red": ([136, 87, 111], [180, 255, 255]),
    "green": ([25, 52, 72], [102, 255, 255]),
    "blue": ([94, 80, 2], [120, 255, 255]),
    "neon_green": ([60, 150, 100], [75, 255, 255]),  
    "neon_pink": ([145, 50, 100], [160, 255, 255]),  
    "neon_blue": ([110, 50, 100], [125, 255, 255]),  
    "neon_yellow": ([30, 150, 100], [40, 255, 255]),  
    "neon_orange": ([15, 150, 100], [25, 255, 255]),  
    "neon_purple": ([130, 50, 100], [150, 255, 255])  
}

@app.route('/detect_color', methods=['POST'])
def detect_color():
    """ Detects a color in a webcam frame """
    data = request.get_json()
    selected_color = data.get("color", "all")  

    ret, imageFrame = webcam.read()
    if not ret:
        return jsonify({"error": "Failed to capture image"}), 500

    hsvFrame = cv2.cvtColor(imageFrame, cv2.COLOR_BGR2HSV)
    detected_colors = []

    kernel = np.ones((5, 5), np.uint8)

    for color, (lower, upper) in color_ranges.items():
        if selected_color == "all" or selected_color == color:
            lower_bound = np.array(lower, np.uint8)
            upper_bound = np.array(upper, np.uint8)
            mask = cv2.inRange(hsvFrame, lower_bound, upper_bound)
            mask = cv2.dilate(mask, kernel)

            contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
            if contours:
                detected_colors.append(color)

    return jsonify({"detected_colors": detected_colors})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=True)
