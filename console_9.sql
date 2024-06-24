
-- 1. 질문 하기 리스트 쿼리
-- 검색 조건 : 기간, 페이징
-- where 1=1 넣지 말라고 !!
select
    BN.uid,
    BN.isUse,
    BN.boardType,
    BN.subject,
    BN.createdAt,
    BN.topOrder, -- 상단 고정
    BC.name
from BoardNotice as BN
left join BoardCategory as BC on BN.boardCategoryUid = BC.uid
where
    BN.boardType = 'FAQ'
    and BN.isUse = true
    and BN.isDel = 0  -- 선택 삭제가 되지 않은 애들
    and BN.boardCategoryUid =  1; -- 카테고리
--    and BN.subject like '%이용%'
--     and date_format(BN.createdAt,'%Y-%m-%d')  Between date_format('2024-03-01','%Y-%m-%d')  and date_format('2024-04-16','%Y-%m-%d')
-- limit 1 offset 1 ;  -- limit perpage  offset page
-- order by BN.uid desc


SELECT *
FROM BoardNotice
         LEFT JOIN BoardCategory ON (BoardCategory.uid = BoardNotice.boardCategoryUid);



SELECT BoardNotice.uid,
       BoardNotice.boardCategoryUid,
       BoardNotice.topOrder,
       BoardNotice.boardType,
       BoardNotice.subject,
       BoardNotice.contents,
       BoardNotice.isUse,
       BoardNotice.isDel,
       BoardNotice.writerSeq,
       BoardNotice.userIp,
       BoardNotice.updatedAt,
       BoardNotice.createdAt,
       BoardCategory.uid,
       BoardCategory.boardType,
       BoardCategory.`order`,
       BoardCategory.`name`,
       BoardCategory.isUse,
       BoardCategory.isDel,
       BoardCategory.writerSeq,
       BoardCategory.userIP,
       BoardCategory.updatedAt,
       BoardCategory.createdAt
FROM BoardNotice
         LEFT JOIN BoardCategory ON (BoardCategory.uid = BoardNotice.boardCategoryUid)
WHERE (BoardNotice.boardType = 'FAQ')
  AND (BoardNotice.isUse = TRUE)
  AND (BoardNotice.isDel = FALSE)
  AND (BoardNotice.createdAt BETWEEN '2024-04-01' AND '2024-06-01')
ORDER BY BoardNotice.uid DESC
LIMIT 10;

select *
from BoardNotice;





-- 2. 사용 , 미사용 상태 변경 쿼리
    update BoardNotice
    set isUse = 1
    where uid = 4;
-- 2.1 선택 삭제 : isDel 값 update
    update BoardNotice
    set isDel = 0
    where uid = 4;

select *
from BoardNotice;



delete from BoardNotice
where uid in (11,12);


select *
from BoardCategory;

select *
from BoardNotice;

-- 3. 게시물 등록 쿼리 , default 값 :  uid=autokey, isDel =0, writerSeq = 0 ,
    insert into BoardNotice (
        boardCategoryUid,
        topOrder,
        boardType,
        subject,
        contents,
        isUse,
        isDel,
        writerSeq,
        userIp,
        updatedAt,
        createdAt)
    values(
           2,
           1,
           'FAQ',
           '테스트게시물',
           '테스트 게시물 입니다.',
           0,
           0,
           0,
           '127.0.0.1',
           now(),
           now()
          );

-- 4. 게시물 상세 조회 ,uid로 조회
    SELECT
        BN.topOrder,
        BN.boardCategoryUid,
        BC.name,
        BN.isUse,
        BN.subject,
        BN.contents
    FROM BoardNotice AS BN
    LEFT JOIN BoardCategory AS BC ON BN.boardCategoryUid = BC.uid
    WHERE BN.uid = 6 and BC.isDel = false
    limit  1;


SELECT BoardNotice.uid,
       BoardNotice.boardCategoryUid,
       BoardNotice.topOrder,
       BoardNotice.boardType,
       BoardNotice.subject,
       BoardNotice.contents,
       BoardNotice.isUse,
       BoardNotice.isDel,
       BoardNotice.writerSeq,
       BoardNotice.userIp,
       BoardNotice.updatedAt,
       BoardNotice.createdAt,
       BoardCategory.uid,
       BoardCategory.boardType,
       BoardCategory.`order`,
       BoardCategory.`name`,
       BoardCategory.isUse,
       BoardCategory.isDel,
       BoardCategory.writerSeq,
       BoardCategory.userIP,
       BoardCategory.updatedAt,
       BoardCategory.createdAt
