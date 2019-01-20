#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 19 02:14:36 2019

@author: jeremytan
"""

from flask import Flask, request, jsonify 
from flask_sqlalchemy import SQLAlchemy 
from flask_marshmallow import Marshmallow 
import os
        


app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'crud.sqlite')

db = SQLAlchemy(app)
ma = Marshmallow(app)

# user model
class Issue(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    types = db.Column(db.String(80), unique=False)
    longitude = db.Column(db.Float, unique=False)
    latitude = db.Column(db.Float, unique=False)
    severity = db.Column(db.Integer, unique=False)

    def __init__(self, types, longitude, latitude, severity):
        self.types = types
        self.longitude = longitude
        self.latitude = latitude
        self.severity = severity
      
# user schema
class IssueSchema(ma.Schema):
    class Meta:
        fields = ('types', 'longitude', 'latitude', 'severity')

issue_schema = IssueSchema(many=True)

#main page
@app.route("/")
def main_page():
    return ""

# endpoint 
@app.route("/issues", methods=["POST"])

def add_issue():
    
    types = request.json['types']
    #longitude
    longitude = request.json['longitude']
    #latitude
    latitude = request.json['latitude']
    #severity
    severity = request.json['severity']
    
    new_issue = Issue(types, longitude, latitude, severity)
        
    db.session.add(new_issue)
    db.session.commit()
    
    return str(new_issue)


# endpoint to show all users
@app.route("/all_issues", methods=["GET", "POST"])
def get_issue():
    longitude = float(request.json['longitude'])
    latitude =  float(request.json['latitude'])
    radius =    float(request.json['radius'])
    
    lower_y = latitude - radius 
    upper_y = latitude + radius 
    lower_x = longitude - radius 
    upper_x = longitude + radius 
    
    all_issues = Issue.query.filter(Issue.longitude > lower_x, Issue.longitude < upper_x, Issue.latitude > lower_y, Issue.latitude < upper_y)
    result = issue_schema.dump(all_issues)
    return jsonify(result.data)

@app.route("/get_all", methods=["GET"])
def get_all():
    all_issues = Issue.query.all()
    result = issue_schema.dump(all_issues)
    return jsonify(result.data)

"""

# endpoint to get user detail by id
@app.route("/user/<id>", methods=["GET"])
def user_detail(id):
    user = User.query.get(id)
    return user_schema.jsonify(user)

# endpoint to update user
@app.route("/user/<id>", methods=["PUT"])
def user_update(id):
    user = User.query.get(id)
    username = request.json['username']
    longitude = request.json['longitude']
    latitude  = request.josn['latitude']
    severity = request.json['severity']
    
    user.longitude = longitude
    user.latitude = latitude
    user.username = username
    user.severity = severity
    
    db.session.commit()
    
    return user_schema.jsonify(user)

# endpoint to delete user
@app.route("/user/<id>", methods=["DELETE"])
def user_delete(id):
    user = User.query.get(id)
    db.session.delete(user)
    db.session.commit()

    return user_schema.jsonify(user)
"""

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80) 
