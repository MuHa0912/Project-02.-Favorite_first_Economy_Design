USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 1] Reference Benchmark (Alice's Diary 성과 분석)
   - 목적: Meta 그룹(성공 사례)은 다이어리를 며칠 만에 깼으며, 이후 잘 정착했는가?
   ========================================================================== */
WITH Alice_Log_Summary AS (
    SELECT 
        user_id,
        MIN(CASE WHEN content_id = 901 THEN log_date END) AS Start_Date,
        MAX(CASE WHEN content_id = 902 THEN log_date END) AS End_Date,
        MAX(CASE WHEN content_id = 200 THEN 1 ELSE 0 END) AS Next_Content_Entry
    FROM Contents_Log
    GROUP BY user_id
),
Benchmark_Data AS (
    SELECT 
        U.user_id,
        DATEDIFF(DAY, L.Start_Date, L.End_Date) AS Days_Taken,
        CASE WHEN L.Next_Content_Entry = 1 THEN 'Retained' ELSE 'Churned' END AS Retention_Status
    FROM User_Master U
    JOIN Alice_Log_Summary L ON U.user_id = L.user_id
    WHERE U.user_segment = 'Meta' -- 성공 그룹만 분석
      AND L.End_Date IS NOT NULL
)
SELECT 
    'Alice''s Diary (Meta Group)' AS Benchmark_Target,
    COUNT(user_id) AS [Sample_Size],
    AVG(Days_Taken) AS [Avg_Completion_Days], -- 평균 소요 시간 (약 17일 예상)
    CAST(SUM(CASE WHEN Retention_Status = 'Retained' THEN 1 ELSE 0 END) * 100.0 / COUNT(user_id) AS DECIMAL(5,1)) AS [Retention_Rate(%)] -- 잔존율 (95% 이상 예상)
FROM Benchmark_Data;