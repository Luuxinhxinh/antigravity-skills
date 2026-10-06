# 🧠 Antigravity Skills Hub

Kho lưu trữ và bộ sưu tập các kỹ năng (Skills) chuyên sâu dành cho **Antigravity AI Agent** & Claude Code, được tuyển chọn, tối ưu hóa và phân loại khoa học theo từng nhóm nhiệm vụ thực tế.

---

## 📂 Phân loại Danh mục Kỹ năng (Taxonomy by Capability)

### 🎨 1. UI / UX & Frontend Engineering
Bộ kỹ năng thiết kế giao diện, tuân thủ design system, token màu sắc, typography và chống các lỗi frontend phổ biến.
- **[`ui-ux`](./ui-ux/)** *(Nguồn: evondev/evondevKit)*: Tối ưu UI/UX, audit checklist design, layout micro-interactions, tokens và chuẩn web design hiện đại.
- **[`prototype`](./prototype/)**: Tạo nhanh bản prototype throwaway để kiểm chứng logic, luồng người dùng hoặc giao diện.
- **[`understand-figma`](./understand-figma/)**: Kết nối, scan và trích xuất cấu trúc component từ Figma design sang dự án.

---

### 🔍 2. Codebase Understanding & Architecture Analysis
Bộ kỹ năng quét, lập chỉ mục và phân tích toàn diện mã nguồn từ macro đến micro (Nguồn: *Egonex-AI/Understand-Anything*).
- **[`understand`](./understand/)**: Engine lõi quét toàn bộ dự án, trích xuất cấu trúc đa ngôn ngữ/framework và lập bản đồ kiến trúc.
- **[`understand-dashboard`](./understand-dashboard/)**: Trực quan hóa kiến trúc codebase dạng interactive dashboard.
- **[`understand-domain`](./understand-domain/)**: Lập bản đồ miền nghiệp vụ (domain logic, entities, aggregates).
- **[`understand-explain`](./understand-explain/)**: Giải thích chuyên sâu một tính năng, luồng dữ liệu hoặc mô-đun code phức tạp.
- **[`understand-diff`](./understand-diff/)**: Phân tích ngữ cảnh kiến trúc chịu tác động bởi git diff / PR.
- **[`understand-onboard`](./understand-onboard/)**: Lộ trình hướng dẫn onboard nhanh cho developer mới vào codebase.
- **[`understand-knowledge`](./understand-knowledge/)**: Phân tích và hợp nhất knowledge graph từ tài liệu dự án.
- **[`understand-chat`](./understand-chat/)**: Trợ lý hỏi đáp ngữ cảnh chuyên sâu dựa trên graph codebase.
- **[`codebase-design`](./codebase-design/)**: Thiết kế deep modules, giảm độ phức tạp bề mặt và tối ưu khả năng bảo trì.
- **[`improve-codebase-architecture`](./improve-codebase-architecture/)**: Đánh giá và tái cấu trúc kiến trúc hệ thống hiện hữu.
- **[`domain-modeling`](./domain-modeling/)**: Xây dựng mô hình miền, định nghĩa CONTEXT.md và ADRs chuẩn mực.

---

### 🔎 3. Code Review & Quality Assurance
Bộ công cụ kiểm tra chất lượng code, bảo mật, chuẩn coding và đánh giá PR tự động.
- **[`open-code-review-alibaba`](./open-code-review-alibaba/)** *(Nguồn: alibaba/open-code-review)*: Hệ thống review code chuẩn enterprise của Alibaba, phân tích logic, hiệu năng và rủi ro.
- **[`open-code-review-delegate`](./open-code-review-delegate/)**: Điều phối các sub-agent chuyên trách chạy review song song.
- **[`code-review`](./code-review/)**: Review code 2 chiều độc lập: Coding Standards vs Spec/Issue.
- **[`ponytail-review`](./ponytail-review/)**: Review loại bỏ over-engineering, code rác và abstraction thừa.

---

### 🪓 4. Ponytail Philosophy (KISS & Minimalist Dev)
Triết lý tối giản hóa code: ưu tiên standard library, loại bỏ dependencies thừa, giữ codebase tinh gọn.
- **[`ponytail`](./ponytail/)**: Ép Agent đưa ra giải pháp lười nhất nhưng hoạt động hoàn hảo, ngắn gọn và chuẩn native.
- **[`ponytail-audit`](./ponytail-audit/)**: Quét toàn bộ repo tìm điểm over-engineering cần xóa bớt.
- **[`ponytail-debt`](./ponytail-debt/)**: Quản lý sổ nợ kỹ thuật (debt ledger) từ các điểm đánh dấu `ponytail:`.
- **[`ponytail-gain`](./ponytail-gain/)**: Bảng điểm thống kê lượng code, chi phí và thời gian tiết kiệm được.
- **[`ponytail-help`](./ponytail-help/)**: Tra cứu nhanh cách dùng các chế độ của Ponytail.

---

### 🧪 5. Debugging & Testing
Chẩn đoán lỗi hóc búa, rò rỉ bộ nhớ và quy trình kiểm thử chuẩn mực.
- **[`diagnosing-bugs`](./diagnosing-bugs/)**: Vòng lặp chẩn đoán nguyên nhân gốc rễ (root cause) cho bug khó và regression.
- **[`tdd`](./tdd/)**: Phát triển hướng kiểm thử (Test-Driven Development) với chu trình Red - Green - Refactor.
- **[`migrate-to-shoehorn`](./migrate-to-shoehorn/)**: Chuẩn hóa type testing bằng cách thay thế type assertion `as` bằng `@total-typescript/shoehorn`.

