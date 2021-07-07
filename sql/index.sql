USE app;

CREATE TABLE IF NOT EXISTS `location` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(128) NOT NULL,
    `create_date` datetime NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `language` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `lang` varchar(128) NOT NULL,
    `create_date` datetime NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `company_group` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `create_date` datetime NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='다국적 기업들을 하나의 id 로 관리';

CREATE TABLE IF NOT EXISTS `company` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `group_id` int(11) NOT NULL,
    `name` varchar(128) NOT NULL,
    `loc_id` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    `modify_date` datetime,
    PRIMARY KEY (`id`),
    UNIQUE (`name`,`loc_id`),
    FOREIGN KEY (`group_id`) REFERENCES `company_group`(`id`),
    FOREIGN KEY (`loc_id`) REFERENCES `location`(`id`)
) ENGINE=InnoDB COMMENT='기업 정보';

CREATE TABLE IF NOT EXISTS `tag_group` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `create_date` datetime NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB COMMENT='다국어로 나뉜 태그들을 하나의 id 로 관리';

CREATE TABLE IF NOT EXISTS `tag` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `group_id` int(11) NOT NULL,
    `name` varchar(128) NOT NULL,
    `lang_id` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    `modify_date` datetime,
    PRIMARY KEY (`id`),
    UNIQUE (`name`,`lang_id`),
    FOREIGN KEY (`group_id`) REFERENCES `tag_group`(`id`),
    FOREIGN KEY (`lang_id`) REFERENCES `language`(`id`)
) ENGINE=InnoDB COMMENT='태그 정보';

CREATE TABLE IF NOT EXISTS `link_company_tag` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `tag_group_id` int(11) NOT NULL,
    `company_group_id` int(11) NOT NULL,
    `create_date` datetime NOT NULL,
    PRIMARY KEY (`id`),
    FOREIGN KEY (`company_group_id`) REFERENCES `company_group`(`id`),
    FOREIGN KEY (`tag_group_id`) REFERENCES `tag_group`(`id`)
) ENGINE=InnoDB COMMENT='기업-태그 매칭 정보';


# Insert Location data
INSERT INTO `location`
    (`name`, `create_date`)
VALUES
    ('ko', NOW()),
    ('en', NOW()),
    ('ja', NOW());

# Insert Language data
INSERT INTO `language`
    (`lang`, `create_date`)
VALUES
    ('ko', NOW()),
    ('en', NOW()),
    ('ja', NOW());

# Insert company group data
INSERT INTO `company_group`
    (`create_date`)
VALUES
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW());

# Insert Company data
INSERT INTO `company`
    (`group_id`, `name`, `loc_id`, `create_date`)
