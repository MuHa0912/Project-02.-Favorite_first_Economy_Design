USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Step 2] 마스터 데이터 입력
   ========================================================================== */

-- 1. 니케 마스터
INSERT INTO Nikke_Master VALUES
-- 핵심 분석 대상 (미실리스)
(9001, '티아', 'SSR', 'Missilis', '다즐링펄', 1, '방어형'),
(9002, '나가', 'SSR', 'Missilis', '다즐링펄', 2, '지원형'),
(1101, '리타', 'SSR', 'Missilis', '마이티툴즈', 1, '지원형'),
-- 벤치마크 대상 (테트라)
(9999, '앨리스', 'SSR', 'Tetra', '언리미티드', 3, '화력형'),
(3002, '누아르', 'SSR', 'Tetra', '777', 3, '화력형'),
(3003, '블랑', 'SSR', 'Tetra', '777', 2, '방어형'),
-- 비교군 (필그림)
(7777, '홍련', 'SSR', 'Pilgrim', '파이오니어', 3, '화력형'),
(8888, '모더니아', 'SSR', 'Pilgrim', '헤레틱', 3, '화력형'),
-- 통상
(1001, '엠마', 'SSR', 'Elysion', '앱솔루트', 1, '지원형'),
(1002, '프리바티', 'SSR', 'Elysion', '트라이앵글', 3, '화력형');

-- 2. 아이템 마스터
INSERT INTO Item_Master VALUES
(11, '스킬 매뉴얼 1', 'Skill_Mat', 'R'),
(12, '스킬 매뉴얼 2', 'Skill_Mat', 'SR'),
(13, '스킬 매뉴얼 3', 'Skill_Mat', 'SSR'), -- 핵심 비축 대상
(61, '커스텀 모듈', 'Gear_Mat', 'SSR'),   -- 핵심 비축 대상
(71, '모집 티켓', 'Gacha_Mat', '-'),
(72, '쥬얼(무료)', 'Currency', '-');

-- 3. 콘텐츠 마스터
INSERT INTO Contents_Master VALUES
(901, 'Alice Diary Start', 'OneTime'),
(902, 'Alice Diary Complete', 'OneTime'),
(200, 'Special Interception', 'Daily'); -- 상위 콘텐츠(특요전)