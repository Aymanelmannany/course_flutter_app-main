from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
CORS(app)

# Config SQLite
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///courses.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Model
class Course(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    code = db.Column(db.String(20), nullable=False)
    description = db.Column(db.String(200), nullable=False)
    ects = db.Column(db.Integer, nullable=False)

    def to_dict(self):
        return {
            "id": str(self.id),
            "title": self.title,
            "code": self.code,
            "description": self.description,
            "ects": self.ects
        }

# Routes
@app.route('/courses', methods=['GET'])
def get_courses():
    courses = Course.query.all()
    return jsonify([c.to_dict() for c in courses])

@app.route('/courses', methods=['POST'])
def create_course():
    data = request.json
    required_fields = ['title', 'code', 'description', 'ects']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    new_course = Course(
        title=data['title'],
        code=data['code'],
        description=data['description'],
        ects=data['ects']
    )
    db.session.add(new_course)
    db.session.commit()

    return jsonify(new_course.to_dict()), 201

@app.route('/courses/<int:id>', methods=['PUT'])
def update_course(id):
    course = Course.query.get(id)
    if not course:
        return jsonify({"error": "Course not found"}), 404

    data = request.json
    for field in ['title', 'code', 'description', 'ects']:
        if field in data:
            setattr(course, field, data[field])
    db.session.commit()
    return jsonify(course.to_dict())

@app.route('/courses/<int:id>', methods=['DELETE'])
def delete_course(id):
    course = Course.query.get(id)
    if not course:
        return jsonify({"error": "Course not found"}), 404

    db.session.delete(course)
    db.session.commit()
    return '', 204

if __name__ == '__main__':
    with app.app_context():
        db.create_all()  # Crée la DB si elle n'existe pas
    app.run(host='0.0.0.0', port=3200, debug=True)
