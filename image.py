from flask import Flask, request, jsonify
import cv2
import pytesseract
import numpy as np
import os

app = Flask(__name__)

@app.route('/extract_text', methods=['POST'])
def extract_text():
    if 'image' not in request.files:
        print("No image file in request")
        return jsonify({"error": "No image file provided"}), 400
    
    file = request.files['image']
    print("Received file:", file.filename)
    file_path = os.path.join('/tmp', file.filename)
    file.save(file_path)
    print("Saved file to:", file_path)

    # Read and process the image
    img = cv2.imread(file_path)
    if img is None:
        print("Invalid image file")
        return jsonify({"error": "Invalid image file"}), 400
    
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    
    # Extract text from the image
    extracted_text = pytesseract.image_to_string(img_rgb, lang='rus')
    
    return jsonify({"extracted_text": extracted_text})


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in {'jpg', 'jpeg', 'png'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5008, debug=True)
