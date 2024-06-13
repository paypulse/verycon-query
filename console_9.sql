select *
from BoardNotice;

select *
from BoardCategory;

select
     ROW_NUMBER() over ()
from (
select
    bn.userIP,
    bn.uid,
    bn.boardType,
    bc.name
from BoardNotice as bn
left join BoardCategory as bc on bn.boardCategoryUid = bc.uid
where bn.boardType='FAQ')  as t;


select *
from BoardCategory;

select *
from BoardNotice;

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
    and BC.uid =  1 -- 카테고리
    and BN.subject like '%이용%'
    and date_format(BN.createdAt,'%Y-%m-%d')  Between date_format('2024-03-01','%Y-%m-%d')  and date_format('2024-04-16','%Y-%m-%d')
limit 1 offset 1 ;  -- limit perpage  offset page


-- 2. 사용 , 미사용 상태 변경 쿼리
    update BoardNotice
    set isUse = 1
    where uid = 4;
-- 2.1 선택 삭제 : isDel 값 update
    update BoardNotice
    set isDel = 0
    where uid = 4;

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
    WHERE BN.uid = 6;

-- 5. 게시물 수정 쿼리
-- 수정에 포함 되는 범주  :  상단 고정, 분류, 상태, 제목 , 내용
    update BoardNotice
    set
        topOrder = 0,
        boardCategoryUid = 1,
        isUse = 1,
        subject = '수정테스트' , -- null 일 수 없고
        contents = '수정 수정 ' -- null 가능
    where uid = 6;

-- 6. 분류 항목 조회 , isDel 이 0 인 애들
    select
        BC.name,
        BC.uid
    from BoardCategory as BC
    where isDel = 0;

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

-- 다건 수정 / 삭제
-- 삭제 /수정 완료시 success : true 로 올 수 잇게 해주기  저장을 누르는 순간 해당 내역 반영
-- 8.분류 수정 쿼리  --> 카테 고리 분류 편집 쿼리
    update BoardCategory
        set name ='분류121'
    where uid = 7;

-- 9. 분류 삭제 --> 다건에 해당
    update BoardCategory
        set isDel = 1
    where uid = 7;
--

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
join User as U on BU.seqUser = U.seq
where
    BU.boardType = 'BULK_SEND'
    and BU.isUse = 1
    and BU.depth = 0 -- 답변이면 1에 해당
    and U.userId like '%ki%'
    and date_format(BU.createdAt,'%Y-%m-%d')  Between date_format('2024-04-01','%Y-%m-%d')  and date_format('2024-06-16','%Y-%m-%d')
    limit 1 offset 1 ;  -- limit perpage  offset page

-- 11. 문의 구분 조회
select
    DISTINCT boardType
from BoardContactUs;

-- 12. 문의 내역 상세 조회
-- 답글은 그냥 조인 하지 말고 노출 해야 되는 문제
--  작성자  : 관리자 이름 , seq -> 관리자 시퀀스 -> 관리자 로그인한 사람 : 2024052215443011200000002 , name : 관리자 이름 , 이메일, 핸드폰
-- depth 1 에만 해당 되는 내용, depth = 1 은 답변, ownerUid = 게시물의  uid
-- 관리자 name 가져 오는 부분 select 하는거
select
    BU1.subject ,
    BU1.contents,
    BU2.subject,
    BU2.contents
from BoardContactUs as BU1
inner join BoardContactUs as BU2 on BU1.uid = BU2.ownerUid
where BU1.seqUser = '2024060516125675900000029';


-- 13. 문의 내역 답변 수정





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

select *
from AdminUser;




