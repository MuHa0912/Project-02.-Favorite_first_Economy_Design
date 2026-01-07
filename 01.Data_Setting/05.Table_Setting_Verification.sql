USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Step 4] 데이터 세팅 검증
   ========================================================================== */

-- 1. 그룹별 유저 수 확인 (Target 20 / Meta 60)
SELECT user_segment, COUNT(*) AS User_Count FROM User_Master GROUP BY user_segment;

-- 2. [Target 그룹] 의도 확인: 티아 보유 + 나가 미보유 + 스킬북 비축량
SELECT TOP 5
    U.nickname, 
    U.user_segment,
    (SELECT COUNT(*) FROM User_Roster WHERE user_id = U.user_id AND nikke_id = 9001) AS Has_Tia, -- 1이어야 함
    (SELECT COUNT(*) FROM User_Roster WHERE user_id = U.user_id AND nikke_id = 9002) AS Has_Naga, -- 0이어야 함
    I.quantity AS SkillBook_Hoarded -- 300개 이상이어야 함
FROM User_Master U
JOIN User_Inventory I ON U.user_id = I.user_id AND I.item_id = 13
WHERE U.user_segment = 'Target';

-- 3. [Target 그룹] 가챠 과열(Burning) 확인
SELECT TOP 5
    U.nickname,
    COUNT(G.log_id) AS Gacha_Attempts, -- 50회 근처여야 함
    SUM(G.amount) AS Total_Jewels_Burned
FROM User_Master U
JOIN Gacha_Log G ON U.user_id = G.user_id
WHERE U.user_segment = 'Target'
GROUP BY U.nickname;

-- 4. [Meta 그룹] 벤치마크 확인 (앨리스 다이어리 완료 여부)
SELECT TOP 5
    U.nickname,
    (SELECT COUNT(*) FROM Contents_Log WHERE user_id = U.user_id AND content_id = 902) AS Is_Completed -- 1이어야 함
FROM User_Master U
WHERE U.user_segment = 'Meta';