import sys
sys.path.insert(1, '/home/api/')
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+cymysql://admin:NuMc3kEsrVSa3YN8@localhost/app'
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


@app.route('/search/company/')
def search_company():
    search = "%{}%".format(request.args.get('name'))
    companies = Company.query.filter(Company.name.like(search)).all()

    res = []
    for company in companies:
        if company.to_dict() not in res:
            res.append(company.to_dict())

    return jsonify(res)

@app.route('/search/tag/')
def search_tag():
    search = "%{}%".format(request.args.get('tag'))
    tags = Tag.query.filter(Tag.name.like(search)).all()

    res = []
    for tag in tags:
        lct = LinkCompanyTag.query.filter_by(tag_group_id=tag.group_id).all()

        for l in lct:
            company = Company.query.filter_by(group_id=l.company_group_id).first()

            if company.to_dict() not in res:
                res.append(company.to_dict())

    return jsonify(res)

@app.route('/add/tag/', methods = ['POST'])
def add_tag():
    group_id = request.form.get('group_id')
    name = request.form.get('name')
    lang = request.form.get('lang')
    companies = request.form.get('companies')

    if not group_id:
        db.session.add(TagGroup())
        tag_group = TagGroup.query.order_by(TagGroup.id.desc()).first()
        group_id = tag_group.id

    lang = Language.query.filter_by(lang=lang).first()

    tag = Tag(group_id=group_id, name=name, lang_id=lang.id)
    db.session.add(tag)

    companies = companies.split(',')
    for company_id in companies:
        company = Company.query.filter_by(id=company_id).first()
        db.session.add(LinkCompanyTag(tag_group_id=group_id, company_group_id=company.id))

    db.session.commit()

    return jsonify(tag.to_dict())

@app.route('/delete/tag/<tag_group_id>', methods = ['DELETE'])
def delete_tag(tag_group_id):
    tag_group = TagGroup.query.filter_by(id=tag_group_id).first()
    lct = LinkCompanyTag.query.filter_by(tag_group_id=tag_group_id).all()
    tag = Tag.query.filter_by(group_id=tag_group_id).all()

    for l in lct:
        db.session.delete(l)

    tags = []
    for t in tag:
        tags.append(t.to_dict())
        db.session.delete(t)

    db.session.delete(tag_group)
    db.session.commit()

    return jsonify(tags)