VALUES
    (1, '원티드랩', 1, NOW()), (1, 'Wantedlab', 2, NOW()),
    (2, 'OKAY.com', 2, NOW()),
    (3, '이상한마케팅', 1, NOW()),
    (4, '인포뱅크', 1, NOW()), (4, 'infobank', 2, NOW()),
    (5, '아이씨그룹', 1, NOW()),
    (6, '딤딤섬 대구점', 1, NOW()),
    (7, '파운데이션엑스', 1, NOW()),
    (8, '엣지랭크', 1, NOW()),
    (9, '커넥티어', 1, NOW()),
    (10, '자버(Jober)', 1, NOW()),
    (11, '앨리스헬스케어', 1, NOW()),
    (12, '(주)몬스터스튜디오', 1, NOW()),
    (13, 'SM Entertainment Japan', 1, NOW()),
    (13, '株式会社SM Entertainment Japan', 3, NOW()),
    (14, '쿠차', 1, NOW()),
    (15, 'ZMP', 1, NOW()), (15, '株式会社ZMP', 3, NOW()),
    (16, '몽키랩', 1, NOW()),
    (17, '와이케이비앤씨', 1, NOW()),
    (18, '코츠테크놀로지', 1, NOW()),
    (19, '비고라이브', 1, NOW()),
    (20, '크로싱', 1, NOW()),
    (21, '트리노드', 1, NOW()),
    (22, '와이즈키즈(wisekids)', 1, NOW()),
    (23, 'Obelab', 1, NOW()),
    (24, 'Foodpanda', 2, NOW()),
    (25, '웹티즌', 1, NOW()),
    (26, '마이셀럽스', 1, NOW()),
    (27, '데이터얼라이언스(DataAlliance)', 1, NOW()),
    (28, '쿼드자산운용', 1, NOW()), (28, 'QuadAsset', 2, NOW()),
    (29, '주식회사 링크드코리아', 1, NOW()),
    (30, '주렁주렁(zoolungzoolung)', 1, NOW()),
    (31, 'Amore Pacific_TEST', 2, NOW()),
    (32, 'Luna Marketing Group', 2, NOW()),
    (33, '동신항운', 1, NOW()),
    (34, '히숲', 1, NOW()),
    (35, 'COVENANT', 1, NOW()), (35, 'COVENANT', 2, NOW()),
    (36, '젠틀파이', 1, NOW()),
    (37, '아크로고스', 1, NOW()),
    (38, '페르소나미디어', 1, NOW()), (38, 'Persona Media', 2, NOW()),
    (39, 'Rejoice Pregnancy', 2, NOW()),
    (40, 'The Wave', 2, NOW()),
    (41, 'CoCoon Foundation', 2, NOW()),
    (42, '스트라다월드와이드(Strada)', 1, NOW()),
    (43, '도빗(Dobbit)', 1, NOW()),
    (44, '지란지교시큐리티', 1, NOW()),
    (45, '캠퍼스멘토', 1, NOW()),
    (46, '삼일제약', 1, NOW()),
    (47, '제이에이치개발', 1, NOW()),
    (48, '오케이코인코리아', 1, NOW()),
    (49, '그릿연구소', 1, NOW()),
    (50, '세계정부 世界政府', 1, NOW()),
    (51, '투게더앱스', 1, NOW()),
    (52, 'Dream Agility', 1, NOW()),
    (52, 'Dream Agility', 2, NOW()),
    (53, '대성시스템', 1, NOW()),
    (54, '바이럴네이션', 1, NOW()),
    (55, '오가나셀', 1, NOW()),
    (56, '디토나인', 1, NOW()),
    (57, 'Haulio', 2, NOW()),
    (58, '대상홀딩스(주) - existing', 1, NOW()),
    (59, '만나씨이에이', 1, NOW()),
    (60, '지오코리아(페루관광청)', 1, NOW()), (60, 'GEOCM Co.', 2, NOW()), (60, 'GEOCM', 3, NOW()),
    (61, 'KFC Korea', 1, NOW());

# Insert tag group data
INSERT INTO `tag_group`
    (`create_date`)
values
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW()),
    (NOW()), (NOW()), (NOW()), (NOW()), (NOW());

# Insert Tag data
INSERT INTO `tag`
    (`group_id`, `name`, `lang_id`, `create_date`)
