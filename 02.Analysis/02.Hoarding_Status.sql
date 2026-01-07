USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 2] Hoarding Status (성장 재화 비축량 분석)
   - 목적: Target 그룹이 스킬북을 얼마나 쌓아두고 있는지 확인 (성장 포기 증명)
   ========================================================================== */
SELECT 
    U.user_segment AS [User_Group],
    COUNT(U.user_id) AS [User_Count],
    
    -- 스킬 매뉴얼 3 (SSR) 평균 보유량
    ISNULL(AVG(I.quantity), 0) AS [Avg_SkillBook3_Hoarded]
FROM User_Master U
LEFT JOIN User_Inventory I ON U.user_id = I.user_id AND I.item_id = 13 -- Item 13: 스킬 매뉴얼 3
WHERE U.user_segment IN ('Target', 'Meta')
GROUP BY U.user_segment;