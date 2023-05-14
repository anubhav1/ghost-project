#!/bin/bash
su - ubuntu  
sudo apt-get update
sudo apt-get -y upgrade
sudo yum update -y

sudo yum -y install python-pip
sudo pip3 install flask

sudo cat << EOF > helloworld.py
#!/usr/bin/python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hello World!'

app.run(host='0.0.0.0', port=80)
EOF

sudo chmod 755 helloworld.py
sudo python3 helloworld.py