---

### 🛡️ 6. Workflow, Git Guardrails & Setup
Tự động hóa luồng làm việc, thiết lập hook an toàn và môi trường phát triển.
- **[`git-guardrails-claude-code`](./git-guardrails-claude-code/)**: Hook bảo vệ, ngăn chặn các lệnh git nguy hiểm (`push --force`, `reset --hard`).
- **[`resolving-merge-conflicts`](./resolving-merge-conflicts/)**: Hướng dẫn giải quyết xung đột khi merge / rebase an toàn.
- **[`setup-pre-commit`](./setup-pre-commit/)**: Cài đặt Husky, lint-staged, Prettier và test commit-time.
- **[`setup-matt-pocock-skills`](./setup-matt-pocock-skills/)**: Bộ công cụ thiết lập môi trường theo phong cách Matt Pocock.

---

### 🎯 7. Planning, Grilling & Specification
Chuyển đổi ý tưởng thành tài liệu đặc tả, task thực thi và phản biện giải pháp.
- **[`grilling`](./grilling/) / [`grill-me`](./grill-me/)**: Chất vấn và phản biện không khoan nhượng về plan hoặc kiến trúc.
- **[`grill-with-docs`](./grill-with-docs/)**: Phản biện dựa trên tài liệu chính thống.
- **[`to-spec`](./to-spec/)**: Biến ý tưởng thô thành bản đặc tả kỹ thuật chi tiết.
- **[`to-tickets`](./to-tickets/)**: Bẻ nhỏ spec thành các issue/vé Jira/GitHub rõ ràng.
- **[`to-questionnaire`](./to-questionnaire/)**: Khảo sát làm rõ yêu cầu trước khi bắt tay viết code.
- **[`triage`](./triage/)**: Sàng lọc, đánh giá mức độ nghiêm trọng và phân loại bug/issue.
- **[`wayfinder`](./wayfinder/)**: Định hướng đường đi và cấu trúc module khi bắt đầu dự án mới.

---

### 📚 8. Learning, Teaching & Agent Configuration
Chia sẻ kiến thức, viết hướng dẫn và cấu hình hệ sinh thái Agent.
- **[`agy-customizations`](./agy-customizations/)**: Cẩm nang thiết kế Skill, Rule, Plugin, Hook cho Antigravity IDE.
- **[`antigravity_guide`](./antigravity_guide/)**: Cẩm nang toàn diện về Antigravity IDE & CLI.
- **[`writing-for-agents`](./writing-for-agents/)**: Hướng dẫn viết tài liệu và prompts tối ưu cho AI Agents đọc.
- **[`teach`](./teach/)**: Hướng dẫn và giải thích kiến thức lập trình chuyên sâu.
- **[`ask-matt`](./ask-matt/)**: Tham vấn phong cách giải quyết vấn đề của Matt Pocock.
- **[`scaffold-exercises`](./scaffold-exercises/)**: Tạo khung bài tập thực hành lập trình kèm lời giải mẫu.
- **[`wizard`](./wizard/)**: Tạo bash wizard tương tác cho các bước cài đặt thủ công.
- **[`wait-what`](./wait-what/)**: Đặt câu hỏi dừng lại để kiểm tra giả định trước khi đi sai hướng.
- **[`handoff`](./handoff/)**: Tạo bản bàn giao ngữ cảnh liền mạch cho agent khác hoặc developer khác.
- **[`implement`](./implement/)**: Thực thi tác vụ theo quy trình kiểm thử và chất lượng cao.

---

## ⚡ Cài đặt nhanh trong 10 giây (Quick Install)

Chỉ cần mở Terminal / PowerShell và dán **1 dòng lệnh duy nhất**, toàn bộ 49+ skills và Bộ điều phối `skill-router` sẽ tự động được tải và cấu hình hoàn chỉnh vào Antigravity IDE:

### 🪟 Windows (PowerShell):
```powershell
irm https://raw.githubusercontent.com/Luuxinhxinh/antigravity-skills/main/install.ps1 | iex
```

### 🐧 Linux / macOS (Bash / Zsh):
```bash
curl -fsSL https://raw.githubusercontent.com/Luuxinhxinh/antigravity-skills/main/install.sh | bash
```

---

## 🚀 Kích hoạt & Sử dụng trong hội thoại

- **Tự động (Autonomous Routing):** Bộ điều phối `skill-router` luôn chạy ngầm để nhận diện intent và kích hoạt skill phù hợp (ví dụ: khi yêu cầu thiết kế UI, tối ưu KISS code, chẩn đoán lỗi hay review code).
- **Thủ công (Manual / Slash Commands):** Bạn có thể gõ trực tiếp tên lệnh ở đầu prompt:
  - `/ui-ux` — Thiết kế giao diện, layout, design tokens, micro-interactions.
  - `/understand` — Khảo sát và phân tích bản đồ cấu trúc toàn bộ codebase.
  - `/open-code-review` — Review code chuẩn enterprise của Alibaba.
  - `/ponytail` — Tối ưu code theo phong cách cực kỳ tinh gọn, không boilerplate.
  - `/tdd` — Phát triển theo chu trình Test-Driven Development (Red-Green-Refactor).

