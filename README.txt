[Project 02] Favorite_first_Economy_Design (최애 중심 유저 그룹을 위한 선택형 보상 설계 및 경제 효과 시뮬레이션)

-주제 : 수집형 RPG에서 발생하는 '성장 정체' 현상을 분석하고, 선택형 보상 시스템을 제안하여 경제 순환과 유저 성장을 유도한 데이터 분석 프로젝트입니다.

1. Project Overview
-Tools : SQL(SSMS), Excel, Looker Studio
-Concept : 수집형 RPG (레퍼런스 : 니케)
-Goal : 파츠 캐릭터 부재로 성장을 멈춘 유저들의 비축 재화를 시장으로 끌어내고, 이탈률을 낮추는 솔루션 제안

2. SQL File Structure
이 리포지토리는 다음과 같은 순서로 데이터를 생성하고 분석하며, 해결책을 시뮬레이션 합니다.

01.Data_Setting📂
	ㄴ01.Create_DB.sql : 데이터 베이스 생성
	ㄴ02.Table_Setting.sql : DB 스키마 설계 및 테이블 초기화
	ㄴ03.Insert_Master_Data.sql : 캐릭터, 아이템, 콘텐츠 기준 정보 입력
	ㄴ04.Create_User_Data.sql : 유저 세그먼트 별 행동 로그 생성 (난수 기반 시뮬레이션)
	ㄴ05.Table_Setting_Verification.sql : 테이블 세팅 점검
02.Analysis📂
	ㄴ01.Reference_Benchmark.sql : 벤치마크 분석 (Reference 성과)
	ㄴ02.Hoarding_Status.sql : 현상 분석 (타겟 그룹 평균 재화 비축량)
	ㄴ03.Gacha_Burning_Status.sql : 현상 분석 (타겟 그룹 가챠 재화 소모량)
	ㄴ04.MCR.sql : MCR(미션 완료율) 지표 측정
	ㄴ05.REE.sql : REE(보상으로 획득한 자원 교환 효율) 지표 측정
03.Future_Impact_Report📂
	ㄴ01.Simulation_Verification.sql : 시나리오 적용 후 효과 예측 비교