# Corsair Call

## 목차
- [요약](#요약)
- [진행 상황](#진행-상황)
- [구현 결과](#구현-결과)
- [트러블 슈팅](#트러블-슈팅)
- [학습한 내용](#학습한-내용)
- [느낀 점](#느낀-점)

---

## 요약

| Index         | Detail                              |
|---------------|-------------------------------------|
| **기여도**     | 100% (1인 개발)                     |
| **앱의 목적**   | 영상통화를 제공하는 Flutter 앱         |
| **구현 기간**  | **2024.1.2 ~ 2025.1.5**            |
| **기술 스택**  | Flutter / Dart / Agora API / WebRTC / Permission |
| **Pain Point** | 권한 요청 및 Agora API 통합 문제 해결 필요 |
| **해결 방법**  | 권한 요청 프로세스 개선, 비동기 처리 최적화 |
| **아쉬운 점**  | UI 디자인의 간소화 및 테스트 부족     |

---

## 진행 상황

| 날짜                     | 내용                            |
|--------------------------|---------------------------------|
| **2024.1.2**             | UI 기본 설계 및 화면 구성        |
| **2024.1.3 ~ 2024.1.4**  | 권한 요청 및 Agora API 연결      |
| **2024.1.5**             | 코드 리팩토링 및 기능 완성       |

---

## 구현 결과

### 구현

| UI 그리기                  | 권한 허가 받기                | 앱 완성                      |
|:--------------------------:|:----------------------------:|:---------------------------:|
| <img src="https://github.com/user-attachments/assets/d414af91-f717-40b5-ba7d-abe8a8101bfc" width=300/> | <img src="https://github.com/user-attachments/assets/326a3b09-726b-46f6-9c98-c99c70d8664c" width=300/> | <img src="https://github.com/user-attachments/assets/0c38e76f-3c05-442d-bf21-436e07186687" width=300/> |

---

## 트러블 슈팅

### 문제 1: 권한 요청 실패
- **원인**: 권한 요청 상태 확인 방식의 오류 및 비동기 처리 누락.
- **해결 방법**: 권한 상태 확인 코드를 수정하고, `FutureBuilder`에서 에러 메시지를 명확히 출력하도록 개선.

---

### 문제 2: Agora API 연결 불안정
- **원인**: `RtcEngine` 초기화가 비동기로 처리되지 않아 불완전한 상태로 진행됨.
- **해결 방법**: `RtcEngine` 초기화 및 `joinChannel` 호출을 `await`로 처리하여 안정성 확보.

---

### 문제 3: UI 최적화 부족
- **원인**: `renderLocalView`와 `renderRemoteView`의 크기 및 정렬이 불완전.
- **해결 방법**: `Stack` 및 `Align` 위젯을 조정하여 UI를 직관적으로 배치.

---

## 학습한 내용

### 1. Flutter 비동기 처리
- `FutureBuilder`와 `async/await`의 올바른 사용법 학습.
- 권한 요청 상태를 비동기로 처리하는 패턴 이해.

### 2. Agora SDK
- Agora API를 사용한 영상통화 구현 방법 학습.
- `RtcEngine` 초기화 및 이벤트 핸들링 구현.

### 3. Permission Handler
- `permission_handler` 패키지를 활용한 카메라 및 마이크 권한 요청 방법.

---

## 느낀 점

- Agora API를 처음 사용했지만, 문서와 튜토리얼을 참고하며 많은 것을 배울 수 있었다.
- 비동기 처리가 앱의 안정성에 큰 영향을 미친다는 것을 체감했다.
- 권한 요청 및 에러 처리를 제대로 구현하는 것이 사용자 경험에 매우 중요하다는 점을 깨달았다.
- 앞으로는 UI/UX 디자인에도 더 신경을 쓰고 싶다.
