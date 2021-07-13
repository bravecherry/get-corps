# get-corps
기업 명칭과 태그 정보를 검색하는 기능의 RESTful API 를 개발했습니다. 

## API 제 기능
API 에서 제공하는 기능은 다음과 같습니다. 
* 기업 검색 기능 - 기업 명칭 검색, 연관 검색 기능 제공
  <pre>GET /search/company?name=[search]</pre>
* 태그 검색 기능 - 태그를 통한 연관 기업 검색
  <pre>GET /search/tag?name=[search]</pre>
* 태그 추가 기능 
  <pre>POST /add/tag -d 'name=[tag]&lang=[en/ko/ja]&companies=[company_group_id1],[company_group_id2],[company_group_id3]'</pre>
* 태그 삭제 기능
  <pre>DELETE /delete/tag/[tag_group_id]</pre>

## 사용법
### container 생성
<pre>
$ cd get-corps
$ docker-compose up -d --build
</pre>

## 환경 
기능은 Docker compose 를 사용하여 컨테이너 환경에서 테스트해 볼 수 있도록 개발했습니다.
AlpineOS 환경에서 백엔드 소스가 위치하는 api 서비스와 MysqlDB 가 위치한 mysql_db 서비스로 이미지를 분리 생성했습니다. 

그리고 api 서비스는 5000 포트가, mysql_db 서비스는 3306 포트가 외부와 매핑되어 있습니다. 

## 소프트웨어
개발 작업은 Python Flask Framework를 활용하여 작업했습니다. 
추가로 Flask-SQLAlchemy, MySQLDB를 사용하여 ORM 및 DB 환경을 구축했습니다. 

## DB 설계 
DB 는 app database 를 생성하여 주어진 데이터를 토대로 총 7개의 테이블을 생성했습니다. 
설계 시 단일 테이블에 연관 데이터를 함께 저장하여 관리하기보다는 언어 등 확장성을 고려하여 언어와 위치를 기준으로 데이터를 분리하여 저장하고자 했습니다.

우선 기업 정보 관련하여 기업의 주소지를 기준으로 하여 데이터를 저장하는 company 테이블, 동일 기업 내 기업 데이터를 관리할 수 있는 company_group 테이블을 생성했습니다. 

태그 관련해서도 언어를 기준으로 하여 데이터를 저장하는 tag 테이블과 태그 데이터들을 관리하는 tag_group 테이블을 생성했습니다. 

그리고 기업과 태그 데이터를 매칭시켜주는 link_company_tag 테이블을 생성해서 기업과 태그 데이터를 별도로 관리하고자 했습니다. 

마지막으로 기업의 위치와 언어의 값을 저장하는 location과 language 테이블을 생성하여 company 와 tag 테이블에서 활용하도록 했습니다. 

* company_group Table  
: 1개 이상의 동일 기업들을 하나의 id 로 관리
  
| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| create_date   | datetime NOT NULL |

* company Table  
: 기업 데이터 

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| group_id   | int(11) NOT NULL        |
| name   | varchar(128) NOT NULL        |
| loc_id   | int(11) NOT NULL        |
| create_date   | datetime NOT NULL |
| modify_date   | datetime        |

* tag_group Table  
: 다국어로 나뉜 태그들을 하나의 id 로 관리

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| create_date   | datetime NOT NULL |

* tag Table  
: 태그 데이터  

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| group_id   | int(11) NOT NULL        |
| name   | varchar(128) NOT NULL        |
| lang_id   | int(11) NOT NULL        |
| create_date   | datetime NOT NULL |
| modify_date   | datetime        |

* link_company_tag Table  
: 기업과 태그 데이터를 매칭하여 관리

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| tag_group_id   | int(11) NOT NULL        |
| company_group_id   | int(11) NOT NULL        |
| create_date   | datetime NOT NULL |

* location Table  
: 리전 정보 

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| name   | varchar(128) NOT NULL        |
| create_date   | datetime NOT NULL |

* language Table  
: 언어 정보 

| Column      | Types                     |
| ----------- | -----------------------    |
| id      | int(11) NOT NULL |
| lang   | varchar(128) NOT NULL        |
| create_date   | datetime NOT NULL |

