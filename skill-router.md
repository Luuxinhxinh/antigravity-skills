# Skill Auto-Routing, Proactive Recommendation & Status Tracking

Quy tắc bắt buộc về việc nhận diện, tự kích hoạt, điều phối quản lý Skill và hiển thị trạng thái:

---

## 0. Lưới lọc Ý định: Phân biệt Câu hỏi (Inquiry) và Lệnh hành động (Execution)
Trước khi kích hoạt bất kỳ Tool can thiệp hệ thống (chạy terminal, tải package, cài extension, sửa code, tạo file) hoặc Skill hành động nào, Agent BẮT BUỘC phải phân loại ý định người dùng qua lưới lọc:

- **Loại 1: INQUIRY / DISCOVERY (Khảo sát, tham vấn, hỏi thông tin)**
  * *Dấu hiệu:* "có ... được không?", "có cách nào...", "có extension/thư viện nào...", "tính năng này là gì?", "dùng kiểu gì?"...
  * *Quy tắc:* **TUYỆT ĐỐI KHÔNG tự ý kích hoạt tool thực thi/cài đặt/can thiệp máy tính.** Chỉ trả lời tư vấn, giải thích nguyên lý, liệt kê các giải pháp khả thi và ưu/nhược điểm. Nếu muốn làm, phải hỏi xác nhận từ người dùng trước.
  
- **Loại 2: EXECUTION / ACTION (Yêu cầu hành động rõ ràng)**
  * *Dấu hiệu:* "cài cái A đi", "tạo file X", "sửa lỗi này", "chạy lệnh...", "triển khai phương án này"...
  * *Quy tắc:* Được phép kích hoạt Tool/Skill tương ứng để thực hiện nhiệm vụ.

- **Loại 3: CONFIRMATION (Xác nhận sau tư vấn)**
  * Khi người dùng đồng ý ("ok", "làm đi", "triển khai đi"), Agent mới chuyển trạng thái từ Tư vấn sang Hành động.

---

## 1. Cơ chế Tự động Kích hoạt & Điều phối (Autonomous Routing & Management)
Khi nhận yêu cầu thuộc nhóm **EXECUTION / ACTION** từ người dùng, Agent PHẢI chủ động đối chiếu với danh sách các skills hiện có và tự động đọc file `SKILL.md` tương ứng để thực hiện chuẩn quy trình:

### 🎨 Nhóm 1: Giao diện, Trải nghiệm & Frontend
- **Yêu cầu UI/UX, redesign, dựng trang, thẩm mỹ, design tokens:** ➔ Tự kích hoạt **`ui-ux`**.
- **Tạo mockup/prototype thô kiểm chứng ý tưởng hoặc flow:** ➔ Tự kích hoạt **`prototype`**.
- **Chuyển thiết kế từ Figma sang code/components:** ➔ Tự kích hoạt **`understand-figma`**.

### 🔍 Nhóm 2: Thấu hiểu Codebase & Kiến trúc Dự án
- **Phân tích toàn diện dự án, vẽ bản đồ cấu trúc tổng thể:** ➔ Tự kích hoạt **`understand`**.
- **Trực quan hóa kiến trúc codebase dạng dashboard:** ➔ Tự kích hoạt **`understand-dashboard`**.
- **Lập bản đồ miền nghiệp vụ, domain logic, entities:** ➔ Tự kích hoạt **`understand-domain`** hoặc **`domain-modeling`**.
- **Giải thích sâu một tính năng, luồng dữ liệu phức tạp:** ➔ Tự kích hoạt **`understand-explain`**.
- **Phân tích tác động kiến trúc của Git diff / PR:** ➔ Tự kích hoạt **`understand-diff`**.
- **Tạo tài liệu / lộ trình onboard cho người mới:** ➔ Tự kích hoạt **`understand-onboard`**.
- **Trích xuất / hợp nhất knowledge graph từ docs:** ➔ Tự kích hoạt **`understand-knowledge`**.
- **Thiết kế Deep Modules, Seam, giảm độ phức tạp bề mặt:** ➔ Tự kích hoạt **`codebase-design`**.
- **Tái cấu trúc kiến trúc tổng thể của hệ thống:** ➔ Tự kích hoạt **`improve-codebase-architecture`**.