FROM BoardNotice
         LEFT JOIN BoardCategory ON (BoardCategory.uid = BoardNotice.boardCategoryUid)
WHERE (BoardNotice.uid = 7)
  AND (BoardNotice.isDel = FALSE)
LIMIT 1;




-- 5. 게시물 수정 쿼리
-- 수정에 포함 되는 범주  :  상단 고정, 분류, 상태, 제목 , 내용
    update BoardNotice
    set
        topOrder = 0,
        boardCategoryUid = 1,
        isUse = 1,
        subject = '수정테스트' , -- null 일 수 없고
        contents = '수정 수정 ', -- null 가능
        updatedAt = now()
    where uid = 6;


select *
from BoardNotice;

-- 6. 분류 항목 조회 , isDel 이 0 인 애들
    select
        BC.name,
        BC.uid
    from BoardCategory as BC
    where BC.isDel = false and   boardType = 'FAQ';

-- 7. 분류 추가 -- order :  분류 순번  default : 0
    insert into BoardCategory (
        boardType, -- M
        `order`,
        name,
        isUse,
        isDel,
        writerSeq,
        userIP,
        updatedAt,
        createdAt
    ) values (
        'FAQ',
        0,
        '테스트 분류',
        1,
        0,
        '',
        '127.0.0.1',
        now(), -- default
        now()  -- default
    );

select *
from BoardCategory;

select *
from BoardNotice;



-- 다건 수정 / 삭제
-- 삭제 /수정 완료시 success : true 로 올 수 잇게 해주기  저장을 누르는 순간 해당 내역 반영
-- 8.분류 수정 쿼리  --> 카테 고리 분류 편집 쿼리
    update BoardCategory
        set name ='분류121'
    where uid = 7 and boardType = 'FAQ';

-- 9. 분류 삭제 --> 다건에 해당
    update BoardCategory
        set isDel = 1
    where uid = 7 and boardType = 'FAQ';
--
select *
from BoardCategory;

-- 문의하기
select *
from BoardContactUs;

-- 10. 문의 내역 조회 리스트
select
    BU.seqUser,
    BU.isUse,
    BU.boardType,
    BU.name,
    BU.createdAt
from BoardContactUs as BU;

-- ID 검색 , 이름 검색은 모두 회원 테이블에서 검색 가능 하게 하기
select
    BU.seqUser,
    U.userId,
    BU.boardType,
    BU.subject,
    BU.createdAt
from BoardContactUs as BU
inner join User as U on BU.seqUser = U.seq
where
    BU.boardType = 'BULK_SEND';
  --  and BU.isUse = 1
  --  and BU.depth = 0 -- 답변이면 1에 해당
  --  and U.userId like '%ki%'
  --  and date_format(BU.createdAt,'%Y-%m-%d')  Between date_format('2024-04-01','%Y-%m-%d')  and date_format('2024-06-16','%Y-%m-%d')
  --  limit 1 offset 1 ;  -- limit perpage  offset page


-- 2024052215443011200000002

      select *
      from User
      where seq = '2024052215443011200000002';



 SELECT COUNT(*)
 FROM BoardContactUs INNER JOIN `User` ON  (BoardContactUs.seqUser = `User`.seq)
 WHERE (BoardContactUs.isUse = TRUE)
   AND (BoardContactUs.`depth` = 0)
  -- AND (BoardContactUs.boardType = 'API')
  -- AND (`User`.userId LIKE '%gonna%')
  -- AND (BoardContactUs.createdAt BETWEEN 2024-04-17 AND 2024-06-17) ;




select *
from User
where userId = '%ki';

-- 11. 문의 구분 조회
select
    DISTINCT boardType
from BoardContactUs;

select *
from BoardContactUs;

 SELECT COUNT(*)
 FROM BoardContactUs
     INNER JOIN `User` ON  (BoardContactUs.seqUser = `User`.seq)
 WHERE
     (BoardContactUs.isUse = 1)
    AND (BoardContactUs.`depth` = 0)
    AND (BoardContactUs.boardType = '')
    AND (`User`.userId LIKE '%gonna%');
  -- AND (BoardContactUs.createdAt BETWEEN 2024-01-01 AND 2024-06-01);
 SELECT *
 FROM BoardContactUs
     INNER JOIN `User` ON  (BoardContactUs.seqUser = `User`.seq);



