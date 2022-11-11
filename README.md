# iOS 프로젝트 - 음식 메뉴 추천 앱

<br>

## 앱 실행 영상 (GIF)
![IOS_MealPicker_Demo_Final2](https://user-images.githubusercontent.com/30224335/201288722-64bb7e4d-427b-47a4-9d39-c51a54013a37.gif)

<br>

## 개발 과정

### 1. 기획 단계
<img width="757" alt="Screen Shot 2022-11-07 at 5 46 30 PM" src="https://user-images.githubusercontent.com/30224335/200274217-4ea1cf52-3826-445c-8f84-45347604b255.png">

### 2. 디자인 및 와이어프레임 단계
<img width="1165" alt="Screen Shot 2022-11-07 at 5 47 49 PM" src="https://user-images.githubusercontent.com/30224335/200274242-67120b12-d9a2-448b-8a1c-b0b7a5d15ee2.png">

### 3. 개발 단계
- 체크리스트, 이슈 별 기능 추가 및 소스코드 관리
<img width="624" alt="Screen Shot 2022-11-07 at 6 01 50 PM" src="https://user-images.githubusercontent.com/30224335/200274280-a97af3e2-5044-4416-af18-aeb7e1c76fd2.png">

### 4. 구현 특징 (사용자 경험 최적화)

- **다이나믹한 선택 경험**을 위해 선택지 제시 순서 랜덤화

![random_option_order](https://user-images.githubusercontent.com/30224335/200274322-7b9bb87f-55f0-4a54-8420-7b6559207e3d.jpg)

- 선택지에 해당하는 음식이 남아있지 않은 경우, 해당 선택지를 제외하고 표시

![dynamic_option_count](https://user-images.githubusercontent.com/30224335/200274342-dd655c2e-d075-4d58-9e14-6d0f3e2d569c.jpg)

- 선택지에 따라 시간 제한을 두어 고민 과정을 단축