VALUES
    (1, '태그_1', 1, NOW()), (1, 'tag_1', 2, NOW()), (1, 'タグ_1', 3, NOW()),
    (2, '태그_2', 1, NOW()), (2, 'tag_2', 2, NOW()), (2, 'タグ_2', 3, NOW()),
    (3, '태그_3', 1, NOW()), (3, 'tag_3', 2, NOW()), (3, 'タグ_3', 3, NOW()),
    (4, '태그_4', 1, NOW()), (4, 'tag_4', 2, NOW()), (4, 'タグ_4', 3, NOW()),
    (5, '태그_5', 1, NOW()), (5, 'tag_5', 2, NOW()), (5, 'タグ_5', 3, NOW()),
    (6, '태그_6', 1, NOW()), (6, 'tag_6', 2, NOW()), (6, 'タグ_6', 3, NOW()),
    (7, '태그_7', 1, NOW()), (7, 'tag_7', 2, NOW()), (7, 'タグ_7', 3, NOW()),
    (8, '태그_8', 1, NOW()), (8, 'tag_8', 2, NOW()), (8, 'タグ_8', 3, NOW()),
    (9, '태그_9', 1, NOW()), (9, 'tag_9', 2, NOW()), (9, 'タグ_9', 3, NOW()),
    (10, '태그_10', 1, NOW()), (10, 'tag_10', 2, NOW()), (10, 'タグ_10', 3, NOW()),
    (11, '태그_11', 1, NOW()), (11, 'tag_11', 2, NOW()), (11, 'タグ_11', 3, NOW()),
    (12, '태그_12', 1, NOW()), (12, 'tag_12', 2, NOW()), (12, 'タグ_12', 3, NOW()),
    (13, '태그_13', 1, NOW()), (13, 'tag_13', 2, NOW()), (13, 'タグ_13', 3, NOW()),
    (14, '태그_14', 1, NOW()), (14, 'tag_14', 2, NOW()), (14, 'タグ_14', 3, NOW()),
    (15, '태그_15', 1, NOW()), (15, 'tag_15', 2, NOW()), (15, 'タグ_15', 3, NOW()),
    (16, '태그_16', 1, NOW()), (16, 'tag_16', 2, NOW()), (16, 'タグ_16', 3, NOW()),
    (17, '태그_17', 1, NOW()), (17, 'tag_17', 2, NOW()), (17, 'タグ_17', 3, NOW()),
    (18, '태그_18', 1, NOW()), (18, 'tag_18', 2, NOW()), (18, 'タグ_18', 3, NOW()),
    (19, '태그_19', 1, NOW()), (19, 'tag_19', 2, NOW()), (19, 'タグ_19', 3, NOW()),
    (20, '태그_20', 1, NOW()), (20, 'tag_20', 2, NOW()), (20, 'タグ_20', 3, NOW()),
    (21, '태그_21', 1, NOW()), (21, 'tag_21', 2, NOW()), (21, 'タグ_21', 3, NOW()),
    (22, '태그_22', 1, NOW()), (22, 'tag_22', 2, NOW()), (22, 'タグ_22', 3, NOW()),
    (23, '태그_23', 1, NOW()), (23, 'tag_23', 2, NOW()), (23, 'タグ_23', 3, NOW()),
    (24, '태그_24', 1, NOW()), (24, 'tag_24', 2, NOW()), (24, 'タグ_24', 3, NOW()),
    (25, '태그_25', 1, NOW()), (25, 'tag_25', 2, NOW()), (25, 'タグ_25', 3, NOW()),
    (26, '태그_26', 1, NOW()), (26, 'tag_26', 2, NOW()), (26, 'タグ_26', 3, NOW()),
    (27, '태그_27', 1, NOW()), (27, 'tag_27', 2, NOW()), (27, 'タグ_27', 3, NOW()),
    (28, '태그_28', 1, NOW()), (28, 'tag_28', 2, NOW()), (28, 'タグ_28', 3, NOW()),
    (29, '태그_29', 1, NOW()), (29, 'tag_29', 2, NOW()), (29, 'タグ_29', 3, NOW());

# Insert link between Company and Tag data
INSERT INTO `link_company_tag`
    (`company_group_id`, `tag_group_id`, `create_date`)
VALUES
    (1, 4, NOW()), (1, 16, NOW()), (1, 20, NOW()), (2, 24, NOW()), (2, 27, NOW()),
    (2, 4, NOW()), (3, 25, NOW()), (3, 6, NOW()), (3, 14, NOW()), (3, 9, NOW()),
    (4, 25, NOW()), (5, 1, NOW()), (5, 23, NOW()), (5, 28, NOW()), (5, 14, NOW()),
    (6, 22, NOW()), (6, 29, NOW()), (6, 2, NOW()), (6, 13, NOW()), (7, 8, NOW()),
    (8, 5, NOW()), (8, 11, NOW()), (8, 26, NOW()), (8, 1, NOW()), (9, 11, NOW()),
    (9, 21, NOW()), (10, 2, NOW()), (10, 12, NOW()), (10, 16, NOW()), (11, 13, NOW()),
    (11, 5, NOW()), (11, 12, NOW()), (12, 19, NOW()), (13, 23, NOW()), (13, 11, NOW()),
    (13, 15, NOW()), (14, 27, NOW()), (14, 5, NOW()), (14, 26, NOW()), (15, 10, NOW()),
    (15, 2, NOW()), (15, 21, NOW()), (15, 24, NOW()), (16, 7, NOW()), (16, 23, NOW()),
    (16, 28, NOW()), (17, 14, NOW()), (17, 29, NOW()), (17, 6, NOW()), (18, 12, NOW()),
    (18, 2, NOW()), (19, 13, NOW()), (19, 19, NOW()), (20, 21, NOW()), (20, 30, NOW()),
    (20, 12, NOW()), (20, 28, NOW()), (21, 7, NOW()), (21, 19, NOW()), (21, 12, NOW()),
    (21, 17, NOW()), (22, 1, NOW()), (22, 9, NOW()), (22, 17, NOW()), (22, 14, NOW()),
    (23, 6, NOW()), (24, 26, NOW()), (25, 28, NOW()), (25, 25, NOW()), (25, 13, NOW()),
    (26, 2, NOW()), (26, 8, NOW()), (26, 22, NOW()), (26, 27, NOW()), (27, 27, NOW()),
    (28, 27, NOW()), (28, 6, NOW()), (28, 11, NOW()), (29, 29, NOW()), (30, 3, NOW());