SELECT
    BoardContactUs.uid,
    BoardContactUs.ownerUid,
    BoardContactUs.`depth`,
    BoardContactUs.boardType,
    BoardContactUs.seqUser,
    BoardContactUs.`name`,
    BoardContactUs.email,
    BoardContactUs.phone,
    BoardContactUs.subject,
    BoardContactUs.contents,
    BoardContactUs.isAnswer,
    BoardContactUs.isUse,
    BoardContactUs.isDel,
    BoardContactUs.userIP,
    BoardContactUs.updatedAt,
    BoardContactUs.createdAt,
    `User`.seq,
    `User`.companySeq,
    `User`.userId,
    `User`.password,
    `User`.`name`,
    `User`.email,
    `User`.cellPhone,
    `User`.loginFailCount,
    `User`.lastPasswordUpdatedAt,
    `User`.adServiceAgreeAt,
    `User`.isUse,
    `User`.userIP,
    `User`.ci,
    `User`.di,
    `User`.lastLoginToken,
    `User`.updatedAt,
    `User`.createdAt
FROM BoardContactUs INNER JOIN `User` ON  (BoardContactUs.seqUser = `User`.seq)
WHERE (BoardContactUs.isUse = TRUE)
  AND (BoardContactUs.`depth` = 0)
  AND (BoardContactUs.boardType = 'API')
  AND (`User`.userId LIKE '%k%')
  AND (BoardContactUs.createdAt BETWEEN 2024-01-01 AND 2024-06-01)
ORDER BY BoardContactUs.uid DESC LIMIT 10;



select *
from BoardContactUs;

SELECT
       BoardContactUs.isUse,
       BoardContactUs.depth,
       User.userId,
       boardType,
       BoardContactUs.createdAt
FROM BoardContactUs
         INNER JOIN `User` ON (BoardContactUs.seqUser = `User`.seq);

SELECT
    BoardContactUs.isUse,
       BoardContactUs.depth,
       User.userId,
       boardType,
       BoardContactUs.createdAt
FROM BoardContactUs
         INNER JOIN `User` ON (BoardContactUs.seqUser = `User`.seq)
 WHERE
 --   (BoardContactUs.isUse = TRUE)
 --    AND BoardContactUs.isDel = false
 -- AND (BoardContactUs.`depth` = 0)
   (BoardContactUs.createdAt BETWEEN '2023-01-01' AND '2024-06-01')
ORDER BY BoardContactUs.uid DESC
LIMIT 100;



-- 12. 문의 내역 상세 조회
-- 답글은 그냥 조인 하지 말고 노출 해야 되는 문제
--  작성자  : 관리자 이름 , seq -> 관리자 시퀀스 -> 관리자 로그인한 사람 : 2024052215443011200000002 , name : 관리자 이름 , 이메일, 핸드폰
-- depth 1 에만 해당 되는 내용, depth = 1 은 답변, ownerUid = 게시물의  uid
-- 관리자 name 가져 오는 부분 select 하는거
-- 이렇게 join 걸지 말기 . !!!!
select
    BU1.uid,
    BU2.ownerUid,
    BU1.subject ,
    BU1.contents,
    BU2.subject,
    BU2.contents
from BoardContactUs as BU1
inner join BoardContactUs as BU2 on BU1.uid = BU2.ownerUid
where BU1.seqUser = '2024060516125675900000029';

select *
from Category;

select *
from BoardContactUs;

select *
from BoardCategory;


-- 13. 문의 내역 답변 수정
-- 이렇게 join  걸지 말기 !!!
update BoardContactUs as BU1
join BoardContactUs as BU2 on BU1.uid = BU2.ownerUid
set BU2.subject = '답변 수정 test' ,
    BU2.contents = '답변 수정 contents '
where BU1.uid = 13;

update BoardContactUs
set isAnswer = true
where uid  = 13


select *
from BoardContactUs;

-- 14. 문의 내역 답변 등록
INSERT INTO BoardContactUs
    (
       ownerUid,
       depth,
       boardType,
       seqUser,
       name,
       email,
       phone,
       subject,
       contents,
       userIP,
       updatedAt,
       createdAt
    ) values
    (
        13,
        1,
        'API',
        '2024052215443011200000002',
        '신민정',
        '',
        '',
        '답변 test',
        '답변 contents',
        '127.0.0.1',
        now(),
        now()
    );


delete from BoardContactUs
where uid in (21);





select *
from BoardContactUs;

--
-- 초기 AdminUser에 대한 Password 등록
select *
from AdminPasswordHistory;
INSERT INTO AdminPasswordHistory
    (
        seqUser,
        seqModifier,
        password,
        userIP,
        updatedAt,
        createdAt
    )
