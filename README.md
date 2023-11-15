# EIPulse

## 專案介紹:
本專案為在資展國際期末專題，主題為EIP人事管理系統，個人負責部分，功能上有
  1. googleMapsAPI 定位打卡上下班
  2. 員工帳號登入、忘記密碼
  3. 每日自動計算出勤狀況以及出勤時數
  4. 福委會商城，結帳部分串接綠界金流服務

## 使用技術:
- 資料庫:MySQL8
- 後端:JAVA JDK17 springboot3 spring data JPA 
- 前端:Vue3 vite boostrap5
- 第三方API:googleMaps API,ECpay


## 專案使用步驟:
- 資料庫
  將SQL語句員工資料的emaill更換為您的emaill後執行語句
  
- 後端
  開啟後專案後將application.properties第18行更換成您的maill，第19行API Key則是更換成maill申請獲得的key，(本專案使用的是google Maill API)，並將 LoginService.java 中第55行 maill更換為您的後即可run。

- 前端
  開啟後將 src/main.js 第23行 googleMaps API Key 更換為您在 google API 服務中取得的 key，之後
  1. npm run install
  2. npm run dev
  3. 即可執行專案
 
## 與我聯絡
如有任何問題，請與我聯絡 d0981843347@gmail.com

小組專案連結：https://github.com/YenYasir/EIPulse_Vue_SpringBoot



  
