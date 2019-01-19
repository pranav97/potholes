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
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True)
    longitude = db.Column(db.Float, unique=False)
    latitude = db.Column(db.Float, unique=False)

    def __init__(self, username, longitude, latitude):
        self.username = username
        self.longitude = longitude
        self.latitude = latitude
      
# user schema
class UserSchema(ma.Schema):
    class Meta:
        fields = ('username', 'longitude', 'latitude')

user_schema = UserSchema()
users_schema = UserSchema(many=True)

# endpoint 
@app.route("/user", methods=["POST"])

def add_user():
    
    username = request.json['username']
    #longitude
    longitude = request.json['longitude']
    #latitude
    latitude = request.json['latitude']
    
    new_user = User(username, longitude, latitude)
        
    db.session.add(new_user)
    db.session.commit()
    return jsonify(new_user)


# endpoint to show all users
@app.route("/user", methods=["GET"])
def get_user():
    all_users = User.query.all()
    result = users_schema.dump(all_users)
    return jsonify(result.data)

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
    
    user.longitude = longitude
    user.latitude = latitude
    user.username = username
    

    db.session.commit()
    
    return user_schema.jsonify(user)

# endpoint to delete user
@app.route("/user/<id>", methods=["DELETE"])
def user_delete(id):
    user = User.query.get(id)
    db.session.delete(user)
    db.session.commit()

    return user_schema.jsonify(user)



if __name__ == '__main__':
    app.run(debug=True) 