USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 3] Gacha Burning Status (가챠 과열 상태 분석)
   - 목적: Target 그룹이 '파츠 캐릭터'를 뽑기 위해 가챠 재화를 얼마나 태웠는지 확인 (결핍 증명)
   ========================================================================== */
SELECT 
    U.user_segment AS [User_Group],
    
    -- 인당 평균 가챠 시도 횟수
    CAST(COUNT(G.log_id) * 1.0 / NULLIF(COUNT(DISTINCT U.user_id), 0) AS DECIMAL(5,1)) AS [Avg_Gacha_Attempts],
    
    -- 인당 평균 소모 쥬얼 환산액 (티켓 1장 = 300쥬얼로 환산하여 합산)
    CAST(SUM(CASE WHEN G.currency_used = 'Jewel' THEN G.amount ELSE G.amount * 300 END) 
         / NULLIF(COUNT(DISTINCT U.user_id), 0) AS INT) AS [Avg_Jewels_Burned]
FROM User_Master U
LEFT JOIN Gacha_Log G ON U.user_id = G.user_id AND G.gacha_type = 'Pickup'
WHERE U.user_segment IN ('Target', 'Meta')
GROUP BY U.user_segment;