### 🔎 Nhóm 3: Kiểm duyệt Code (Code Review) & Đảm bảo Chất lượng
- **Review toàn diện logic, performance, security theo chuẩn enterprise:** ➔ Tự kích hoạt **`open-code-review-alibaba`**.
- **Review song song bằng sub-agents chuyên trách:** ➔ Tự kích hoạt **`open-code-review-delegate`**.
- **Review theo 2 trục: Coding Standards vs Spec yêu cầu:** ➔ Tự kích hoạt **`code-review`**.
- **Review loại bỏ code thừa, over-engineering, dependencies rác:** ➔ Tự kích hoạt **`ponytail-review`**.

### 🪓 Nhóm 4: Triết lý Tối giản Ponytail (KISS & Minimalist Dev)
- **Tối ưu code ngắn nhất, lười nhất, dùng stdlib/native, bỏ bloat:** ➔ Tự kích hoạt **`ponytail`**.
- **Audit toàn bộ codebase tìm điểm over-engineering:** ➔ Tự kích hoạt **`ponytail-audit`**.
- **Thu thập và quản lý nợ kỹ thuật (`ponytail:` comments):** ➔ Tự kích hoạt **`ponytail-debt`**.

### 🧪 Nhóm 5: Chẩn đoán Lỗi (Debugging) & Kiểm thử (Testing)
- **Truy tìm nguyên nhân gốc rễ bug khó, crash, regression:** ➔ Tự kích hoạt **`diagnosing-bugs`**.
- **Xây dựng tính năng theo chuẩn Test-Driven Development (TDD):** ➔ Tự kích hoạt **`tdd`**.
- **Chuẩn hóa type test, loại bỏ type assertion `as`:** ➔ Tự kích hoạt **`migrate-to-shoehorn`**.

### 🛡️ Nhóm 6: Quy trình, An toàn Git & Điều phối Tác vụ Lớn
- **Ngăn chặn lệnh Git phá hủy (`push --force`, `reset --hard`):** ➔ Tự kích hoạt **`git-guardrails-claude-code`**.
- **Xử lý xung đột code khi git merge/rebase:** ➔ Tự kích hoạt **`resolving-merge-conflicts`**.
- **Lập bản đồ ra quyết định cho việc lớn xuyên nhiều session:** ➔ Tự kích hoạt **`wayfinder`**.
- **Phân loại, sàng lọc issue / pull request theo state machine:** ➔ Tự kích hoạt **`triage`**.
- **Bàn giao phiên làm việc cho agent tiếp theo:** ➔ Tự kích hoạt **`handoff`**.

---

## 2. Chủ động gợi ý (Proactive Suggestion)
- Trong trường hợp một tác vụ phức tạp có thể hưởng lợi từ một skill chuyên biệt:
  * Agent trả lời ngắn gọn giải pháp cơ bản.
  * ĐỒNG THỜI chủ động gợi ý 1-2 skills liên quan ở cuối câu trả lời:
    > 💡 *Gợi ý: Tác vụ này có thể dùng skill `[tên-skill]` để [lợi ích ngắn gọn]. Bạn có muốn kích hoạt quy trình này không?*
- Tuyệt đối không tự động kích hoạt các skill phỏng vấn/chất vấn (`grilling`, `grill-me`) trừ khi người dùng đồng ý hoặc chủ động yêu cầu.

---

## 3. BẮT BUỘC: Hiển thị Skill đã áp dụng ở cuối mỗi phản hồi
Ở dòng cuối cùng của MỌI câu trả lời, Agent BẮT BUỘC phải chèn một dòng trạng thái hiển thị rõ ràng skill/quy tắc nào đã được áp dụng trong lượt trả lời đó, theo định dạng:

`⚡ Skill áp dụng: [tên skill hoặc quy tắc được dùng] (hoặc "None" nếu là câu hỏi trò chuyện thông thường)`

*Ví dụ:*
- `⚡ Skill áp dụng: ui-ux`
- `⚡ Skill áp dụng: understand, understand-explain`
- `⚡ Skill áp dụng: open-code-review-alibaba`
- `⚡ Skill áp dụng: ponytail, codebase-design`
- `⚡ Skill áp dụng: diagnosing-bugs`
- `⚡ Skill áp dụng: None`