values ( '2024052215443011200000002','2024052215443011200000002', '9e4294f51f9fe0fa4809afb18f1f4d3d6f6474ef9a5e3392add24e3d9cae6d2d', '127.0.0.1',NOW(),NOW()),
       ( '2024052215443011200000001','2024052215443011200000001', 'a69343ac7ef586435f708c4fc0a0d5d84386d5f5cc5663004169452c8d1cf057', '127.0.0.1',NOW(),NOW());



--
SELECT
    BoardNotice.uid,
    BoardNotice.boardCategoryUid,
    BoardNotice.topOrder,
    BoardNotice.boardType,
    BoardNotice.subject,
    BoardNotice.contents,
    BoardNotice.isUse,
    BoardNotice.isDel,
    BoardNotice.updatedAt,
    BoardNotice.createdAt,
    BoardCategory.uid,
    BoardCategory.boardType,
    BoardCategory.`order`,
    BoardCategory.`name`,
    BoardCategory.isUse,
    BoardCategory.isDel,
    BoardCategory.createdAt
FROM BoardNotice
    LEFT JOIN BoardCategory ON  (BoardCategory.uid = BoardNotice.boardCategoryUid)
WHERE (BoardNotice.boardType = 'FAQ')
  AND (BoardNotice.isUse = true)
  AND (BoardNotice.isDel = false)
  AND (BoardNotice.boardCategoryUid = 2)
ORDER BY BoardNotice.uid DESC LIMIT 10;


select *
from BoardCategory
where boardType = 'FAQ';


select *
from BoardNotice;


select uid
from BoardContactUs;

delete from BoardNotice
where uid in (15,16,17);


select *
from BoardCategory;

delete from BoardCategory
where uid = 13;


select *
from GroupItem;

select *
from GroupItemGoods;

----
select *
from GroupTheme;

select *
from GroupThemeBrand;


select *
from GroupThemeBrandGoods;



-- 추천 상품 관리, Best 상품 관리 , 인기 상품 관리
-- 그룹 명, 전시 상태, 해당 그룹의 상품 추가, 상품 선택(팝업은 이미 작성 됨), 삭제
-- brand를 따로 빼서 조인 하지 않으려고 category에 key를 넣었다.
select *
from Goods;

select *
from GroupItem;

select *
from GroupItemGoods;

select
    g.seq,
    g.name,
    gig.seqGoods
from GroupItem as gi
left join GroupItemGoods as gig on gi.uid = gig.uid
left join Goods as g on gig.seqGoods = g.seq;

/**
  추천 상품 관리
  */
-- 추천 상품 관리 조건 조회 , 그룹명, 상품명, 상태값
select
    gi.isUse,
    gi.subject,
    gi.isDel,
    gig.uid,
    gi.type,
    group_concat(g.name) as name
from GroupItem as gi
left join GroupItemGoods as gig on gi.uid = gig.uid
left join Goods as g on gig.seqGoods = g.seq
where
    gi.isDel  = false
    -- gi.subject like '%추천%' and
    -- name like '%아메리카노%' and
    -- gi.isUse = 1
group by subject;

-- 수정 : 그룹 전시 상태 수정
update GroupItem
set isUse = true
where uid = 1;

-- [새 그룹 등록 팝업] 새 그룹 등록
-- default -> order :1 , type: 추천 상품
-- 새 그룹 명 체크



    select *
    from GroupItem;

    select *
    from GroupItemGoods;





-- [수정 팝업] [상품 추가 팝업] [그룹 상품 추가 팝업] : 브랜드, 상품명
select
    g.seq,
    c.name,
    g.name
from Goods as g
left join Category as c on g.seqCategoryBrand = c.seq
where
    g.isDel = false
  and c.name like '%스%' -- 브랜드 명
  and g.name like '%아메%'; -- 상품명

-- [수정 팝업] 상품관리 조회
select
    gig.uid,
    g.seq,
    c.name,
    g.name,
    g.isUse,
    gig.isDel
from GroupItemGoods as gig
left join Goods as g on gig.seqGoods = g.seq
left join Category as c on g.seqCategoryBrand = c.seq
where gig.uid = 1  and g.isUse = true;

-- [수정 팝업] 상품에 대한 선택 삭제
update GroupItemGoods
set isDel = false
where seqGoods in ( '2024041912000011100000002');



-- [수정 팝업] 상품 추가


-- [수정 팝업] 선택 삭제



-- [수정 팝업] 상품 추가 사용 여부 수정




















