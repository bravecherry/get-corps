import sys
sys.path.insert(1, '/home/api')
from flask import request, jsonify
from api.db import *

@app.route('/search/company')
def search_company():
    search = "%{}%".format(request.args.get('name'))
    companies = Company.query.filter(Company.name.like(search)).all()

    res = []
    for company in companies:
        if company.to_dict() not in res:
            res.append(company.to_dict())

    return jsonify(res)

@app.route('/search/tag')
def search_tag():
    search = "%{}%".format(request.args.get('name'))
    tags = Tag.query.filter(Tag.name.like(search)).all()

    res = []
    for tag in tags:
        lct = LinkCompanyTag.query.filter_by(tag_group_id=tag.group_id).all()

        for l in lct:
            company = Company.query.filter_by(group_id=l.company_group_id).first()

            if company.to_dict() not in res:
                res.append(company.to_dict())

    return jsonify(res)

@app.route('/add/tag', methods = ['POST'])
def add_tag():
    tag_group_id = request.form.get('group_id')
    name = request.form.get('name')
    lang = request.form.get('lang')
    companies = request.form.get('companies')

    # 기존 태그 그춥에 추가하지 않고 새로운 태그 그룹을 생성하는 경우
    if not tag_group_id:
        db.session.add(TagGroup())
        tag_group = TagGroup.query.order_by(TagGroup.id.desc()).first()
        tag_group_id = tag_group.id

    lang = Language.query.filter_by(lang=lang).first()

    # 태그 데이터 추가
    tag = Tag(group_id=tag_group_id, name=name, lang_id=lang.id)
    db.session.add(tag)

    # 태그-기업 정보 추가
    companies = companies.split(',')
    for company_id in companies:
        company = Company.query.filter_by(id=company_id).first()
        db.session.add(LinkCompanyTag(tag_group_id=tag_group_id, company_group_id=company.id))

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
