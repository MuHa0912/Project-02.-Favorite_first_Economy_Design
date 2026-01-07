USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 5] REE (Resource Exchange Efficiency) 측정
   - 목적: 보상 티켓 1장을 얻기 위해 소모한 자원의 가치 비교
   ========================================================================== */
WITH User_Burn_Stats AS (
    SELECT 
        U.user_id,
        U.user_segment,
        -- 레벨에 따른 스킬북 소모량 추정 (10렙=630개, 7렙=180개)
        CASE 
            WHEN R.skill_lv_1 = 10 THEN 630 
            WHEN R.skill_lv_1 >= 7 THEN 180 
            ELSE 0 
        END AS Resource_Burned
    FROM User_Master U
    JOIN User_Roster R ON U.user_id = R.user_id AND R.nikke_id = 9999
    WHERE U.user_segment IN ('Target', 'Meta')
)
SELECT 
    user_segment AS [User_Group],
    
    -- 평균 자원 소모량
    AVG(Resource_Burned) AS [Avg_Resource_Burned],
    
    -- REE 비율 (총 소모 자원 / 보상 티켓 20장)
    CAST(AVG(Resource_Burned) / 20.0 AS DECIMAL(5,1)) AS [REE_Ratio]
FROM User_Burn_Stats
GROUP BY user_segment;