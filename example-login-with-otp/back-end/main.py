import uuid, random, time
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
app.secret_key = 'your_secret_key'
CORS(app)

def get_generated_token():
    try:
        with open('./store/generated_token', "r") as file:
            value = file.read()
        return value
    except FileNotFoundError:
        return None

def set_generated_token(value):
    with open('./store/generated_token', "w") as file:
        file.write(value)

def get_generated_otp():
    try:
        with open('./store/generated_otp', "r") as file:
            value = file.read()
        return value
    except FileNotFoundError:
        return None

def set_generated_otp(value):
    with open('./store/generated_otp', "w") as file:
        file.write(value)

@app.route('/login', methods=['POST'])
def login():
    time.sleep(1)
    data = request.get_json()
    print(f"{request.url} - request: ", data)
    username = data.get('username')
    password = data.get('password')
    if username == 'admin' and password == 'password':
        set_generated_token(str(uuid.uuid4()))
        set_generated_otp(str(random.randint(100000, 999999)))
        response = {
            "data": {
                "otpToken": get_generated_token()
            }
        }
        print(f"{request.url} - response: ", response)
        return jsonify(response)
    else:
        print(f"{request.url} - response: ", "error")
        return jsonify({"error": "Invalid username or password"}), 401

@app.route('/get-otp', methods=['POST'])
def get_otp():
    time.sleep(1)
    data = request.get_json()
    print(f"{request.url} - request: ", data)
    token = data.get('otpToken')
    if token == get_generated_token():
        response = {
            "data": {
                "otp": get_generated_otp()
            }
        }
        print(f"{request.url} - response: ", response)
        return jsonify(response)
    else:
        print(f"{request.url} - response: ", "error")
        return jsonify({"error": "Token not found"}), 404

@app.route('/verify-otp', methods=['POST'])
def verify_otp():
    time.sleep(1)
    data = request.get_json()
    print(f"{request.url} - request: ", data)
    otp = data.get('otp')
    if otp == get_generated_otp():
        response = {
            "data": {
                "success": True
            }
        }
        print(f"{request.url} - response: ", response)
        return jsonify(response)
    else:
        print(f"{request.url} - response: ", "error")
        return jsonify({"error": "Token not found"}), 404

if __name__ == '__main__':
    app.run(debug=True)
