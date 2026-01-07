USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Analysis 6] Simulation Verification (Final Comprehensive)
   - Part 1: 자원 순환 및 성장 (Resource & Growth)
   - Part 2: 효율성 및 안착률 비교 (Efficiency & Retention vs Benchmark)
   ========================================================================== */

-- ==========================================================================
-- [Part 1] 현실적 시나리오 기반 자원 순환 & 성장 예측
-- ==========================================================================
WITH Target_User_List AS (
    SELECT 
        user_id,
        combat_power AS Current_CP,
        ISNULL((SELECT quantity FROM User_Inventory WHERE user_id = U.user_id AND item_id = 13), 0) AS Current_Stock,
        ABS(CHECKSUM(NEWID())) % 100 AS Random_Roll
    FROM User_Master U
    WHERE user_segment = 'Target'
),
Simulation_Logic AS (
    SELECT 
        user_id,
        Current_CP,
        Current_Stock,
        CASE 
            WHEN Random_Roll >= 85 THEN 'Non-Participant' -- 15% 미참여
            WHEN Random_Roll >= 50 THEN 'Option_A_Equip'  -- 35% 장비 선택
            ELSE 'Option_B_Selector'                      -- 50% 니케 선택 (파츠 획득)
        END AS User_Choice
    FROM Target_User_List
),
Calculated_Result AS (
    SELECT user_id, 'AS-IS' AS Scenario, Current_Stock AS Final_Stock, Current_CP AS Final_CP
    FROM Simulation_Logic
    UNION ALL
    SELECT user_id, 'TO-BE' AS Scenario,
        CASE 
            WHEN User_Choice = 'Non-Participant' THEN Current_Stock 
            WHEN User_Choice = 'Option_A_Equip' THEN CAST(Current_Stock * 0.7 AS INT) 
            WHEN User_Choice = 'Option_B_Selector' THEN CAST(Current_Stock * 0.15 AS INT) 
        END AS Final_Stock,
        CASE 
            WHEN User_Choice = 'Non-Participant' THEN Current_CP 
            WHEN User_Choice = 'Option_A_Equip' THEN CAST(Current_CP * 1.05 AS INT) 
            WHEN User_Choice = 'Option_B_Selector' THEN CAST(Current_CP * 1.25 AS INT) 
        END AS Final_CP
    FROM Simulation_Logic
)
SELECT 
    Scenario,
    COUNT(user_id) AS [Target_Users],
    AVG(Final_Stock) AS [Avg_Hoarded_Stock],
    CAST(ISNULL((1 - AVG(Final_Stock) * 1.0 / NULLIF(LAG(AVG(Final_Stock)) OVER (ORDER BY Scenario), 0)) * 100, 0) AS DECIMAL(5,1)) AS [Stock_Decrease_Rate(%)],
    AVG(Final_CP) AS [Avg_Combat_Power],
    CAST(ISNULL((AVG(Final_CP) * 1.0 / NULLIF(LAG(AVG(Final_CP)) OVER (ORDER BY Scenario), 0) - 1) * 100, 0) AS DECIMAL(5,1)) AS [Growth_Rate(%)]
FROM Calculated_Result
GROUP BY Scenario;


-- ==========================================================================
-- [Part 2] Efficiency & Retention Gap Analysis (vs Benchmark)
-- * 목적: Meta 그룹(Benchmark) 대비 Target 그룹(TO-BE)의 퍼포먼스 비교
-- * 핵심 논리: Target 그룹은 이미 재화를 '비축'했으므로, 동기만 부여되면 Meta 그룹보다 훨씬 빠르게 완료함 (Instant Completion)
-- ==========================================================================

WITH Benchmark_Stats AS (
    -- 1. Benchmark (Meta 그룹) 실측 데이터
    SELECT 
        '1. Benchmark (Meta)' AS Group_Label,
        AVG(DATEDIFF(DAY, L_Start.log_date, L_End.log_date)) AS Avg_Days_Taken, -- 약 14~20일 소요
        CAST(SUM(CASE WHEN L_Next.log_id IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(U.user_id) AS DECIMAL(5,1)) AS Retention_Rate
    FROM User_Master U
    JOIN Contents_Log L_Start ON U.user_id = L_Start.user_id AND L_Start.content_id = 901
    LEFT JOIN Contents_Log L_End ON U.user_id = L_End.user_id AND L_End.content_id = 902
    LEFT JOIN Contents_Log L_Next ON U.user_id = L_Next.user_id AND L_Next.content_id = 200
    WHERE U.user_segment = 'Meta'
),
Target_TO_BE_Projection AS (
    -- 2. Target (TO-BE) 예측 데이터
    -- 가설: 비축 재화(Hoarded Stock)가 충분하므로, 니케 선택 시 즉시(1~3일) 완료 가능
    -- 가설: 파츠 획득 시 이탈 리스크가 해소되어 Meta 그룹 수준(95%)으로 안착
    SELECT 
        '2. Target (TO-BE)' AS Group_Label,
        3 AS Avg_Days_Taken, -- 즉시 완료 (Instant Completion) 예측
        95.0 AS Retention_Rate -- Benchmark 수준 회복 예측
),
Target_AS_IS_Status AS (
    -- 3. Target (AS-IS) 현재 상태
    SELECT 
        '3. Target (AS-IS)' AS Group_Label,
        NULL AS Avg_Days_Taken, -- 완료 못함 (Infinity)
        5.0 AS Retention_Rate -- 현재 이탈 위험 매우 높음 (가상 수치)
)

-- [최종 비교 리포트]
SELECT 
    Group_Label,
    
    -- 평균 완료 소요 시간 (Days)
    ISNULL(CAST(Avg_Days_Taken AS VARCHAR), 'Not Completed') AS [Avg_Completion_Time(Days)],
    
    -- 완료 후 잔존율 (%)
    Retention_Rate AS [Retention_Rate(%)],
    
    -- 비고 (Insight)
    CASE 
        WHEN Group_Label LIKE '%Benchmark%' THEN 'Standard Performance'
        WHEN Group_Label LIKE '%TO-BE%' THEN 'Instant Growth (Due to Hoarding)'
        WHEN Group_Label LIKE '%AS-IS%' THEN 'Stagnation Risk'
    END AS [Note]
    
FROM (
    SELECT * FROM Benchmark_Stats
    UNION ALL
    SELECT * FROM Target_TO_BE_Projection
    UNION ALL
    SELECT * FROM Target_AS_IS_Status
) Combined_Data
ORDER BY Group_Label;