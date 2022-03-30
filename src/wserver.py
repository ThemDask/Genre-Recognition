import json

from flask import request

from flask import Flask, render_template

app = Flask(__name__)

@app.route('/') 
def index():
    return render_template('/index.html') #create connection with html index


@app.route('/test', methods=['POST'])
def test():
    output = request.get_json()
    result = json.loads(output) #converts the json output to a python dictionary
    print("the song name is: ", result["mysong"]) #Printing the new dictionary
    
    return result


