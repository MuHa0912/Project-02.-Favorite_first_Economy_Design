USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Step 3] 유저 데이터 및 시뮬레이션 로그 생성
   ========================================================================== */

DECLARE @i INT = 1;
DECLARE @TotalUsers INT = 100; -- 표본 100명 (Target 20, Meta 60, Inactive 20)

WHILE @i <= @TotalUsers
BEGIN
    DECLARE @UID INT = 1000 + @i;
    DECLARE @Segment NVARCHAR(20);
    
    -- 그룹 배정
    IF @i <= 20 SET @Segment = 'Target';
    ELSE IF @i <= 80 SET @Segment = 'Meta';
    ELSE SET @Segment = 'Inactive';

    -- 1. 유저 마스터 생성
    INSERT INTO User_Master VALUES (
        @UID, 'User_' + CAST(@UID AS NVARCHAR), 
        CASE WHEN @Segment = 'Meta' THEN 250 ELSE 160 END, -- 레벨 차이
        CASE WHEN @Segment = 'Meta' THEN 250000 ELSE 170000 END, -- 전투력 차이
        DATEADD(DAY, -200, GETDATE()), GETDATE(), @Segment
    );

    -- ======================================================================
    -- [Scenario A] Target 그룹: 파츠 대기형 (비축 O, 가챠 과열 O, 성장 정체)
    -- ======================================================================
    IF @Segment = 'Target'
    BEGIN
        -- (1) 로스터: 티아(9001) 보유, 나가(9002) 미보유
        INSERT INTO User_Roster VALUES (@UID, 9001, 7,7,7, 0, 30); -- 티아 7렙 (가성비 주차)
        INSERT INTO User_Roster VALUES (@UID, 9999, 7,7,7, 0, 10); -- 앨리스 7렙 (미션 미완료)

        -- (2) 인벤토리: 비축(Hoarding) 상태
        -- 스킬 매뉴얼 3 (SSR) 300~500개 쌓아둠
        INSERT INTO User_Inventory VALUES (@UID, 13, 300 + (ABS(CHECKSUM(NEWID())) % 200));
        -- 커스텀 모듈 30~50개 쌓아둠
        INSERT INTO User_Inventory VALUES (@UID, 61, 30 + (ABS(CHECKSUM(NEWID())) % 20));

        -- (3) 가챠 로그: 과열(Burning) 상태
        -- 최근 30일간 50회 이상 시도했으나 '나가' 획득 실패
        DECLARE @k INT = 1;
        WHILE @k <= 50 
        BEGIN
            INSERT INTO Gacha_Log VALUES (
                @UID, DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 30), GETDATE()), 
                'Pickup', 'Jewel', 300, 
                1001 -- 엠마만 나옴
            );
            SET @k = @k + 1;
        END

        -- (4) 콘텐츠 로그: 앨리스 다이어리 시작은 했으나 완료 로그(902) 없음
        INSERT INTO Contents_Log VALUES (@UID, DATEADD(DAY, -60, GETDATE()), 901, 0);
    END

    -- ======================================================================
    -- [Scenario B] Meta 그룹: 성장 완료형 (소모 O, 가챠 효율, 벤치마크)
    -- ======================================================================
    ELSE IF @Segment = 'Meta'
    BEGIN
        -- (1) 로스터: 티아(9001) & 나가(9002) 모두 보유 (완전체)
        INSERT INTO User_Roster VALUES (@UID, 9001, 10,10,10, 4, 30);
        INSERT INTO User_Roster VALUES (@UID, 9002, 10,10,10, 4, 30);
        INSERT INTO User_Roster VALUES (@UID, 9999, 10,10,10, 4, 30); -- 앨리스 10렙 (완료)

        -- (2) 인벤토리: 소모 상태 (비축량 적음)
        INSERT INTO User_Inventory VALUES (@UID, 13, ABS(CHECKSUM(NEWID())) % 50); -- 0~50개

        -- (3) 가챠 로그: 일반적인 패턴 (10회 미만)
        DECLARE @m INT = 1;
        WHILE @m <= 10
        BEGIN
            INSERT INTO Gacha_Log VALUES (
                @UID, DATEADD(DAY, -30, GETDATE()), 'Ordinary', 'Ticket', 1, 1002
            );
            SET @m = @m + 1;
        END

        -- (4) [Benchmark Data] 콘텐츠 로그: 앨리스 다이어리 완료 & 안착
        DECLARE @StartDate DATETIME = DATEADD(DAY, -100, GETDATE());
        DECLARE @Duration INT = 14 + (ABS(CHECKSUM(NEWID())) % 7); -- 14~20일 소요
        
        INSERT INTO Contents_Log VALUES (@UID, @StartDate, 901, 0); -- 시작
        INSERT INTO Contents_Log VALUES (@UID, DATEADD(DAY, @Duration, @StartDate), 902, 0); -- 완료
        INSERT INTO Contents_Log VALUES (@UID, DATEADD(DAY, @Duration + 1, @StartDate), 200, 0); -- 상위 콘텐츠 진입
    END

    SET @i = @i + 1;
END