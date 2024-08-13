# 🍀 아띠(ATTI) 종합 동물 병원 ERP 시스템 
<p align="center"><img src="https://github.com/GDJ80-TeamC/semi-atti/blob/8f925dfb9bf190914cec5ea716b3b41af4719ae5/atti/src/main/webapp/inc/logo.png" width="400" height="400"/></p>

## 💡 프로젝트 소개
반려 동물 시장이 증가함에 따라 의료 서비스를 제공하는 동물 병원의 필요성이 높아져 종합 동물 병원의 ERP시스템 구현
- 배포 URL : <http://13.209.193.10/atti/view/loginForm.jsp>
- 개발 기간 : 2024.04.30 ~ 2024.05.24 (4주)

**개발 환경**
<br>
OS : Mac OS sonoma <br>
Back-end : Java <br> 
Front-end : HTML5, CSS3, BootStrap <br>
Database : MariaDB <br>
WAS : Apache Tomcat 10 <br>
IDE : Eclipse <br>
Cloud Service : Amazon Web Services <br>
버전관리 : GitHub <br>
<br>

## 📍 팀원 구성
- 김인수 ([@Guinsu](https://github.com/Guinsu))
- 김지훈 ([@babpur](https://github.com/babpur)) 
- 박혜아 ([@hyeah0526](https://github.com/hyeah0526)) 
- 한은혜 ([@eunhyes](https://github.com/eunhyes))
<br>

## 🖇️ 요구사항 명세서
<img src="https://github.com/GDJ80-TeamC/semi-atti/blob/6572b27fb473d0ca1026451a540e9196287a7d22/atti/src/main/webapp/META-INF/document/GDJ80_teamC_%EC%9A%94%EA%B5%AC%EC%82%AC%ED%95%AD%20%EB%AA%85%EC%84%B8%EC%84%9C.png" width="1000"/>
<br>

## 📌 ERD다이어 그램 
<img src="https://github.com/GDJ80-TeamC/semi-atti/blob/7147292df72ef10ce1464b42957e348adc7f379a/atti/src/main/webapp/META-INF/document/GDJ80_teamC_ERD%EB%8B%A4%EC%9D%B4%EC%96%B4%EA%B7%B8%EB%9E%A8.png" width="1000"/>
<br>

## 💫 담당 기능
### [접수/예약 목록 페이지]
- 접수 리스트
   - 오늘 날짜의 접수 상태가 ‘예약’과 ‘대기’인 접수만 출력, 페이징
   - 예약/대기 -> 진행/취소로 상태 변경
- 예약 리스트
   - 오늘 날짜보다 미래의 접수 상태가 ‘예약’인 것만 출력, 페이징
   - 예약 -> 취소로 상태 변경

### [진료 목록 페이지]
- 진료 리스트
   - 로그인한 사번에 해당하는 진료만 필터링하여 출력 (의사 본인의 것만 출력)
   - 진료 시작 버튼 -> 진행으로 상태 변경, 진료 상세 페이지로 이동 

### [진료 상세 페이지]
- 검사 내용 및 사진 등록

### [수술 리스트 및 수술 상세 페이지]
- 수술 리스트
   - 페이징, 날짜 검색 기능 구현
- 수술 상세 페이지
   - 해당 수술에 대한 상세 내역 출력

### [검사 리스트 및 검사 상세 페이지]
- 검사 리스트
   - 페이징, 날짜 검색 기능 구현
- 검사 상세 페이지
   - 해당 검사에 대한 상세 내역 출력

### [처방 리스트]
- 페이징, 날짜 검색 기능 구현

<br>

## 🛠️ Stacks 
 ### Development Environment & DB
<img src="https://img.shields.io/badge/mac%20os-000000?style=for-the-badge&logo=apple&logoColor=white"><img src="https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=eclipse&logoColor=white"><img src="https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white">   
 ### Development 
<img src="https://img.shields.io/badge/Java-007396.svg?&style=for-the-badge&logo=Java&logoColor=white"><img src="https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white"><img src="https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white"><img src="https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white">
### Skills
 <img src="https://img.shields.io/badge/Amazon_AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white"><img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white">

