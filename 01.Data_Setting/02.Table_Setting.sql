USE Favorite_first_Economy_Design;
GO

/* ==========================================================================
   [Step 1] 테이블 초기화 (Reset) & 생성(재실행 가능)
   ========================================================================== */

-- 1. 외래키 참조가 있는 로그/매핑 테이블부터 삭제
DROP TABLE IF EXISTS Gacha_Log;
DROP TABLE IF EXISTS Contents_Log;
DROP TABLE IF EXISTS User_Inventory;
DROP TABLE IF EXISTS User_Roster;
DROP TABLE IF EXISTS Growth_Cost_Table;

-- 2. 마스터/메타 테이블 삭제
DROP TABLE IF EXISTS User_Master;
DROP TABLE IF EXISTS Contents_Master;
DROP TABLE IF EXISTS Item_Master;
DROP TABLE IF EXISTS Nikke_Master;

-- 3. 테이블 생성 시작

-- (1) 니케 마스터 (캐릭터 정보)
CREATE TABLE Nikke_Master (
    nikke_id INT PRIMARY KEY,
    nikke_name NVARCHAR(50),
    rarity NVARCHAR(10),
    manufacturer NVARCHAR(10),
    squad_name NVARCHAR(30),
    burst_type INT,
    role_type NVARCHAR(10) -- 화력/방어/지원
);

-- (2) 아이템 마스터 (재화 정보)
CREATE TABLE Item_Master (
    item_id INT PRIMARY KEY,
    item_name NVARCHAR(50),
    item_type NVARCHAR(30),
    rarity NVARCHAR(10)
);

-- (3) 콘텐츠 마스터
CREATE TABLE Contents_Master (
    content_id INT PRIMARY KEY,
    content_name NVARCHAR(50),
    reset_cycle NVARCHAR(20)
);

-- (4) 유저 마스터
CREATE TABLE User_Master (
    user_id INT PRIMARY KEY,
    nickname NVARCHAR(50),
    level INT,
    combat_power INT,
    create_date DATETIME,
    last_login_date DATETIME,
    user_segment NVARCHAR(20) -- Target / Meta / Inactive
);

-- (5) 유저 니케 보유 현황 (Roster)
CREATE TABLE User_Roster (
    user_id INT,
    nikke_id INT,
    skill_lv_1 INT DEFAULT 1,
    skill_lv_2 INT DEFAULT 1,
    skill_burst INT DEFAULT 1,
    overload_count INT DEFAULT 0,
    bond_level INT DEFAULT 1,
    FOREIGN KEY (user_id) REFERENCES User_Master(user_id),
    FOREIGN KEY (nikke_id) REFERENCES Nikke_Master(nikke_id)
);

-- (6) 유저 인벤토리 (Inventory)
CREATE TABLE User_Inventory (
    user_id INT,
    item_id INT,
    quantity INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES User_Master(user_id),
    FOREIGN KEY (item_id) REFERENCES Item_Master(item_id)
);

-- (7) 콘텐츠 로그 (Alice's Diary 등 수행 기록)
CREATE TABLE Contents_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    log_date DATETIME,
    content_id INT,
    value INT, -- 완료 시 전투력이나 점수 등
    FOREIGN KEY (user_id) REFERENCES User_Master(user_id),
    FOREIGN KEY (content_id) REFERENCES Contents_Master(content_id)
);

-- (8) 가챠 로그 (소비 패턴 분석용)
CREATE TABLE Gacha_Log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    log_date DATETIME,
    gacha_type NVARCHAR(20), -- 'Pickup', 'Ordinary'
    currency_used NVARCHAR(20), -- 'Jewel', 'Ticket'
    amount INT, -- 소모량
    result_nikke_id INT, -- 획득한 니케 ID
    FOREIGN KEY (user_id) REFERENCES User_Master(user_id)
);