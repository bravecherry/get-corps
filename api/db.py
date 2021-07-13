from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+cymysql://admin:NuMc3kEsrVSa3YN8@mysql_db/app'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class CompanyGroup(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def __repr__(self):
        return '<CompanyGroup %r>' % self.id

class Company(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    group_id = db.Column(db.Integer, db.ForeignKey('company_group.id'), nullable=False)
    name = db.Column(db.String(128), nullable=False)
    loc_id = db.Column(db.Integer, db.ForeignKey('location.id'), nullable=False)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    modify_date = db.Column(db.DateTime, default=datetime.utcnow)
    location = db.relationship('Location', backref=db.backref('company', lazy=True))
    company_group = db.relationship('CompanyGroup', backref=db.backref('company', lazy=True))

    def __repr__(self):
        return '<Company %r>' % self.name

    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class TagGroup(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def __repr__(self):
        return '<TagGroup %r>' % self.id

    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class Tag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    group_id = db.Column(db.Integer, db.ForeignKey('tag_group.id'), nullable=False)
    name = db.Column(db.String(128), nullable=False)
    lang_id = db.Column(db.Integer, db.ForeignKey('language.id'), nullable=False)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    modify_date = db.Column(db.DateTime, default=datetime.utcnow)
    language = db.relationship('Language', backref=db.backref('tag', lazy=True))
    tag_group = db.relationship('TagGroup', backref=db.backref('tag', lazy=True))

    def __repr__(self):
        return '<Tag %r>' % self.name

    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class LinkCompanyTag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    company_group_id = db.Column(db.Integer, db.ForeignKey('company_group.id'), nullable=False)
    tag_group_id = db.Column(db.Integer, db.ForeignKey('tag_group.id'), nullable=False)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    company_group = db.relationship('CompanyGroup', backref=db.backref('link_company_tag', lazy=True))
    tag_group = db.relationship('TagGroup', backref=db.backref('link_company_tag', lazy=True))

    def __repr__(self):
        return '<LinkCompanyTag %r %r>' % (self.company_group_id, self.tag_group_id)

class Location(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), unique=True, nullable=False)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def __repr__(self):
        return '<Location %r>' % self.name

class Language(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    lang = db.Column(db.String(128), unique=True, nullable=False)
    create_date = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)

    def __repr__(self):
        return '<Language %r>' % self.lang
