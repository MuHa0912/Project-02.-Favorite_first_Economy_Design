USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 4] MCR (Mission Conversion Rate) 측정
   - 목적: 앨리스 다이어리(성장 미션)를 끝까지 깬 비율 비교
   ========================================================================== */
SELECT 
    U.user_segment AS [User_Group],
    COUNT(U.user_id) AS [Total_Users],
    
    -- 10레벨(완전 성장) 도달 유저 수
    SUM(CASE WHEN R.skill_lv_1 = 10 THEN 1 ELSE 0 END) AS [Completed_Users],
    
    -- 전환율 (Conversion Rate)
    CAST(SUM(CASE WHEN R.skill_lv_1 = 10 THEN 1 ELSE 0 END) * 100.0 / COUNT(U.user_id) AS DECIMAL(5,1)) AS [MCR(%)]
FROM User_Master U
LEFT JOIN User_Roster R ON U.user_id = R.user_id AND R.nikke_id = 9999 -- 앨리스
WHERE U.user_segment IN ('Target', 'Meta')
GROUP BY U.user_segment;